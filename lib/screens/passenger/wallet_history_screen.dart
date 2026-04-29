/// Passenger wallet transaction history screen
library;

import 'package:flutter/material.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';

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
  String? _walletId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    setState(() => _loading = true);
    try {
      final wallet = await WalletService.instance.getWalletByUserId(
        'passenger_001',
      );
      if (wallet != null) {
        _walletId = wallet.walletId;
        _allTransactions = await WalletService.instance.getTransactionHistory(
          wallet.walletId,
          limit: 100,
        );
      }
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  List<WalletTransaction> _filtered(TransactionType? type) {
    if (type == null) return _allTransactions;
    return _allTransactions.where((t) => t.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _TransactionList(transactions: _filtered(null)),
                      _TransactionList(
                        transactions: _filtered(TransactionType.payment),
                      ),
                      _TransactionList(
                        transactions: _filtered(TransactionType.cashIn),
                      ),
                      _TransactionList(
                        transactions: _filtered(TransactionType.refund),
                      ),
                    ],
                  ),
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
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
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
}

class _TransactionList extends StatelessWidget {
  final List<WalletTransaction> transactions;

  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            const Text(
              'No transactions found',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your transactions will appear here',
              style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
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
      onRefresh: () async {},
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final dateKey = grouped.keys.elementAt(index);
          final items = grouped[dateKey]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  dateKey,
                  style: const TextStyle(
                    fontSize: 12,
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
                        (e) => _TransactionTile(
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

  String _dateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(txDate).inDays;

    if (diff == 0) return 'TODAY';
    if (diff == 1) return 'YESTERDAY';
    if (diff < 7) return '${diff} DAYS AGO';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;
  final bool isLast;

  const _TransactionTile({required this.transaction, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;
    final iconBg = isPositive
        ? AppColors.successSurface
        : AppColors.errorSurface;
    final iconColor = isPositive ? AppColors.success : AppColors.error;

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconFor(transaction.type),
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.displayTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (transaction.displaySubtitle.isNotEmpty)
                    Text(
                      transaction.displaySubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        _formatTime(transaction.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(status: transaction.status),
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
                    fontSize: 15,
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

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TransactionDetailSheet(transaction: transaction),
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
}

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _TransactionDetailSheet extends StatelessWidget {
  final WalletTransaction transaction;
  const _TransactionDetailSheet({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isPositive
                  ? AppColors.successSurface
                  : AppColors.errorSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPositive ? Icons.arrow_downward : Icons.arrow_upward,
              color: amountColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            transaction.displayTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${isPositive ? '+' : '-'}₱${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: amountColor,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          _DetailRow(
            label: 'Transaction ID',
            value: transaction.transactionId.substring(0, 16) + '...',
          ),
          _DetailRow(
            label: 'Date & Time',
            value: _formatDateTime(transaction.timestamp),
          ),
          _DetailRow(
            label: 'Status',
            value: transaction.status.name.toUpperCase(),
            valueColor: transaction.status == TransactionStatus.completed
                ? AppColors.success
                : AppColors.amber,
          ),
          if (transaction.method != null)
            _DetailRow(label: 'Method', value: transaction.method!),
          if (transaction.rideId != null)
            _DetailRow(label: 'Ride ID', value: transaction.rideId!),
          if (transaction.commissionAmount != null)
            _DetailRow(
              label:
                  'Commission (${((transaction.commissionRate ?? 0) * 100).toStringAsFixed(0)}%)',
              value: '-₱${transaction.commissionAmount!.toStringAsFixed(2)}',
              valueColor: AppColors.error,
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
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
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
