/// Passenger wallet transaction history screen
library;

import 'package:flutter/material.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<WalletTransaction> _allTransactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTransactions();
  }

  @override
  void dispose() {
    try {
      _tabController.dispose();
    } catch (e) {
      debugPrint('Error disposing TabController: $e');
    }
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final wallet = await WalletService.instance.getWalletByUserId(
        'passenger_001',
      );
      if (wallet != null) {
        _allTransactions = await WalletService.instance.getTransactionHistory(
          wallet.walletId,
          limit: 100,
        );
      }
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<WalletTransaction> _filtered(TransactionType? type) {
    if (type == null) return _allTransactions;
    return _allTransactions.where((t) => t.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _tabController.index >= 0
                ? TabBarView(
                    controller: _tabController,
                    children: [
                      _transactionList(transactions: _filtered(null)),
                      _transactionList(
                        transactions: _filtered(TransactionType.payment),
                      ),
                      _transactionList(
                        transactions: _filtered(TransactionType.cashIn),
                      ),
                      _transactionList(
                        transactions: _filtered(TransactionType.refund),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return PhAppBar(
      title: 'Transaction History',
      subtitle: 'All your PasaWallet activity',
      showBack: true,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2,
        labelStyle: TextStyle(
          fontSize: Responsive.fontSize(context, 12),
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: Responsive.fontSize(context, 12),
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Rides'),
          Tab(text: 'Cash In'),
          Tab(text: 'Refunds'),
        ],
      ),
    );
  }

  Widget _transactionList({required List<WalletTransaction> transactions}) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: Responsive.iconSize(context, base: 56),
              color: AppColors.textTertiary,
            ),
            SizedBox(height: Responsive.spacing(context, units: 2)),
            Text(
              'No transactions found',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 15),
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: Responsive.spacing(context, units: 0.75)),
            Text(
              'Your transactions will appear here',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 13),
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    // Group by date
    final grouped = <String, List<WalletTransaction>>{};
    for (final t in transactions) {
      final key = _dateKey(t.timestamp);
      grouped.putIfAbsent(key, () => []).add(t);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadTransactions,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, units: 2),
          vertical: Responsive.spacing(context, units: 1.5),
        ),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final dateKey = grouped.keys.elementAt(index);
          final items = grouped[dateKey]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Responsive.spacing(context, units: 1.25),
                ),
                child: Text(
                  dateKey,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 12),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              PhCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: items
                      .asMap()
                      .entries
                      .map(
                        (e) => _transactionTile(
                          transaction: e.value,
                          isLast: e.key == items.length - 1,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _transactionTile({
    required WalletTransaction transaction,
    required bool isLast,
  }) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;
    final iconBg = isPositive
        ? AppColors.successSurface
        : AppColors.errorSurface;
    final iconColor = isPositive ? AppColors.success : AppColors.error;

    return GestureDetector(
      onTap: () => _showDetail(context, transaction),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, units: 2),
          vertical: Responsive.spacing(context, units: 1.75),
        ),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: Responsive.iconSize(context, base: 42),
              height: Responsive.iconSize(context, base: 42),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 10),
                ),
              ),
              child: Icon(
                _iconFor(transaction.type),
                color: iconColor,
                size: Responsive.iconSize(context, base: 20),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.displayTitle,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 0.25)),
                  if (transaction.displaySubtitle.isNotEmpty)
                    Text(
                      transaction.displaySubtitle,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 12),
                        color: AppColors.textTertiary,
                      ),
                    ),
                  SizedBox(height: Responsive.spacing(context, units: 0.25)),
                  Row(
                    children: [
                      Text(
                        _formatTime(transaction.timestamp),
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 11),
                          color: AppColors.textTertiary,
                        ),
                      ),
                      SizedBox(width: Responsive.spacing(context, units: 1)),
                      _statusBadge(status: transaction.status),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isPositive ? '+' : '-'}₱${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 15),
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, WalletTransaction transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _transactionDetailSheet(transaction: transaction),
    );
  }

  Widget _statusBadge({required TransactionStatus status}) {
    Color color;
    String label;
    switch (status) {
      case TransactionStatus.completed:
        color = AppColors.success;
        label = 'Completed';
        break;
      case TransactionStatus.pending:
        color = AppColors.amber;
        label = 'Pending';
        break;
      case TransactionStatus.failed:
        color = AppColors.error;
        label = 'Failed';
        break;
      case TransactionStatus.cancelled:
        color = AppColors.textTertiary;
        label = 'Cancelled';
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, units: 0.75),
        vertical: Responsive.spacing(context, units: 0.25),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 6),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: Responsive.fontSize(context, 10),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _transactionDetailSheet({required WalletTransaction transaction}) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(Responsive.spacing(context, units: 3)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Responsive.spacing(context, units: 5),
            height: Responsive.spacing(context, units: 0.5),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 3)),
          Container(
            width: Responsive.iconSize(context, base: 64),
            height: Responsive.iconSize(context, base: 64),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppColors.successSurface
                  : AppColors.errorSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPositive ? Icons.arrow_downward : Icons.arrow_upward,
              color: amountColor,
              size: Responsive.iconSize(context, base: 28),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 2)),
          Text(
            transaction.displayTitle,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 18),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1)),
          Text(
            '${isPositive ? '+' : '-'}₱${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 36),
              fontWeight: FontWeight.w700,
              color: amountColor,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 3)),
          _detailRow(
            'Transaction ID',
            '${transaction.transactionId.substring(0, 16)}...',
          ),
          _detailRow('Date & Time', _formatDateTime(transaction.timestamp)),
          _detailRow(
            'Status',
            transaction.status.name.toUpperCase(),
            valueColor: transaction.status == TransactionStatus.completed
                ? AppColors.success
                : AppColors.amber,
          ),
          if (transaction.method != null)
            _detailRow('Method', transaction.method!),
          if (transaction.rideId != null)
            _detailRow('Ride ID', transaction.rideId!),
          if (transaction.commissionAmount != null)
            _detailRow(
              'Commission (${((transaction.commissionRate ?? 0) * 100).toStringAsFixed(0)}%)',
              '-₱${transaction.commissionAmount!.toStringAsFixed(2)}',
              valueColor: AppColors.error,
            ),
          SizedBox(height: Responsive.spacing(context, units: 3)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: Responsive.spacing(context, units: 1.75),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, base: 12),
                  ),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Responsive.fontSize(context, 15),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1)),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.spacing(context, units: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 13),
              color: AppColors.textTertiary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 13),
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(TransactionType type) {
    switch (type) {
      case TransactionType.cashIn:
        return Icons.add_circle_outline;
      case TransactionType.payment:
        return Icons.directions_car_outlined;
      case TransactionType.earnings:
        return Icons.attach_money;
      case TransactionType.withdrawal:
        return Icons.account_balance_wallet_outlined;
      case TransactionType.refund:
        return Icons.replay_outlined;
      case TransactionType.commission:
        return Icons.percent;
    }
  }

  String _formatTime(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year} at $h:$m';
  }

  String _dateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(txDate).inDays;

    if (diff == 0) return 'TODAY';
    if (diff == 1) return 'YESTERDAY';
    if (diff < 7) return '$diff DAYS AGO';
    return '${date.day}/${date.month}/${date.year}';
  }
}
