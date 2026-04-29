import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ph_widgets.dart';
import '../../utils/responsive.dart';

class DriverRatingsScreen extends StatefulWidget {
  const DriverRatingsScreen({super.key});

  @override
  State<DriverRatingsScreen> createState() => _DriverRatingsScreenState();
}

class _DriverRatingsScreenState extends State<DriverRatingsScreen> {
  String _filterRating = 'all'; // 'all', '5', '4', '3', '2', '1'

  // Mock ratings data
  final List<_Rating> _allRatings = [
    _Rating(
      passengerName: 'Maria Santos',
      passengerInitials: 'MS',
      rating: 5,
      comment: 'Very professional and courteous driver. Arrived on time!',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      pickup: 'SM City Cebu',
      dropoff: 'Ayala Center',
    ),
    _Rating(
      passengerName: 'Juan Reyes',
      passengerInitials: 'JR',
      rating: 5,
      comment: 'Excellent service. Clean vehicle and safe driving.',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      pickup: 'IT Park',
      dropoff: 'Guadalupe',
    ),
    _Rating(
      passengerName: 'Ana Cruz',
      passengerInitials: 'AC',
      rating: 4,
      comment: 'Good driver, took a slightly longer route but still okay.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      pickup: 'Banilad',
      dropoff: 'North Bus Terminal',
    ),
    _Rating(
      passengerName: 'Carlos Mendoza',
      passengerInitials: 'CM',
      rating: 5,
      comment: 'Best ride experience. Friendly and helpful.',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      pickup: 'Cebu Business Park',
      dropoff: 'Mabolo',
    ),
    _Rating(
      passengerName: 'Rosa Fernandez',
      passengerInitials: 'RF',
      rating: 4,
      comment: 'Nice ride. Driver was a bit quiet but professional.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      pickup: 'Lahug',
      dropoff: 'Talamban',
    ),
    _Rating(
      passengerName: 'Miguel Torres',
      passengerInitials: 'MT',
      rating: 5,
      comment: 'Perfect! Exactly on time and very safe.',
      date: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      pickup: 'Fuente Osmeña',
      dropoff: 'Colon Street',
    ),
    _Rating(
      passengerName: 'Lisa Wong',
      passengerInitials: 'LW',
      rating: 3,
      comment: 'Okay ride. Could have been smoother.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      pickup: 'Mandaue City',
      dropoff: 'Cebu City',
    ),
  ];

  List<_Rating> get _filteredRatings {
    if (_filterRating == 'all') return _allRatings;
    final rating = int.parse(_filterRating);
    return _allRatings.where((r) => r.rating == rating).toList();
  }

  double get _averageRating {
    if (_allRatings.isEmpty) return 0;
    final sum = _allRatings.fold<double>(0, (acc, r) => acc + r.rating);
    return sum / _allRatings.length;
  }

  Map<int, int> get _ratingDistribution {
    final dist = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final rating in _allRatings) {
      dist[rating.rating] = (dist[rating.rating] ?? 0) + 1;
    }
    return dist;
  }

  @override
  Widget build(BuildContext context) {
    final avgRating = _averageRating;
    final distribution = _ratingDistribution;
    final filtered = _filteredRatings;

    return Scaffold(
      backgroundColor: AppColors.driverBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            PhAppBar(
              title: 'Driver Ratings',
              subtitle: '${_allRatings.length} total ratings',
              showBack: true,
              onBack: () => context.go('/driver-home'),
              dark: true,
            ),

            // Overall Rating Card
            Padding(
              padding: EdgeInsets.all(Responsive.spacing(context, units: 2.5)),
              child: Container(
                padding: EdgeInsets.all(Responsive.spacing(context, units: 3)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.driverAccent.withValues(alpha: 0.25),
                      AppColors.driverAccent.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, base: 20),
                  ),
                  border: Border.all(
                    color: AppColors.driverAccent.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.driverAccent.withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Overall Rating',
                      style: TextStyle(
                        color: AppColors.driverTextMuted,
                        fontSize: Responsive.fontSize(context, 12),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: Responsive.spacing(context, units: 1)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          avgRating.toStringAsFixed(1),
                          style: TextStyle(
                            color: AppColors.driverAccent,
                            fontSize: Responsive.fontSize(context, 56),
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: Responsive.spacing(context, units: 1),
                          ),
                          child: Text(
                            '/5.0',
                            style: TextStyle(
                              color: AppColors.driverAccent,
                              fontSize: Responsive.fontSize(context, 18),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.spacing(context, units: 1.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(
                              context,
                              units: 0.25,
                            ),
                          ),
                          child: Icon(
                            Icons.star_rounded,
                            color: i < avgRating.round()
                                ? AppColors.driverAccent
                                : AppColors.driverBorder,
                            size: Responsive.iconSize(context, base: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

            // Rating Distribution
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, units: 2.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating Distribution',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.fontSize(context, 14),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 1.5)),
                  ...List.generate(5, (i) {
                    final stars = 5 - i;
                    final count = distribution[stars] ?? 0;
                    final percentage = _allRatings.isEmpty
                        ? 0.0
                        : (count / _allRatings.length) * 100;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: Responsive.spacing(context, units: 1.25),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Responsive.spacing(context, units: 4),
                            child: Row(
                              children: [
                                Text(
                                  '$stars',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Responsive.fontSize(context, 12),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  color: AppColors.driverAccent,
                                  size: Responsive.iconSize(context, base: 14),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: Responsive.spacing(context, units: 1.5),
                              decoration: BoxDecoration(
                                color: AppColors.driverBorder,
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(context, base: 8),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width:
                                        (percentage / 100) *
                                        (MediaQuery.of(context).size.width -
                                            Responsive.spacing(
                                              context,
                                              units: 12,
                                            ) -
                                            Responsive.spacing(
                                              context,
                                              units: 4,
                                            )),
                                    decoration: BoxDecoration(
                                      color: AppColors.driverAccent,
                                      borderRadius: BorderRadius.circular(
                                        Responsive.radius(context, base: 8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 1),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 3),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                color: AppColors.driverTextMuted,
                                fontSize: Responsive.fontSize(context, 12),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

            SizedBox(height: Responsive.spacing(context, units: 2)),

            // Filter Chips
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, units: 2.5),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: _filterRating == 'all',
                      onTap: () => setState(() => _filterRating = 'all'),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 1)),
                    ...[5, 4, 3, 2, 1].map((r) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: Responsive.spacing(context, units: 1),
                        ),
                        child: _FilterChip(
                          label: '$r★',
                          selected: _filterRating == '$r',
                          onTap: () => setState(() => _filterRating = '$r'),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            SizedBox(height: Responsive.spacing(context, units: 2)),

            // Ratings List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No ratings found',
                        style: TextStyle(
                          color: AppColors.driverTextMuted,
                          fontSize: Responsive.fontSize(context, 14),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.spacing(context, units: 2.5),
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final rating = filtered[index];
                        return _RatingCard(rating: rating, index: index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Rating Card ──────────────────────────────────────────────────────────────

class _RatingCard extends StatelessWidget {
  final _Rating rating;
  final int index;

  const _RatingCard({required this.rating, required this.index});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.spacing(context, units: 1.5)),
      padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
      decoration: BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 16),
        ),
        border: Border.all(color: AppColors.driverBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with passenger info and rating
          Row(
            children: [
              Container(
                width: Responsive.iconSize(context, base: 44),
                height: Responsive.iconSize(context, base: 44),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF1E3A8A)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    rating.passengerInitials,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: Responsive.fontSize(context, 14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Responsive.spacing(context, units: 1.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.passengerName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.fontSize(context, 14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDate(rating.date),
                      style: TextStyle(
                        color: AppColors.driverTextMuted,
                        fontSize: Responsive.fontSize(context, 11),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    color: i < rating.rating
                        ? AppColors.driverAccent
                        : AppColors.driverBorder,
                    size: Responsive.iconSize(context, base: 16),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: Responsive.spacing(context, units: 1.5)),

          // Comment
          if (rating.comment.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                bottom: Responsive.spacing(context, units: 1.5),
              ),
              child: Text(
                rating.comment,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: Responsive.fontSize(context, 13),
                  height: 1.5,
                ),
              ),
            ),

          // Trip details
          Container(
            padding: EdgeInsets.all(Responsive.spacing(context, units: 1.25)),
            decoration: BoxDecoration(
              color: AppColors.driverBg,
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 12),
              ),
              border: Border.all(color: AppColors.driverBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.driverTextMuted,
                  size: Responsive.iconSize(context, base: 14),
                ),
                SizedBox(width: Responsive.spacing(context, units: 0.75)),
                Expanded(
                  child: Text(
                    '${rating.pickup} → ${rating.dropoff}',
                    style: TextStyle(
                      color: AppColors.driverTextMuted,
                      fontSize: Responsive.fontSize(context, 12),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms, duration: 300.ms);
  }
}

// ── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, units: 1.5),
          vertical: Responsive.spacing(context, units: 0.75),
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.driverAccent
              : AppColors.driverBorder.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 20),
          ),
          border: Border.all(
            color: selected ? AppColors.driverAccent : AppColors.driverBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.driverBg : Colors.white,
            fontSize: Responsive.fontSize(context, 12),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Data Model ───────────────────────────────────────────────────────────────

class _Rating {
  final String passengerName;
  final String passengerInitials;
  final int rating;
  final String comment;
  final DateTime date;
  final String pickup;
  final String dropoff;

  _Rating({
    required this.passengerName,
    required this.passengerInitials,
    required this.rating,
    required this.comment,
    required this.date,
    required this.pickup,
    required this.dropoff,
  });
}
