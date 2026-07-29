import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'config/routes.dart';
import 'config/theme.dart';

class YolcantaApp extends StatelessWidget {
  const YolcantaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Yolçanta',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      locale: const Locale('az'),
      supportedLocales: const [Locale('az'), Locale('en')],
    );
  }
}
