import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../data/app_state.dart';
import '../utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HomeHeader()),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              Responsive.hPad(context),
              0,
              Responsive.hPad(context),
              32,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: _SearchBar()
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.2, end: 0),
                ),
                Transform.translate(
                  offset: const Offset(0, -12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PaymentRow().animate().fadeIn(
                        delay: 80.ms,
                        duration: 350.ms,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Choose your ride',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // On tablet/desktop show 2-col grid
                      Responsive.isWide(context) ? _RideGrid() : _RideList(),
                      const SizedBox(height: 24),
                      _PromoBanner().animate().fadeIn(
                        delay: 240.ms,
                        duration: 350.ms,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hp = Responsive.hPad(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hp, 16, hp, 52),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'JD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning,',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const Text(
                          'Juan Dela Cruz',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        top: 9,
                        right: 9,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Cebu City, Philippines',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.my_location_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.search,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Where do you want to go?',
                style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Go',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Payment row ───────────────────────────────────────────────────────────────

class _PaymentRow extends StatefulWidget {
  @override
  State<_PaymentRow> createState() => _PaymentRowState();
}

class _PaymentRowState extends State<_PaymentRow> {
  final _methods = ['GCash', 'Maya', 'Cash'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.payment_outlined,
          color: AppColors.textTertiary,
          size: 16,
        ),
        const SizedBox(width: 8),
        const Text(
          'Pay with',
          style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _methods.map((m) {
                final selected = AppState.instance.selectedPayment == m;
                return GestureDetector(
                  onTap: () =>
                      setState(() => AppState.instance.selectedPayment = m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Text(
                      m,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Ride cards ────────────────────────────────────────────────────────────────

const _rideTypes = [
  (
    icon: Icons.two_wheeler,
    iconColor: AppColors.primary,
    iconBg: AppColors.primarySurface,
    title: 'Habal-habal',
    subtitle: 'Single motorcycle ride',
    price: 'From ₱25',
    badge: 'Fastest',
    badgeColor: AppColors.success,
    route: '/search?type=habal-habal',
  ),
  (
    icon: Icons.two_wheeler,
    iconColor: AppColors.error,
    iconBg: AppColors.errorSurface,
    title: 'Motorela',
    subtitle: 'Motorcycle with sidecar',
    price: 'From ₱35',
    badge: 'Shared',
    badgeColor: AppColors.warning,
    route: '/search?type=motorela',
  ),
  (
    icon: Icons.directions_car_outlined,
    iconColor: AppColors.amber,
    iconBg: AppColors.warningSurface,
    title: 'Bao-bao',
    subtitle: 'Tricycle for groups',
    price: 'From ₱50',
    badge: 'Groups',
    badgeColor: AppColors.primary,
    route: '/search?type=bao-bao',
  ),
];

class _RideList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _rideTypes.asMap().entries.map((e) {
        final t = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child:
              _RideCard(
                    icon: t.icon,
                    iconColor: t.iconColor,
                    iconBg: t.iconBg,
                    title: t.title,
                    subtitle: t.subtitle,
                    price: t.price,
                    badge: t.badge,
                    badgeColor: t.badgeColor,
                    onTap: () => context.go(t.route),
                  )
                  .animate()
                  .fadeIn(delay: (120 + e.key * 50).ms, duration: 350.ms)
                  .slideY(begin: 0.15, end: 0),
        );
      }).toList(),
    );
  }
}

class _RideGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _rideTypes.map((t) {
        return SizedBox(
          width:
              (Responsive.maxWidth(context) -
                  Responsive.hPad(context) * 2 -
                  12) /
              2,
          child: _RideCard(
            icon: t.icon,
            iconColor: t.iconColor,
            iconBg: t.iconBg,
            title: t.title,
            subtitle: t.subtitle,
            price: t.price,
            badge: t.badge,
            badgeColor: t.badgeColor,
            onTap: () => context.go(t.route),
          ),
        );
      }).toList(),
    );
  }
}

class _RideCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg, badgeColor;
  final String title, subtitle, price, badge;
  final VoidCallback onTap;

  const _RideCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Promo banner ──────────────────────────────────────────────────────────────

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1347C0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'LIMITED OFFER',
                    style: TextStyle(
                      color: AppColors.amber,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '₱10 off your\nnext 3 rides!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Claim Now',
                    style: TextStyle(
                      color: AppColors.driverBg,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.local_offer_outlined,
            color: Colors.white24,
            size: 64,
          ),
        ],
      ),
    );
  }
}
