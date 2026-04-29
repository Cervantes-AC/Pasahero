import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _weatherController;
  int _selectedQuickAction = -1;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _weatherController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _addMockDriverMessages();
  }

  void _addMockDriverMessages() {
    // Add mock driver message notifications
    final driverMessages = [
      (
        name: 'Pedro Santos',
        message: 'Hi! I\'m on my way. I\'ll be there in 5 minutes.',
        delay: 2,
      ),
      (
        name: 'Maria Garcia',
        message: 'Just picked up another passenger. Will be with you soon!',
        delay: 8,
      ),
      (
        name: 'Juan Reyes',
        message: 'I\'m here! Look for the red motorcycle with plate ABC 1234.',
        delay: 15,
      ),
    ];

    for (final msg in driverMessages) {
      Future.delayed(Duration(seconds: msg.delay), () {
        if (mounted) {
          AppState.instance.notifications.insert(
            0,
            AppNotification(
              id: 'msg_${DateTime.now().millisecondsSinceEpoch}_${msg.name}',
              title: 'Message from ${msg.name}',
              body: msg.message,
              type: 'ride',
              timestamp: DateTime.now(),
            ),
          );
          setState(() {});
        }
      });
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
              showToast(context, 'Logged out successfully');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _weatherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HomeHeader(onLogout: _logout)),
          SliverToBoxAdapter(
            child: ResponsiveContainer(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: Offset(
                        0,
                        -Responsive.spacing(context, units: 2.5),
                      ),
                      child: _SearchBar()
                          .animate()
                          .fadeIn(duration: 350.ms)
                          .slideY(begin: 0.2, end: 0),
                    ),
                    Transform.translate(
                      offset: Offset(
                        0,
                        -Responsive.spacing(context, units: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Responsive.spacing(context, units: 1),
                          ),

                          // Quick Actions Row
                          _QuickActionsRow(
                            selectedIndex: _selectedQuickAction,
                            onActionTap: (index) =>
                                setState(() => _selectedQuickAction = index),
                          ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

                          SizedBox(
                            height: Responsive.spacing(context, units: 2.5),
                          ),

                          // Weather & Traffic Card
                          _WeatherTrafficCard(
                            weatherController: _weatherController,
                          ).animate().fadeIn(delay: 150.ms, duration: 350.ms),

                          SizedBox(
                            height: Responsive.spacing(context, units: 2.5),
                          ),

                          Text(
                            'Choose your ride',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 17),
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(
                            height: Responsive.spacing(context, units: 1.5),
                          ),
                          // On tablet/desktop show 2-col grid
                          Responsive.isWide(context)
                              ? _RideGrid()
                              : _RideList(),
                          SizedBox(
                            height: Responsive.spacing(context, units: 3),
                          ),

                          // Recent Activity
                          _RecentActivityCard().animate().fadeIn(
                            delay: 200.ms,
                            duration: 350.ms,
                          ),

                          SizedBox(
                            height: Responsive.spacing(context, units: 2.5),
                          ),

                          _PromoBanner().animate().fadeIn(
                            delay: 240.ms,
                            duration: 350.ms,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  final VoidCallback onLogout;

  const _HomeHeader({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final hp = Responsive.hPad(context);
    final hour = DateTime.now().hour;
    String greeting = 'Good morning';
    if (hour >= 12 && hour < 17) greeting = 'Good afternoon';
    if (hour >= 17) greeting = 'Good evening';

    final unreadCount = AppState.instance.unreadNotificationCount;

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
          padding: EdgeInsets.fromLTRB(
            hp,
            Responsive.spacing(context, units: 2),
            hp,
            Responsive.spacing(context, units: 2),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: Responsive.iconSize(context, base: 44),
                        height: Responsive.iconSize(context, base: 44),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'JD',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: Responsive.fontSize(context, 14),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: Responsive.iconSize(context, base: 14),
                          height: Responsive.iconSize(context, base: 14),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: Responsive.spacing(context, units: 1.5)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting,',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 12),
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          'Juan Dela Cruz',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 16),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/notifications'),
                    child: Stack(
                      children: [
                        Container(
                          width: Responsive.iconSize(context, base: 40),
                          height: Responsive.iconSize(context, base: 40),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: Responsive.iconSize(context, base: 20),
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: Responsive.spacing(context, units: 0.5),
                            right: Responsive.spacing(context, units: 0.5),
                            child:
                                Container(
                                      width: Responsive.iconSize(
                                        context,
                                        base: 10,
                                      ),
                                      height: Responsive.iconSize(
                                        context,
                                        base: 10,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                    .animate(onPlay: (c) => c.repeat())
                                    .scale(
                                      begin: const Offset(1, 1),
                                      end: const Offset(1.3, 1.3),
                                      duration: 1000.ms,
                                    )
                                    .then()
                                    .scale(
                                      begin: const Offset(1.3, 1.3),
                                      end: const Offset(1, 1),
                                      duration: 1000.ms,
                                    ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: Responsive.spacing(context, units: 1)),
                  GestureDetector(
                    onTap: onLogout,
                    child: Container(
                      width: Responsive.iconSize(context, base: 40),
                      height: Responsive.iconSize(context, base: 40),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                        size: Responsive.iconSize(context, base: 20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.spacing(context, units: 1.5)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, units: 1.75),
                  vertical: Responsive.spacing(context, units: 1.25),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, base: 12),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: Responsive.iconSize(context, base: 8),
                      height: Responsive.iconSize(context, base: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 1)),
                    Expanded(
                      child: Text(
                        'Cebu City, Philippines',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.fontSize(context, 13),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.my_location_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: Responsive.iconSize(context, base: 16),
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
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, units: 2),
          vertical: Responsive.spacing(context, units: 1.75),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 14),
          ),
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
              width: Responsive.iconSize(context, base: 36),
              height: Responsive.iconSize(context, base: 36),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 10),
                ),
              ),
              child: Icon(
                Icons.search,
                color: AppColors.primary,
                size: Responsive.iconSize(context, base: 18),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.5)),
            Expanded(
              child: Text(
                'Where do you want to go?',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: Responsive.fontSize(context, 14),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, units: 1.5),
                vertical: Responsive.spacing(context, units: 0.75),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 8),
                ),
              ),
              child: Text(
                'Go',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: Responsive.fontSize(context, 13),
                ),
              ),
            ),
          ],
        ),
      ),
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
        padding: EdgeInsets.all(Responsive.spacing(context, units: 1.75)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 14),
          ),
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
              width: Responsive.iconSize(context, base: 52),
              height: Responsive.iconSize(context, base: 52),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 13),
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: Responsive.iconSize(context, base: 26),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.75)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 15),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: Responsive.spacing(context, units: 1)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.spacing(context, units: 0.875),
                          vertical: Responsive.spacing(context, units: 0.25),
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 10),
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 0.25)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 12),
                      color: AppColors.textTertiary,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 0.375)),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 12),
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: Responsive.iconSize(context, base: 20),
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
      padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1347C0)],
        ),
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(context, units: 1),
                    vertical: Responsive.spacing(context, units: 0.375),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 6),
                    ),
                  ),
                  child: Text(
                    'LIMITED OFFER',
                    style: TextStyle(
                      color: AppColors.amber,
                      fontSize: Responsive.fontSize(context, 10),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, units: 1)),
                Text(
                  '₱10 off your\nnext 3 rides!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.fontSize(context, 16),
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, units: 1.25)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(context, units: 1.5),
                    vertical: Responsive.spacing(context, units: 0.75),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amber,
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 8),
                    ),
                  ),
                  child: Text(
                    'Claim Now',
                    style: TextStyle(
                      color: AppColors.driverBg,
                      fontSize: Responsive.fontSize(context, 12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.local_offer_outlined,
            color: Colors.white24,
            size: Responsive.iconSize(context, base: 64),
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions Row ─────────────────────────────────────────────────────────

class _QuickActionsRow extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onActionTap;

  const _QuickActionsRow({
    required this.selectedIndex,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        icon: Icons.schedule_outlined,
        label: 'Schedule',
        color: AppColors.primary,
      ),
      (
        icon: Icons.favorite_outline,
        label: 'Favorites',
        color: AppColors.error,
      ),
      (
        icon: Icons.group_outlined,
        label: 'Share Ride',
        color: AppColors.success,
      ),
      (
        icon: Icons.local_offer_outlined,
        label: 'Promos',
        color: AppColors.amber,
      ),
    ];

    return Row(
      children: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;
        final isSelected = selectedIndex == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onActionTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: index < actions.length - 1
                    ? Responsive.spacing(context, units: 1)
                    : 0,
              ),
              padding: EdgeInsets.symmetric(
                vertical: Responsive.spacing(context, units: 1.5),
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? action.color.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 12),
                ),
                border: Border.all(
                  color: isSelected
                      ? action.color.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: action.color.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    action.icon,
                    color: isSelected ? action.color : AppColors.textTertiary,
                    size: Responsive.iconSize(context, base: 20),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 0.5)),
                  Text(
                    action.label,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 10),
                      fontWeight: FontWeight.w500,
                      color: isSelected ? action.color : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Weather & Traffic Card ────────────────────────────────────────────────────

class _WeatherTrafficCard extends StatelessWidget {
  final AnimationController weatherController;

  const _WeatherTrafficCard({required this.weatherController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 16),
        ),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: weatherController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: weatherController.value * 2 * 3.14159,
                          child: Icon(
                            Icons.wb_sunny_outlined,
                            color: AppColors.amber,
                            size: Responsive.iconSize(context, base: 18),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 0.75)),
                    Text(
                      '28°C',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 16),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 1)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.spacing(context, units: 0.75),
                        vertical: Responsive.spacing(context, units: 0.25),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(context, base: 8),
                        ),
                      ),
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 10),
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.spacing(context, units: 1)),
                Text(
                  'Perfect weather for riding!',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: Responsive.iconSize(context, base: 40),
            color: AppColors.border,
          ),
          SizedBox(width: Responsive.spacing(context, units: 2)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.traffic_outlined,
                      color: AppColors.success,
                      size: Responsive.iconSize(context, base: 18),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 0.75)),
                    Text(
                      'Light',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 16),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.spacing(context, units: 1)),
                Text(
                  'Smooth roads ahead',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recent Activity Card ──────────────────────────────────────────────────────

class _RecentActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 16),
        ),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 15),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/ride-history'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, units: 1.5)),
          _ActivityItem(
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
            title: 'Trip to SM City Cebu',
            subtitle: 'Yesterday, 2:30 PM • ₱45',
            trailing: '4.9 ⭐',
          ),
          SizedBox(height: Responsive.spacing(context, units: 1)),
          _ActivityItem(
            icon: Icons.schedule_outlined,
            iconColor: AppColors.amber,
            title: 'Scheduled ride to Airport',
            subtitle: 'Tomorrow, 6:00 AM • ₱120',
            trailing: 'Pending',
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String trailing;

  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Responsive.iconSize(context, base: 36),
          height: Responsive.iconSize(context, base: 36),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 10),
            ),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: Responsive.iconSize(context, base: 18),
          ),
        ),
        SizedBox(width: Responsive.spacing(context, units: 1.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 11),
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Text(
          trailing,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 11),
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
