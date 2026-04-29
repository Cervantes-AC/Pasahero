/// Driver wallet transaction history screen
library;

import 'package:flutter/material.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';

class DriverWalletHistoryScreen extends StatefulWidget {
  const DriverWalletHistoryScreen({super.key});

  @override
  State<DriverWalletHistoryScreen> createState() =>
      _DriverWalletHistoryScreenState();
}

class _DriverWalletHistoryScreenState extends State<DriverWalletHistoryScreen>
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
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    setState(() => _loading = true);
    try {
      final wallet = await WalletService.instance.getWalletByUserId(
        'driver_001',
      );
      if (wallet != null) {
        _allTransactions = await WalletService.instance.getTransactionHistory(
          wallet.walletId,
          limit: 100,
        );
      }
    } catch (e) {
      debugPrint('Error loading driver transactions: $e');
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
      backgroundColor: AppColors.driverBg,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.driverAccent,
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _DriverTransactionList(transactions: _filtered(null)),
                      _DriverTransactionList(
                        transactions: _filtered(TransactionType.earnings),
                      ),
                      _DriverTransactionList(
                        transactions: _filtered(TransactionType.withdrawal),
                      ),
                      _DriverTransactionList(
                        transactions: _filtered(TransactionType.commission),
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
      title: 'Earnings History',
      subtitle: 'All your PasaWallet transactions',
      showBack: true,
      dark: true,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.driverSurface,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.driverAccent,
        unselectedLabelColor: AppColors.driverTextMuted,
        indicatorColor: AppColors.driverAccent,
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Earnings'),
          Tab(text: 'Withdrawals'),
          Tab(text: 'Commission'),
        ],
      ),
    );
  }
}

class _DriverTransactionList extends StatelessWidget {
  final List<WalletTransaction> transactions;

  const _DriverTransactionList({required this.transactions});

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
              color: AppColors.driverTextMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'No transactions found',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.driverTextMuted,
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final dateKey = grouped.keys.elementAt(index);
        final items = grouped[dateKey]!;

        // Calculate day total for earnings
        final dayTotal = items
            .where((t) => t.type == TransactionType.earnings)
            .fold(0.0, (sum, t) => sum + t.amount);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateKey,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.driverTextMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (dayTotal > 0)
                    Text(
                      '+₱${dayTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.driverSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.driverBorder),
              ),
              child: Column(
                children: items
                    .asMap()
                    .entries
                    .map(
                      (e) => _DriverTxTile(
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
    );
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

class _DriverTxTile extends StatelessWidget {
  final WalletTransaction transaction;
  final bool isLast;

  const _DriverTxTile({required this.transaction, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: AppColors.driverBorder, width: 1),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isPositive
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconFor(transaction.type),
                color: isPositive ? AppColors.success : AppColors.error,
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
                      color: AppColors.driverText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        _formatTime(transaction.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.driverTextMuted,
                        ),
                      ),
                      if (transaction.status == TransactionStatus.pending) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (transaction.commissionAmount != null)
                    Text(
                      'Commission: -₱${transaction.commissionAmount!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.driverTextMuted,
                      ),
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
                if (transaction.rideId != null)
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.driverTextMuted,
                    size: 16,
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
      builder: (ctx) => _DriverTxDetailSheet(transaction: transaction),
    );
  }

  IconData _iconFor(TransactionType type) {
    switch (type) {
      case TransactionType.earnings:
        return Icons.attach_money;
      case TransactionType.withdrawal:
        return Icons.account_balance_wallet_outlined;
      case TransactionType.commission:
        return Icons.percent;
      default:
        return Icons.swap_horiz;
    }
  }

  String _formatTime(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _DriverTxDetailSheet extends StatelessWidget {
  final WalletTransaction transaction;
  const _DriverTxDetailSheet({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.driverSurface,
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
              color: AppColors.driverBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            transaction.displayTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.driverText,
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
          _Row(
            'Transaction ID',
            transaction.transactionId.substring(0, 16) + '...',
          ),
          _Row('Date & Time', _formatDateTime(transaction.timestamp)),
          _Row(
            'Status',
            transaction.status.name.toUpperCase(),
            valueColor: transaction.status == TransactionStatus.completed
                ? AppColors.success
                : AppColors.amber,
          ),
          if (transaction.rideId != null) _Row('Ride ID', transaction.rideId!),
          if (transaction.method != null) _Row('Method', transaction.method!),
          if (transaction.commissionAmount != null) ...[
            _Row(
              'Gross Fare',
              '₱${(transaction.amount + transaction.commissionAmount!).toStringAsFixed(2)}',
            ),
            _Row(
              'Commission (${((transaction.commissionRate ?? 0) * 100).toStringAsFixed(0)}%)',
              '-₱${transaction.commissionAmount!.toStringAsFixed(2)}',
              valueColor: AppColors.error,
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.driverAccent,
                foregroundColor: AppColors.driverBg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _Row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.driverTextMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.driverText,
            ),
          ),
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
