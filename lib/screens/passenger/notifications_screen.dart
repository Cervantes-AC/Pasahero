/// Passenger notifications screen - Enhanced with filtering, search, and better UX
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ph_widgets.dart';
import '../../utils/responsive.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'all'; // all, ride, promo, wallet
  String _searchQuery = '';
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Mark all as read when screen opens
    AppState.instance.markAllNotificationsRead();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'promo':
        return Icons.local_offer_outlined;
      case 'ride':
        return Icons.directions_car_outlined;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'promo':
        return AppColors.amber;
      case 'ride':
        return AppColors.primary;
      case 'wallet':
        return AppColors.success;
      default:
        return AppColors.textTertiary;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'promo':
        return 'Promo';
      case 'ride':
        return 'Ride';
      case 'wallet':
        return 'Wallet';
      default:
        return 'Other';
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  List<dynamic> _getFilteredNotifications() {
    var notifications = AppState.instance.notifications;

    // Filter by type
    if (_selectedFilter != 'all') {
      notifications = notifications
          .where((n) => n.type == _selectedFilter)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      notifications = notifications
          .where(
            (n) =>
                n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                n.body.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    final allNotifications = AppState.instance.notifications;
    final filteredNotifications = _getFilteredNotifications();
    final unreadCount = allNotifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Enhanced App Bar with back button fix
          Container(
            color: AppColors.surface,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, units: 2),
                  vertical: Responsive.spacing(context, units: 1.5),
                ),
                child: Row(
                  children: [
                    // Back button with explicit navigation
                    GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      },
                      child: Container(
                        width: Responsive.iconSize(context, base: 44),
                        height: Responsive.iconSize(context, base: 44),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary,
                          size: Responsive.iconSize(context, base: 18),
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 1.5)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 18),
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (unreadCount > 0)
                            Text(
                              '$unreadCount unread',
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 12),
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Mark all read button
                    if (allNotifications.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(
                            () => AppState.instance.markAllNotificationsRead(),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(context, units: 1),
                            vertical: Responsive.spacing(context, units: 0.5),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 8),
                            ),
                          ),
                          child: Text(
                            'Mark all',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: Responsive.fontSize(context, 11),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Search bar
          if (allNotifications.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, units: 2),
                vertical: Responsive.spacing(context, units: 1),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: 'Search notifications...',
                  hintStyle: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: Responsive.fontSize(context, 13),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.textTertiary,
                    size: Responsive.iconSize(context, base: 20),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.textTertiary,
                            size: Responsive.iconSize(context, base: 20),
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 12),
                    ),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 12),
                    ),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 12),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(context, units: 1.5),
                    vertical: Responsive.spacing(context, units: 1),
                  ),
                ),
              ),
            ),

          // Filter chips
          if (allNotifications.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, units: 2),
                vertical: Responsive.spacing(context, units: 1),
              ),
              child: Row(
                children: [
                  _buildFilterChip('all', 'All'),
                  SizedBox(width: Responsive.spacing(context, units: 1)),
                  _buildFilterChip('ride', '🚗 Rides'),
                  SizedBox(width: Responsive.spacing(context, units: 1)),
                  _buildFilterChip('promo', '🎁 Promos'),
                  SizedBox(width: Responsive.spacing(context, units: 1)),
                  _buildFilterChip('wallet', '💰 Wallet'),
                ],
              ),
            ),

          // Notifications list
          Expanded(
            child: allNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_outlined,
                          size: Responsive.iconSize(context, base: 64),
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: Responsive.spacing(context, units: 2)),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 16),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.spacing(context, units: 0.75),
                        ),
                        Text(
                          'We\'ll notify you about rides, promos, and more',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 13),
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: Responsive.iconSize(context, base: 48),
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(
                          height: Responsive.spacing(context, units: 1.5),
                        ),
                        Text(
                          'No notifications found',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.spacing(context, units: 2),
                      vertical: Responsive.spacing(context, units: 1.5),
                    ),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, i) {
                      final n = filteredNotifications[i];
                      final color = _colorFor(n.type);
                      return _buildNotificationCard(n, color, i);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedFilter = value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, units: 1.5),
          vertical: Responsive.spacing(context, units: 0.75),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 20),
          ),
          border: isSelected
              ? null
              : Border.all(color: AppColors.border, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 12),
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(dynamic n, Color color, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.spacing(context, units: 1.25)),
      decoration: BoxDecoration(
        color: n.isRead ? Colors.white : AppColors.primarySurface,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 14),
        ),
        border: Border.all(
          color: n.isRead
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => AppState.instance.markNotificationRead(n.id));
          },
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 14),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 1.75),
              vertical: Responsive.spacing(context, units: 1.25),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: Responsive.iconSize(context, base: 44),
                  height: Responsive.iconSize(context, base: 44),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, base: 10),
                    ),
                  ),
                  child: Icon(
                    _iconFor(n.type),
                    color: color,
                    size: Responsive.iconSize(context, base: 22),
                  ),
                ),
                SizedBox(width: Responsive.spacing(context, units: 1.25)),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                                fontWeight: n.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: Responsive.spacing(context, units: 0.5),
                          ),
                          PhBadge(
                            label: _typeLabel(n.type),
                            color: color,
                            filled: false,
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.spacing(context, units: 0.5)),
                      Text(
                        n.body,
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 12),
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: Responsive.spacing(context, units: 0.75),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _timeAgo(n.timestamp),
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 11),
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!n.isRead)
                            Container(
                              width: Responsive.spacing(context, units: 1),
                              height: Responsive.spacing(context, units: 1),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 40).ms, duration: 300.ms);
  }
}
