import 'package:flutter/material.dart';
import 'bottom_navigation.dart';

class RootLayout extends StatelessWidget {
  final Widget child;
  const RootLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, bottomNavigationBar: const BottomNavBar());
  }
}
