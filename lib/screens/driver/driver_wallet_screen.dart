/// Driver wallet dashboard screen for PasaWallet
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';

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
    setState(() => _loading = true);
    try {
      await WalletService.instance.initializeMockData();
      final wallet = await WalletService.instance.getWalletByUserId(
        'driver_001',
      );
      if (wallet != null) {
        _wallet = wallet;
        _todayEarnings = await WalletService.instance.getTodayEarnings(
          wallet.walletId,
        );
        _totalEarnings = await WalletService.instance.getTotalEarnings(
          wallet.walletId,
        );
        _todayTrips = await WalletService.instance.getTodayTripCount(
          wallet.walletId,
        );
        _recentTransactions = await WalletService.instance
            .getTransactionHistory(wallet.walletId, limit: 5);
      }
    } catch (e) {
      debugPrint('Error loading driver wallet: $e');
    } finally {
      setState(() => _loading = false);
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _buildBalanceCard(),
                const SizedBox(height: 16),
                _buildStatsRow(),
                const SizedBox(height: 24),
                _buildActionButtons(),
                const SizedBox(height: 24),
                _buildRecentTransactions(),
                const SizedBox(height: 40),
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
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.driverSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.driverBorder),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.driverAccent),
        ),
      );
    }

    final balance = _wallet?.balance ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.driverAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
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
                    const SizedBox(width: 6),
                    const Text(
                      'PASAWALLET',
                      style: TextStyle(
                        fontSize: 10,
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
          const SizedBox(height: 16),
          const Text(
            'Available Balance',
            style: TextStyle(fontSize: 13, color: AppColors.driverTextMuted),
          ),
          const SizedBox(height: 6),
          Text(
            '₱${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              color: AppColors.driverText,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Today\'s earnings: ₱${_todayEarnings.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 13,
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
        const SizedBox(width: 10),
        Expanded(
          child: PhStatBox(
            value: '$_todayTrips',
            label: 'Trips Today',
            valueColor: AppColors.primaryLight,
            dark: true,
          ),
        ),
        const SizedBox(width: 10),
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
        const Text(
          'Actions',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.driverText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.account_balance_outlined,
                label: 'Withdraw',
                color: AppColors.driverAccent,
                onTap: () => context.go('/driver-wallet-withdraw'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.history_outlined,
                label: 'History',
                color: AppColors.primaryLight,
                onTap: () => context.go('/driver-wallet-history'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
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

  Widget _ActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
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
        const SizedBox(height: 12),
        if (_recentTransactions.isEmpty)
          PhDriverCard(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.driverTextMuted,
                  size: 40,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No transactions yet',
                  style: TextStyle(
                    fontSize: 14,
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
                  .map((t) => _DriverTransactionTile(transaction: t))
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _showEarningsSummary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EarningsSummarySheet(
        todayEarnings: _todayEarnings,
        totalEarnings: _totalEarnings,
        todayTrips: _todayTrips,
        commissionRate: WalletService.commissionRate,
      ),
    );
  }
}

class _DriverTransactionTile extends StatelessWidget {
  final WalletTransaction transaction;
  const _DriverTransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.driverBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
                Text(
                  _formatTime(transaction.timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.driverTextMuted,
                  ),
                ),
              ],
            ),
          ),
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

class _EarningsSummarySheet extends StatelessWidget {
  final double todayEarnings;
  final double totalEarnings;
  final int todayTrips;
  final double commissionRate;

  const _EarningsSummarySheet({
    required this.todayEarnings,
    required this.totalEarnings,
    required this.todayTrips,
    required this.commissionRate,
  });

  @override
  Widget build(BuildContext context) {
    final grossToday = todayEarnings / (1 - commissionRate);
    final commissionToday = grossToday - todayEarnings;

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
          const SizedBox(height: 20),
          const Text(
            "Today's Earnings Summary",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.driverText,
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'Gross Earnings',
            value: '₱${grossToday.toStringAsFixed(2)}',
            color: AppColors.driverText,
          ),
          _SummaryRow(
            label:
                'Platform Commission (${(commissionRate * 100).toStringAsFixed(0)}%)',
            value: '-₱${commissionToday.toStringAsFixed(2)}',
            color: AppColors.error,
          ),
          const Divider(color: AppColors.driverBorder, height: 24),
          _SummaryRow(
            label: 'Net Earnings',
            value: '₱${todayEarnings.toStringAsFixed(2)}',
            color: AppColors.driverAccent,
            bold: true,
          ),
          _SummaryRow(
            label: 'Trips Completed',
            value: '$todayTrips',
            color: AppColors.driverText,
          ),
          const SizedBox(height: 20),
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
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: bold ? AppColors.driverText : AppColors.driverTextMuted,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
