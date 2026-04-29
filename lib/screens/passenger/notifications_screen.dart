/// Passenger notifications screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  @override
  void initState() {
    super.initState();
    // Mark all as read when screen opens
    AppState.instance.markAllNotificationsRead();
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

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final notifications = AppState.instance.notifications;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          PhAppBar(
            title: 'Notifications',
            subtitle: '${notifications.length} total',
            showBack: true,
            actions: [
              if (notifications.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(
                      () => AppState.instance.markAllNotificationsRead(),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.spacing(context, units: 1.5),
                      vertical: Responsive.spacing(context, units: 0.75),
                    ),
                    margin: EdgeInsets.only(
                      right: Responsive.spacing(context, units: 0.5),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(
                        Responsive.radius(context, base: 8),
                      ),
                    ),
                    child: Text(
                      'Mark all read',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.fontSize(context, 12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: notifications.isEmpty
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
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.spacing(context, units: 2),
                      vertical: Responsive.spacing(context, units: 1.5),
                    ),
                    itemCount: notifications.length,
                    itemBuilder: (context, i) {
                      final n = notifications[i];
                      final color = _colorFor(n.type);
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: Responsive.spacing(context, units: 1.25),
                        ),
                        decoration: BoxDecoration(
                          color: n.isRead
                              ? Colors.white
                              : AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(context, base: 14),
                          ),
                          border: Border.all(
                            color: n.isRead
                                ? AppColors.border
                                : AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(
                              context,
                              units: 1.75,
                            ),
                            vertical: Responsive.spacing(context, units: 1),
                          ),
                          leading: Container(
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
                          title: Text(
                            n.title,
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 14),
                              fontWeight: n.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Responsive.spacing(
                                  context,
                                  units: 0.375,
                                ),
                              ),
                              Text(
                                n.body,
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(context, 12),
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(
                                height: Responsive.spacing(context, units: 0.5),
                              ),
                              Text(
                                _timeAgo(n.timestamp),
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(context, 11),
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          trailing: !n.isRead
                              ? Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                          onTap: () {
                            setState(
                              () =>
                                  AppState.instance.markNotificationRead(n.id),
                            );
                          },
                        ),
                      ).animate().fadeIn(delay: (i * 40).ms, duration: 300.ms);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
