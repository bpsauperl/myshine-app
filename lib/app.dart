import 'package:flutter/material.dart';

import 'screens/home/home_shell.dart';
import 'screens/welcome_screen.dart';
import 'state/session.dart';
import 'theme.dart';
import 'widgets/common.dart';

class MyShineApp extends StatelessWidget {
  const MyShineApp({super.key, required this.session});

  final Session session;

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
        home: const _Root(),
      ),
    );
  }
}

/// Welcome without an account; the tabs once connected with the clinic.
class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    if (!session.isReady) {
      return const Scaffold(body: Center(child: Wordmark(size: 34)));
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: session.isConnected
          ? HomeShell(key: ValueKey(session.baseUrl), api: session.client)
          : const WelcomeScreen(),
    );
  }
}
