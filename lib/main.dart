import 'package:flutter/material.dart';
import 'router.dart';

void main() {
  runApp(const PasaheroApp());
}

class PasaheroApp extends StatelessWidget {
  const PasaheroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pasahero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00409A), // hsl(213,100%,30%)
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      routerConfig: appRouter,
    );
  }
}
