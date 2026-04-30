/// Shared production-ready widget library for Pasahero.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

// ── PH App Bar ────────────────────────────────────────────────────────────────

class PhAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool dark; // dark = driver mode

  const PhAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.dark = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (showBack)
                PhIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap:
                      onBack ??
                      () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      },
                  color: theme.cardColor,
                  iconColor: textColor,
                  bordered: true,
                  size: 48,
                ),
              if (showBack) const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}

// ── PH Icon Button ────────────────────────────────────────────────────────────

class PhIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;
  final double size;
  final bool bordered;

  const PhIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.iconColor,
    this.size = 48,
    this.bordered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? theme.cardColor,
          shape: BoxShape.circle,
          border: bordered
              ? Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                  width: 1.5,
                )
              : null,
          boxShadow: bordered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: iconColor ?? theme.colorScheme.onSurface,
          size: size * 0.45,
        ),
      ),
    );
  }
}

// ── PH Card ───────────────────────────────────────────────────────────────────

class PhCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final bool bordered;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  const PhCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.bordered = true,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 28),
        border: bordered
            ? Border.all(
                color: theme.dividerColor.withValues(alpha: 0.1),
                width: 1.5,
              )
            : null,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }
    return card;
  }
}

// ── PH Driver Card ────────────────────────────────────────────────────────────

class PhDriverCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool highlighted;

  const PhDriverCard({
    super.key,
    required this.child,
    this.padding,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PhCard(
      padding: padding,
      color: highlighted
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : theme.cardColor,
      bordered: true,
      borderRadius: 20,
      child: child,
    );
  }
}

// ── PH Button ─────────────────────────────────────────────────────────────────

class PhButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final bool outlined;
  final bool loading;
  final double height;
  final double? width;

  const PhButton({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.outlined = false,
    this.loading = false,
    this.height = 58,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primary;
    final fg = foregroundColor ?? theme.colorScheme.onPrimary;

    final content = loading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(fg),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: fg),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: outlined
          ? OutlinedButton(
              onPressed: loading ? null : onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: bg,
                side: BorderSide(color: bg, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: content,
            )
          : ElevatedButton(
              onPressed: loading ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: bg,
                foregroundColor: fg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: content,
            ),
    );
  }
}

// ── PH Text Field ─────────────────────────────────────────────────────────────

// ── PH Logo ───────────────────────────────────────────────────────────────────

class PhLogo extends StatelessWidget {
  final double size;
  final bool isDriver;

  const PhLogo({super.key, this.size = 80, this.isDriver = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        color: isDriver
            ? AppColors.driverAccent.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(
          color: isDriver
              ? AppColors.driverAccent.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Image.asset('assets/logo.png', fit: BoxFit.contain),
    );
  }
}

// ── PH Badge ──────────────────────────────────────────────────────────────────

class PhBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final bool filled;

  const PhBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? Colors.white : (textColor ?? color),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── PH Avatar ─────────────────────────────────────────────────────────────────

class PhAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? bgColor;
  final Color? textColor;
  final bool dark;

  const PhAvatar({
    super.key,
    required this.initials,
    this.size = 48,
    this.bgColor,
    this.textColor,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor ?? (dark ? AppColors.primary : AppColors.primarySurface),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: textColor ?? (dark ? Colors.white : AppColors.primary),
            fontWeight: FontWeight.w700,
            fontSize: size * 0.33,
          ),
        ),
      ),
    );
  }
}

// ── PH Stat Box ───────────────────────────────────────────────────────────────

class PhStatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  final bool dark;

  const PhStatBox({
    super.key,
    required this.value,
    required this.label,
    this.valueColor,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: dark ? AppColors.driverSurface : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? AppColors.driverBorder : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color:
                  valueColor ??
                  (dark ? AppColors.driverAccent : AppColors.primary),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: dark ? AppColors.driverTextMuted : AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── PH Route Display ──────────────────────────────────────────────────────────

class PhRouteDisplay extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final bool dark;

  const PhRouteDisplay({
    super.key,
    required this.pickup,
    required this.dropoff,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? AppColors.driverText : AppColors.textPrimary;
    final mutedColor = dark
        ? AppColors.driverTextMuted
        : AppColors.textTertiary;
    final bgColor = dark ? AppColors.driverSurface : AppColors.surfaceVariant;
    final borderColor = dark ? AppColors.driverBorder : AppColors.border;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup',
                      style: TextStyle(fontSize: 10, color: mutedColor),
                    ),
                    Text(
                      pickup,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drop-off',
                      style: TextStyle(fontSize: 10, color: mutedColor),
                    ),
                    Text(
                      dropoff,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── PH Section Header ─────────────────────────────────────────────────────────

class PhSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final bool dark;

  const PhSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: dark ? AppColors.driverText : AppColors.textPrimary,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

// ── PH Text Field ─────────────────────────────────────────────────────────────

class PhTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;
  final IconData? prefixIcon;
  final bool dark;

  const PhTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
    this.prefixIcon,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: dark ? AppColors.driverTextMuted : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: TextStyle(
            color: dark ? AppColors.driverText : AppColors.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: dark ? AppColors.driverTextMuted : AppColors.textTertiary,
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: dark
                        ? AppColors.driverTextMuted
                        : AppColors.textTertiary,
                    size: 18,
                  )
                : null,
            suffixIcon: suffix,
            filled: true,
            fillColor: dark
                ? AppColors.driverSurface
                : AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: dark ? AppColors.driverBorder : AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: dark ? AppColors.driverBorder : AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: dark ? AppColors.driverAccent : AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// ── PH Map Background ─────────────────────────────────────────────────────────

class PhMapBackground extends StatelessWidget {
  final List<Widget> children;

  const PhMapBackground({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xFFE8F0F8)),
          child: CustomPaint(painter: _MapPainter(), size: Size.infinite),
        ),
        ...children,
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeCap = StrokeCap.round;

    // Major roads
    roadPaint.style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.28, size.width, 10),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.62, size.width, 14),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.38, 0, 10, size.height),
      roadPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.72, 0, 12, size.height),
      roadPaint,
    );

    // Minor roads
    final minorPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, size.height * 0.12),
      Offset(size.width, size.height * 0.12),
      minorPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.45),
      Offset(size.width, size.height * 0.45),
      minorPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.80),
      Offset(size.width, size.height * 0.80),
      minorPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, 0),
      Offset(size.width * 0.18, size.height),
      minorPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.55, 0),
      Offset(size.width * 0.55, size.height),
      minorPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.88, 0),
      Offset(size.width * 0.88, size.height),
      minorPaint,
    );

    // Blocks (green areas)
    final blockPaint = Paint()
      ..color = const Color(0xFFD1E8D0).withValues(alpha: 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.20,
          size.height * 0.14,
          size.width * 0.16,
          size.height * 0.12,
        ),
        const Radius.circular(4),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.58,
          size.height * 0.48,
          size.width * 0.12,
          size.height * 0.12,
        ),
        const Radius.circular(4),
      ),
      blockPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── PH Divider ────────────────────────────────────────────────────────────────

class PhDivider extends StatelessWidget {
  final bool dark;
  const PhDivider({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: dark ? AppColors.driverBorder : AppColors.border,
      height: 1,
      thickness: 1,
    );
  }
}
