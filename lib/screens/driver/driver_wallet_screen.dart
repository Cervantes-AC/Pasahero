/// Driver wallet dashboard screen for PasaWallet
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/wallet.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';

class DriverWalletScreen extends StatefulWidget {
  const DriverWalletScreen({super.key});

  @override
  State<DriverWalletScreen> createState() => _DriverWalletScreenState();
}

class _DriverWalletScreenState extends State<DriverWalletScreen> {
  Wallet? _wallet;
  double _todayEarnings = 0;
  double _totalEarnings = 0;
  int _todayTrips = 0;
  List<WalletTransaction> _recentTransactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Mock wallet data
      _wallet = Wallet(
        walletId: 'wallet_driver_001',
        userId: 'driver_001',
        balance: 912.50,
        userType: UserType.driver,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      );

      _todayEarnings = 912.50;
      _totalEarnings = 5432.75;
      _todayTrips = 13;

      // Mock recent transactions
      _recentTransactions = [
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
      ];

      if (mounted) {
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint('Error loading wallet data: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.driverBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 2),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: Responsive.spacing(context, units: 2.5)),
                _buildBalanceCard(),
                SizedBox(height: Responsive.spacing(context, units: 2)),
                _buildStatsRow(),
                SizedBox(height: Responsive.spacing(context, units: 3)),
                _buildActionButtons(),
                SizedBox(height: Responsive.spacing(context, units: 3)),
                _buildRecentTransactions(),
                SizedBox(height: Responsive.spacing(context, units: 5)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return PhAppBar(
      title: 'PasaWallet',
      subtitle: 'Driver earnings & payouts',
      showBack: true,
      onBack: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          context.go('/driver-home');
        }
      },
      dark: true,
      actions: [
        PhIconButton(
          icon: Icons.history_outlined,
          onTap: () => context.go('/driver-wallet-history'),
          color: Colors.white.withValues(alpha: 0.15),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    if (_loading) {
      return Container(
        height: Responsive.buttonHeight(context) * 2,
        decoration: BoxDecoration(
          color: AppColors.driverSurface,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 16),
          ),
          border: Border.all(color: AppColors.driverBorder),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.driverAccent),
        ),
      );
    }

    final balance = _wallet?.balance ?? 0.0;

    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, units: 2.5)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 20),
        ),
        border: Border.all(
          color: AppColors.driverAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.spacing(context, units: 1.25),
                  vertical: Responsive.spacing(context, units: 0.5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.driverAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, base: 8),
                  ),
                  border: Border.all(
                    color: AppColors.driverAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.driverAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: Responsive.spacing(context, units: 0.75)),
                    Text(
                      'PASAWALLET',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 10),
                        fontWeight: FontWeight.w700,
                        color: AppColors.driverAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.spacing(context, units: 2)),
          Text(
            'Available Balance',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 13),
              color: AppColors.driverTextMuted,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 0.75)),
          Text(
            '₱${balance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 44),
              fontWeight: FontWeight.w700,
              color: AppColors.driverText,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 0.5)),
          Text(
            'Today\'s earnings: ₱${_todayEarnings.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 13),
              color: AppColors.driverAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: PhStatBox(
            value: '₱${_todayEarnings.toStringAsFixed(0)}',
            label: "Today's Earnings",
            valueColor: AppColors.driverAccent,
            dark: true,
          ),
        ),
        SizedBox(width: Responsive.spacing(context, units: 1.25)),
        Expanded(
          child: PhStatBox(
            value: '$_todayTrips',
            label: 'Trips Today',
            valueColor: AppColors.primaryLight,
            dark: true,
          ),
        ),
        SizedBox(width: Responsive.spacing(context, units: 1.25)),
        Expanded(
          child: PhStatBox(
            value: '₱${_totalEarnings.toStringAsFixed(0)}',
            label: 'Total Earned',
            valueColor: AppColors.success,
            dark: true,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 15),
            fontWeight: FontWeight.w700,
            color: AppColors.driverText,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        Row(
          children: [
            Expanded(
              child: _actionBtn(
                icon: Icons.account_balance_outlined,
                label: 'Withdraw',
                color: AppColors.driverAccent,
                onTap: () => context.go('/driver-wallet-withdraw'),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.5)),
            Expanded(
              child: _actionBtn(
                icon: Icons.history_outlined,
                label: 'History',
                color: AppColors.primaryLight,
                onTap: () => context.go('/driver-wallet-history'),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.5)),
            Expanded(
              child: _actionBtn(
                icon: Icons.bar_chart_outlined,
                label: 'Summary',
                color: AppColors.success,
                onTap: () => _showEarningsSummary(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Responsive.spacing(context, units: 2),
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 12),
          ),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: Responsive.iconSize(context, base: 24),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            Text(
              label,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 12),
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    if (_loading) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhSectionHeader(
          title: 'Recent Transactions',
          action: 'View All',
          onAction: () => context.go('/driver-wallet-history'),
          dark: true,
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        if (_recentTransactions.isEmpty)
          PhDriverCard(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.driverTextMuted,
                  size: Responsive.iconSize(context, base: 40),
                ),
                SizedBox(height: Responsive.spacing(context, units: 1.5)),
                Text(
                  'No transactions yet',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 14),
                    color: AppColors.driverTextMuted,
                  ),
                ),
              ],
            ),
          )
        else
          PhDriverCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: _recentTransactions
                  .take(4)
                  .map((t) => _driverTransactionTile(transaction: t))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _driverTransactionTile({required WalletTransaction transaction}) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.spacing(context, units: 2),
        vertical: Responsive.spacing(context, units: 1.75),
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.driverBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.iconSize(context, base: 40),
            height: Responsive.iconSize(context, base: 40),
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
                Text(
                  _formatTime(transaction.timestamp),
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 11),
                    color: AppColors.driverTextMuted,
                  ),
                ),
              ],
            ),
          ),
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

  void _showEarningsSummary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _earningsSummarySheet(
        todayEarnings: _todayEarnings,
        totalEarnings: _totalEarnings,
        todayTrips: _todayTrips,
        commissionRate: 0.17, // 17% commission
      ),
    );
  }

  Widget _earningsSummarySheet({
    required double todayEarnings,
    required double totalEarnings,
    required int todayTrips,
    required double commissionRate,
  }) {
    final grossToday = todayEarnings / (1 - commissionRate);
    final commissionToday = grossToday - todayEarnings;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Responsive.radius(context, base: 24)),
        ),
      ),
      padding: EdgeInsets.all(Responsive.spacing(context, units: 3)),
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
          SizedBox(height: Responsive.spacing(context, units: 2.5)),
          Text(
            "Today's Earnings Summary",
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 17),
              fontWeight: FontWeight.w700,
              color: AppColors.driverText,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 2.5)),
          _summaryRow(
            'Gross Earnings',
            '₱${grossToday.toStringAsFixed(2)}',
            AppColors.driverText,
          ),
          _summaryRow(
            'Platform Commission (${(commissionRate * 100).toStringAsFixed(0)}%)',
            '-₱${commissionToday.toStringAsFixed(2)}',
            AppColors.error,
          ),
          Divider(
            color: AppColors.driverBorder,
            height: Responsive.spacing(context, units: 3),
          ),
          _summaryRow(
            'Net Earnings',
            '₱${todayEarnings.toStringAsFixed(2)}',
            AppColors.driverAccent,
            bold: true,
          ),
          _summaryRow('Trips Completed', '$todayTrips', AppColors.driverText),
          SizedBox(height: Responsive.spacing(context, units: 2.5)),
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

  Widget _summaryRow(
    String label,
    String value,
    Color color, {
    bool bold = false,
  }) {
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
              color: bold ? AppColors.driverText : AppColors.driverTextMuted,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, bold ? 16 : 14),
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
