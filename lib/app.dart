import 'package:flutter/material.dart';

import 'l10n/l10n.dart';
import 'screens/connect_screen.dart';
import 'screens/home/home_shell.dart';
import 'screens/welcome_screen.dart';
import 'state/session.dart';
import 'theme.dart';
import 'widgets/common.dart';

class MyShineApp extends StatelessWidget {
  const MyShineApp({super.key, required this.session, this.linkCode});

  final Session session;

  /// The code from the link in the clinic's email (`…/#ABCD-2345`, web only):
  /// someone not yet connected starts on the connect screen with it typed.
  final String? linkCode;

  @override
  Widget build(BuildContext context) {
    return SessionScope(
      session: session,
      child: MaterialApp(
        title: 'myShine',
        debugShowCheckedModeBanner: false,
        theme: buildShineTheme(Brightness.light),
        darkTheme: buildShineTheme(Brightness.dark),
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: resolveAppLocale,
        home: _Root(linkCode: linkCode),
      ),
    );
  }
}

/// Welcome without an account; the tabs once connected with the clinic.
class _Root extends StatefulWidget {
  const _Root({this.linkCode});

  final String? linkCode;

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  bool _linkHandled = false;

  /// Once the session is known: the code from the link opens the connect
  /// screen, unless the patient is already connected. Used once.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final session = SessionScope.of(context);
    if (_linkHandled || !session.isReady) {
      return;
    }
    _linkHandled = true;
    final code = widget.linkCode;
    if (code == null || session.isConnected) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ConnectScreen(initialCode: code),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    if (!session.isReady) {
      return const Scaffold(body: Center(child: Wordmark(size: 34)));
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: session.isConnected
          ? HomeShell(
              key: ValueKey(session.baseUrl),
              api: session.client,
              reminders: session.reminders,
            )
          : const WelcomeScreen(),
    );
  }
}
