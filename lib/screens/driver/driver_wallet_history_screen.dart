/// Driver wallet transaction history screen
library;

import 'package:flutter/material.dart';
import '../../models/wallet.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';

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

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Mock transaction data
    _allTransactions = [
      WalletTransaction(
        transactionId: 'TXN-DRV-001',
        walletId: 'wallet_driver_001',
        type: TransactionType.earnings,
        amount: 65.00,
        status: TransactionStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        rideId: 'RIDE-DRV-001',
        commissionRate: 0.17,
        commissionAmount: 13.00,
        description: 'Ride Earnings',
      ),
      WalletTransaction(
        transactionId: 'TXN-DRV-002',
        walletId: 'wallet_driver_001',
        type: TransactionType.earnings,
        amount: 120.00,
        status: TransactionStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        rideId: 'RIDE-DRV-002',
        commissionRate: 0.17,
        commissionAmount: 24.00,
        description: 'Ride Earnings',
      ),
      WalletTransaction(
        transactionId: 'TXN-DRV-003',
        walletId: 'wallet_driver_001',
        type: TransactionType.earnings,
        amount: 95.50,
        status: TransactionStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        rideId: 'RIDE-DRV-003',
        commissionRate: 0.17,
        commissionAmount: 19.50,
        description: 'Ride Earnings',
      ),
      WalletTransaction(
        transactionId: 'TXN-DRV-004',
        walletId: 'wallet_driver_001',
        type: TransactionType.earnings,
        amount: 630.00,
        status: TransactionStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        rideId: 'RIDE-DRV-004',
        commissionRate: 0.17,
        commissionAmount: 130.00,
        description: 'Ride Earnings',
      ),
      WalletTransaction(
        transactionId: 'TXN-DRV-005',
        walletId: 'wallet_driver_001',
        type: TransactionType.withdrawal,
        amount: 500.00,
        status: TransactionStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        method: 'gcash',
        description: 'Withdrawal to GCash',
      ),
      WalletTransaction(
        transactionId: 'TXN-DRV-006',
        walletId: 'wallet_driver_001',
        type: TransactionType.commission,
        amount: 186.50,
        status: TransactionStatus.completed,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Platform Commission',
      ),
    ];

    setState(() => _loading = false);
  }

  List<WalletTransaction> _filtered(TransactionType? type) {
    if (type == null) return _allTransactions;
    return _allTransactions.where((t) => t.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const Scaffold(
        backgroundColor: AppColors.driverBg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                : _tabController.index >= 0
                ? TabBarView(
                    controller: _tabController,
                    children: [
                      _driverTransactionList(transactions: _filtered(null)),
                      _driverTransactionList(
                        transactions: _filtered(TransactionType.earnings),
                      ),
                      _driverTransactionList(
                        transactions: _filtered(TransactionType.withdrawal),
                      ),
                      _driverTransactionList(
                        transactions: _filtered(TransactionType.commission),
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
          Tab(text: 'Earnings'),
          Tab(text: 'Withdrawals'),
          Tab(text: 'Commission'),
        ],
      ),
    );
  }

  Widget _driverTransactionList({
    required List<WalletTransaction> transactions,
  }) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: Responsive.iconSize(context, base: 56),
              color: AppColors.driverTextMuted,
            ),
            SizedBox(height: Responsive.spacing(context, units: 2)),
            Text(
              'No transactions found',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 15),
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
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, units: 2),
        vertical: Responsive.spacing(context, units: 1.5),
      ),
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
              padding: EdgeInsets.symmetric(
                vertical: Responsive.spacing(context, units: 1.25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateKey,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 12),
                      fontWeight: FontWeight.w700,
                      color: AppColors.driverTextMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (dayTotal > 0)
                    Text(
                      '+₱${dayTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 12),
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
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 14),
                ),
                border: Border.all(color: AppColors.driverBorder),
              ),
              child: Column(
                children: items
                    .asMap()
                    .entries
                    .map(
                      (e) => _driverTxTile(
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

  Widget _driverTxTile({
    required WalletTransaction transaction,
    required bool isLast,
  }) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

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
                  bottom: BorderSide(color: AppColors.driverBorder, width: 1),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: Responsive.iconSize(context, base: 42),
              height: Responsive.iconSize(context, base: 42),
              decoration: BoxDecoration(
                color: isPositive
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 10),
                ),
              ),
              child: Icon(
                _iconFor(transaction.type),
                color: isPositive ? AppColors.success : AppColors.error,
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
                      color: AppColors.driverText,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 0.25)),
                  Row(
                    children: [
                      Text(
                        _formatTime(transaction.timestamp),
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 11),
                          color: AppColors.driverTextMuted,
                        ),
                      ),
                      if (transaction.status == TransactionStatus.pending) ...[
                        SizedBox(width: Responsive.spacing(context, units: 1)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(
                              context,
                              units: 0.75,
                            ),
                            vertical: Responsive.spacing(context, units: 0.25),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, base: 6),
                            ),
                          ),
                          child: Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 10),
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
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 11),
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
                    fontSize: Responsive.fontSize(context, 15),
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
                if (transaction.rideId != null)
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.driverTextMuted,
                    size: Responsive.iconSize(context, base: 16),
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
      builder: (ctx) => _driverTxDetailSheet(transaction: transaction),
    );
  }

  Widget _driverTxDetailSheet({required WalletTransaction transaction}) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.driverSurface,
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
              color: AppColors.driverBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 3)),
          Text(
            transaction.displayTitle,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 18),
              fontWeight: FontWeight.w700,
              color: AppColors.driverText,
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
          _row(
            'Transaction ID',
            '${transaction.transactionId.substring(0, 16)}...',
          ),
          _row('Date & Time', _formatDateTime(transaction.timestamp)),
          _row(
            'Status',
            transaction.status.name.toUpperCase(),
            valueColor: transaction.status == TransactionStatus.completed
                ? AppColors.success
                : AppColors.amber,
          ),
          if (transaction.rideId != null) _row('Ride ID', transaction.rideId!),
          if (transaction.method != null) _row('Method', transaction.method!),
          if (transaction.commissionAmount != null) ...[
            _row(
              'Gross Fare',
              '₱${(transaction.amount + transaction.commissionAmount!).toStringAsFixed(2)}',
            ),
            _row(
              'Commission (${((transaction.commissionRate ?? 0) * 100).toStringAsFixed(0)}%)',
              '-₱${transaction.commissionAmount!.toStringAsFixed(2)}',
              valueColor: AppColors.error,
            ),
          ],
          SizedBox(height: Responsive.spacing(context, units: 3)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.driverAccent,
                foregroundColor: AppColors.driverBg,
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
                  fontWeight: FontWeight.w700,
                  fontSize: Responsive.fontSize(context, 16),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1)),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
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
              color: AppColors.driverTextMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 13),
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.driverText,
            ),
          ),
        ],
      ),
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
