import 'dart:async';

import 'package:flutter/material.dart';

import '../../api/api_client.dart';
import '../../api/models.dart';
import '../../l10n/l10n.dart';
import '../../reminders/reminder_plan.dart';
import '../../reminders/reminders.dart';
import '../../state/me_controller.dart';
import '../../state/session.dart';
import '../../widgets/common.dart';
import '../rules_screen.dart';
import 'messages_tab.dart';
import 'plan_tab.dart';
import 'profile_tab.dart';
import 'schedule_tab.dart';
import 'today_tab.dart';

/// The connected app: five tabs over one `/me` load, under the floating tab bar.
class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.api,
    this.onUnauthorized,
    this.reminders = const NoReminders(),
  });

  final ApiClient api;

  /// Set again from the schedule after every load of `/me`.
  final Reminders reminders;

  /// Defaults to forgetting the session's token.
  final Future<void> Function()? onUnauthorized;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  late final MeController _me = MeController(
    api: widget.api,
    onUnauthorized: () async {
      if (widget.onUnauthorized != null) {
        await widget.onUnauthorized!();
      } else if (mounted) {
        await SessionScope.of(context).handleUnauthorized();
      }
    },
    onLoaded: (data) {
      if (!mounted) {
        return;
      }
      widget.reminders.replace(
        planReminders(
          data.therapy,
          LocalizedReminderTexts(AppLocalizations.of(context)),
          now: DateTime.now(),
        ),
      );
      _followRules(data.features);
    },
  );
  int _index = 0;

  /// Whether this phone already read the rules the server still calls unread
  /// ([_rulesVersion] of them). Null until looked up.
  bool? _rulesSeenHere;
  String? _rulesVersion;

  /// One call at a time tells the server the rules were read.
  bool _tellingRules = false;

  /// Links to documents and photos are short-lived: this keeps them fresh.
  Timer? _keepFresh;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _me.refresh();
    _keepFresh = Timer.periodic(
      const Duration(minutes: 20),
      (_) => _me.refresh(),
    );
  }

  /// Back in the app (or the browser tab is shown again): load what changed.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _me.refresh();
    }
  }

  @override
  void dispose() {
    _keepFresh?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _me.dispose();
    super.dispose();
  }

  /// The server says the rules are unread: look up whether this phone read
  /// them. If it did, the server wasn't told (or couldn't be): tell it again.
  Future<void> _followRules(Features features) async {
    if (features.rulesSeen) {
      return;
    }
    final version = features.rulesVersion;
    if (_rulesSeenHere == null || _rulesVersion != version) {
      final seen = await RulesScreen.seenHere(version);
      if (!mounted) {
        return;
      }
      setState(() {
        _rulesVersion = version;
        _rulesSeenHere = seen;
      });
    }
    if (_rulesSeenHere == true) {
      _tellRulesSeen();
    }
  }

  /// "I understand": the tabs open at once; this phone and then the server
  /// remember it.
  Future<void> _acceptRules() async {
    final version = _me.data?.features.rulesVersion;
    setState(() {
      _rulesVersion = version;
      _rulesSeenHere = true;
    });
    await RulesScreen.rememberSeen(version);
    await _tellRulesSeen();
  }

  /// Best effort: a failure never holds the patient back. While the server
  /// still says unread, the next load of `/me` tries again.
  Future<void> _tellRulesSeen() async {
    if (_tellingRules) {
      return;
    }
    _tellingRules = true;
    try {
      await widget.api.acceptRules();
    } catch (_) {
      // Tried again after a later load.
    } finally {
      _tellingRules = false;
    }
  }

  void _select(int index) {
    setState(() => _index = index);
    if (index == 3) {
      _me.markMessagesRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _me,
      builder: (context, _) {
        final l10n = context.l10n;
        final data = _me.data;
        if (data == null) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: _me.error == null
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: CalmMessage(
                          icon: Icons.wifi_off_rounded,
                          title: l10n.homeLoadError,
                          body: l10n.apiError(_me.error!),
                          actionLabel: l10n.commonTryAgain,
                          onAction: _me.refresh,
                        ),
                      ),
              ),
            ),
          );
        }
        final features = data.features;
        if (!features.rulesSeen) {
          // Before the tabs, once: the clinic's short rules.
          if (_rulesSeenHere == null || _rulesVersion != features.rulesVersion) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (_rulesSeenHere == false) {
            return RulesScreen(onAccept: _acceptRules);
          }
        }
        final unread = features.messages ? data.unreadMessages : 0;
        final pending = data.consents.where((c) => !c.isSigned).length;
        final tabs = <Widget>[
          TodayTab(me: _me, onOpenTab: _select),
          PlanTab(me: _me),
          ScheduleTab(me: _me),
          MessagesTab(
            api: widget.api,
            active: _index == 3,
            features: features,
            clinic: data.patient.clinic,
          ),
          ProfileTab(me: _me, reminders: widget.reminders),
        ];
        return Scaffold(
          body: Stack(
            children: [
              IndexedStack(
                index: _index,
                children: [
                  for (var i = 0; i < tabs.length; i++)
                    TickerMode(enabled: i == _index, child: tabs[i]),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GlassTabBar(
                          index: _index,
                          onSelect: _select,
                          tabs: [
                            GlassTab(glyph: ShineGlyph.today, label: l10n.tabToday),
                            GlassTab(glyph: ShineGlyph.plan, label: l10n.tabPlan),
                            GlassTab(glyph: ShineGlyph.schedule, label: l10n.tabSchedule),
                            GlassTab(
                              glyph: ShineGlyph.messages,
                              label: features.messages ? l10n.tabMessages : l10n.tabClinic,
                              dot: unread > 0,
                            ),
                            GlassTab(glyph: ShineGlyph.profile, label: l10n.tabProfile, dot: pending > 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A scrollable tab page with pull to refresh.
class TabPage extends StatelessWidget {
  const TabPage({super.key, required this.onRefresh, required this.children});

  final Future<void> Function() onRefresh;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 128),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
