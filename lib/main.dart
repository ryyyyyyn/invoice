import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice/core/theme/app_theme.dart';
import 'package:invoice/presentation/routes/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Invoice Pro',
      theme: AppTheme.darkNeonTheme,
      routerConfig: appRouter,
    );
  }
}
