import 'package:flutter/material.dart';

/// Breakpoints
/// Mobile:  < 600px
/// Tablet:  600px – 1024px
/// Laptop:  1024px – 1440px
/// Desktop: 1440px – 1800px
/// TV:      >= 1800px

enum DeviceType { mobile, tablet, laptop, desktop, tv }

class Responsive {
  // ── Device detection ────────────────────────────────────────────────────────

  static DeviceType of(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1800) return DeviceType.tv;
    if (w >= 1440) return DeviceType.desktop;
    if (w >= 1024) return DeviceType.laptop;
    if (w >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) =>
      of(context) == DeviceType.tablet;
  static bool isLaptop(BuildContext context) =>
      of(context) == DeviceType.laptop;
  static bool isDesktop(BuildContext context) =>
      of(context) == DeviceType.desktop;
  static bool isTv(BuildContext context) => of(context) == DeviceType.tv;

  /// True for tablet and above (anything with a side nav)
  static bool isWide(BuildContext context) => of(context) != DeviceType.mobile;

  /// True for laptop and above (full desktop-style layout)
  static bool isLargeScreen(BuildContext context) {
    final t = of(context);
    return t == DeviceType.laptop ||
        t == DeviceType.desktop ||
        t == DeviceType.tv;
  }

  // ── Spacing ─────────────────────────────────────────────────────────────────

  /// Horizontal padding that scales with screen width.
  /// On very large screens content is centered with a max-width cap.
  static double hPad(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1800) return (w - _maxContentWidth(w)) / 2;
    if (w >= 1440) return (w - _maxContentWidth(w)) / 2;
    if (w >= 1024) return (w - _maxContentWidth(w)) / 2;
    if (w >= 600) return 32.0;
    return 20.0;
  }

  static double _maxContentWidth(double w) {
    if (w >= 1800) return 1400.0;
    if (w >= 1440) return 1200.0;
    return 960.0; // laptop
  }

  /// Max content width for centered layouts
  static double maxWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1800) return 1400.0;
    if (w >= 1440) return 1200.0;
    if (w >= 1024) return 960.0;
    if (w >= 600) return w - 64.0;
    return w;
  }

  // ── Typography ──────────────────────────────────────────────────────────────

  /// Multiplier for font sizes — apply to base sizes for proportional scaling.
  static double fontScale(BuildContext context) {
    switch (of(context)) {
      case DeviceType.tv:
        return 1.6;
      case DeviceType.desktop:
        return 1.25;
      case DeviceType.laptop:
        return 1.1;
      case DeviceType.tablet:
        return 1.05;
      case DeviceType.mobile:
        return 1.0;
    }
  }

  /// Scaled font size helper — pass the mobile base size.
  static double fontSize(BuildContext context, double base) =>
      (base * fontScale(context)).roundToDouble();

  // ── Layout ──────────────────────────────────────────────────────────────────

  /// Card grid column count
  static int gridCols(BuildContext context) {
    switch (of(context)) {
      case DeviceType.tv:
        return 4;
      case DeviceType.desktop:
        return 4;
      case DeviceType.laptop:
        return 3;
      case DeviceType.tablet:
        return 2;
      case DeviceType.mobile:
        return 1;
    }
  }

  /// Icon size that scales with device
  static double iconSize(BuildContext context, {double base = 24}) {
    switch (of(context)) {
      case DeviceType.tv:
        return base * 1.8;
      case DeviceType.desktop:
        return base * 1.4;
      case DeviceType.laptop:
        return base * 1.15;
      case DeviceType.tablet:
        return base * 1.05;
      case DeviceType.mobile:
        return base;
    }
  }

  /// Button / input height
  static double buttonHeight(BuildContext context) {
    switch (of(context)) {
      case DeviceType.tv:
        return 80.0;
      case DeviceType.desktop:
        return 64.0;
      case DeviceType.laptop:
        return 56.0;
      case DeviceType.tablet:
        return 52.0;
      case DeviceType.mobile:
        return 52.0;
    }
  }

  /// Vertical spacing unit (base = 8px grid)
  static double spacing(BuildContext context, {double units = 1}) {
    final base = switch (of(context)) {
      DeviceType.tv => 16.0,
      DeviceType.desktop => 12.0,
      DeviceType.laptop => 10.0,
      DeviceType.tablet => 9.0,
      DeviceType.mobile => 8.0,
    };
    return base * units;
  }

  /// Border radius that scales with device
  static double radius(BuildContext context, {double base = 12}) {
    switch (of(context)) {
      case DeviceType.tv:
        return base * 1.5;
      case DeviceType.desktop:
        return base * 1.25;
      case DeviceType.laptop:
        return base * 1.1;
      case DeviceType.tablet:
        return base;
      case DeviceType.mobile:
        return base;
    }
  }

  /// Side navigation width
  static double navWidth(BuildContext context) {
    switch (of(context)) {
      case DeviceType.tv:
        return 320.0;
      case DeviceType.desktop:
        return 260.0;
      case DeviceType.laptop:
        return 220.0;
      case DeviceType.tablet:
        return 72.0; // icon-only rail
      case DeviceType.mobile:
        return 0.0;
    }
  }

  /// Whether the side nav should show labels (not icon-only)
  static bool navShowsLabels(BuildContext context) => isLargeScreen(context);

  /// Logo size in nav / headers
  static double logoSize(BuildContext context) {
    switch (of(context)) {
      case DeviceType.tv:
        return 64.0;
      case DeviceType.desktop:
        return 48.0;
      case DeviceType.laptop:
        return 40.0;
      case DeviceType.tablet:
        return 36.0;
      case DeviceType.mobile:
        return 36.0;
    }
  }
}

// ── Responsive Widgets ────────────────────────────────────────────────────────

/// Wraps content in a centered, max-width container for tablet/desktop/TV
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final mw = maxWidth ?? Responsive.maxWidth(context);
    final hp = Responsive.hPad(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: mw),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: hp),
          child: child,
        ),
      ),
    );
  }
}

/// Two-column layout for tablet/desktop, single column for mobile
class ResponsiveSplit extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double gap;

  const ResponsiveSplit({
    super.key,
    required this.left,
    required this.right,
    this.gap = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          left,
          SizedBox(height: gap),
          right,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: gap),
        Expanded(child: right),
      ],
    );
  }
}

/// Builds different widgets per device tier.
/// Provide at minimum [mobile]. Unspecified tiers fall back to the next
/// smaller tier (tv → desktop → laptop → tablet → mobile).
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext) mobile;
  final Widget Function(BuildContext)? tablet;
  final Widget Function(BuildContext)? laptop;
  final Widget Function(BuildContext)? desktop;
  final Widget Function(BuildContext)? tv;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.laptop,
    this.desktop,
    this.tv,
  });

  @override
  Widget build(BuildContext context) {
    final type = Responsive.of(context);
    switch (type) {
      case DeviceType.tv:
        return (tv ?? desktop ?? laptop ?? tablet ?? mobile)(context);
      case DeviceType.desktop:
        return (desktop ?? laptop ?? tablet ?? mobile)(context);
      case DeviceType.laptop:
        return (laptop ?? tablet ?? mobile)(context);
      case DeviceType.tablet:
        return (tablet ?? mobile)(context);
      case DeviceType.mobile:
        return mobile(context);
    }
  }
}
