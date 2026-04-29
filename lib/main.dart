import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const PasaheroApp());
}

class PasaheroApp extends StatelessWidget {
  const PasaheroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pasahero',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
      // Clamp system text scale so the app's own responsive scaling takes over.
      // Users with accessibility needs can still scale up to 1.3×.
      // Also applies the responsive theme (button/input sizes) for the device.
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final clampedScale = mediaQuery.textScaler.clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.3,
        );
        return Theme(
          data: AppTheme.responsive(context),
          child: MediaQuery(
            data: mediaQuery.copyWith(textScaler: clampedScale),
            child: child!,
          ),
        );
      },
    );
  }
}
