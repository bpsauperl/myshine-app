import 'package:flutter/material.dart';

import '../../api/api_client.dart';
import '../../state/me_controller.dart';
import '../../state/session.dart';
import '../../widgets/common.dart';
import 'documents_tab.dart';
import 'messages_tab.dart';
import 'plan_tab.dart';
import 'profile_tab.dart';
import 'schedule_tab.dart';
import 'today_tab.dart';

/// The connected app: six tabs over one `/me` load.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.api, this.onUnauthorized});

  final ApiClient api;

  /// Defaults to forgetting the session's token.
  final Future<void> Function()? onUnauthorized;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final MeController _me = MeController(
    api: widget.api,
    onUnauthorized: () async {
      if (widget.onUnauthorized != null) {
        await widget.onUnauthorized!();
      } else if (mounted) {
        await SessionScope.of(context).handleUnauthorized();
      }
    },
  );
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _me.refresh();
  }

  @override
  void dispose() {
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
                          title: 'We couldn\'t load myShine',
                          body: _me.error!.message,
                          actionLabel: 'Try again',
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
          TodayTab(me: _me),
          PlanTab(me: _me),
          ScheduleTab(me: _me),
          MessagesTab(api: widget.api, active: _index == 3),
          DocumentsTab(me: _me),
          ProfileTab(me: _me),
        ];
        return Scaffold(
          body: IndexedStack(
            index: _index,
            children: [
              for (var i = 0; i < tabs.length; i++)
                TickerMode(enabled: i == _index, child: tabs[i]),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _select,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.wb_sunny_outlined),
                selectedIcon: Icon(Icons.wb_sunny_rounded),
                label: 'Today',
              ),
              const NavigationDestination(
                icon: Icon(Icons.view_in_ar_outlined),
                selectedIcon: Icon(Icons.view_in_ar_rounded),
                label: 'Plan',
              ),
              const NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded),
                label: 'Schedule',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text('$unread'),
                  child: const Icon(Icons.chat_bubble_outline_rounded),
                ),
                selectedIcon: const Icon(Icons.chat_bubble_rounded),
                label: 'Messages',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: pending > 0,
                  label: Text('$pending'),
                  child: const Icon(Icons.description_outlined),
                ),
                selectedIcon: const Icon(Icons.description_rounded),
                label: 'Documents',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
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
