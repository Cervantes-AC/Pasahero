import 'package:flutter/material.dart';

/// Breakpoints
/// Mobile:  < 600px
/// Tablet:  600px – 1024px
/// Desktop: > 1024px

enum DeviceType { mobile, tablet, desktop }

class Responsive {
  static DeviceType of(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return DeviceType.desktop;
    if (w >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) =>
      of(context) == DeviceType.tablet;
  static bool isDesktop(BuildContext context) =>
      of(context) == DeviceType.desktop;
  static bool isWide(BuildContext context) => of(context) != DeviceType.mobile;

  /// Horizontal padding that scales with screen width
  static double hPad(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return (w - 960) / 2; // max content width 960
    if (w >= 600) return 32.0;
    return 20.0;
  }

  /// Max content width for centered layouts
  static double maxWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return 960.0;
    if (w >= 600) return w - 64.0;
    return w;
  }

  /// Card grid column count
  static int gridCols(BuildContext context) {
    final type = of(context);
    if (type == DeviceType.desktop) return 3;
    if (type == DeviceType.tablet) return 2;
    return 1;
  }

  /// Font scale factor
  static double fontScale(BuildContext context) {
    final type = of(context);
    if (type == DeviceType.desktop) return 1.1;
    if (type == DeviceType.tablet) return 1.05;
    return 1.0;
  }
}

/// Wraps content in a centered, max-width container for tablet/desktop
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
