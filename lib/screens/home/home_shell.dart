import 'dart:async';

import 'package:flutter/material.dart';

import '../../api/api_client.dart';
import '../../l10n/l10n.dart';
import '../../reminders/reminder_plan.dart';
import '../../reminders/reminders.dart';
import '../../state/me_controller.dart';
import '../../state/session.dart';
import '../../widgets/common.dart';
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
    },
  );
  int _index = 0;

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
        final unread = data.unreadMessages;
        final pending = data.consents.where((c) => !c.isSigned).length;
        final tabs = <Widget>[
          TodayTab(me: _me, onOpenTab: _select),
          PlanTab(me: _me),
          ScheduleTab(me: _me),
          MessagesTab(api: widget.api, active: _index == 3),
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
                  minimum: const EdgeInsets.only(bottom: 26),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GlassTabBar(
                          index: _index,
                          onSelect: _select,
                          tabs: [
                            GlassTab(glyph: ShineGlyph.today, label: l10n.tabToday),
                            GlassTab(glyph: ShineGlyph.plan, label: l10n.tabPlan),
                            GlassTab(glyph: ShineGlyph.schedule, label: l10n.tabSchedule),
                            GlassTab(glyph: ShineGlyph.messages, label: l10n.tabMessages, dot: unread > 0),
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
