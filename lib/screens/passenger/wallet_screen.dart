/// Passenger wallet overview screen for PasaWallet
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';

class PassengerWalletScreen extends StatefulWidget {
  const PassengerWalletScreen({super.key});

  @override
  State<PassengerWalletScreen> createState() => _PassengerWalletScreenState();
}

class _PassengerWalletScreenState extends State<PassengerWalletScreen> {
  Wallet? _wallet;
  List<WalletTransaction> _recentTransactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    setState(() => _loading = true);

    try {
      // Initialize mock data for demo
      await WalletService.instance.initializeMockData();

      // Get wallet for current user (mock user ID)
      final wallet = await WalletService.instance.getWalletByUserId(
        'passenger_001',
      );

      if (wallet != null) {
        _wallet = wallet;
        _recentTransactions = await WalletService.instance
            .getTransactionHistory(wallet.walletId, limit: 5);
      }
    } catch (e) {
      // Handle error
      print('Error loading wallet: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _refreshData() async {
    await _loadWalletData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _WalletHeader()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _BalanceCard(),
                const SizedBox(height: 24),
                _QuickActions(),
                const SizedBox(height: 24),
                _RecentTransactions(),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _WalletHeader() {
    return PhAppBar(
      title: 'PasaWallet',
      subtitle: 'Your secure ride wallet',
      showBack: true,
      actions: [
        PhIconButton(
          icon: Icons.history_outlined,
          onTap: () => context.go('/wallet-history'),
          color: Colors.white.withValues(alpha: 0.15),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  Widget _BalanceCard() {
    if (_loading) {
      return PhCard(
        child: SizedBox(
          height: 160,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    final balance = _wallet?.balance ?? 0.0;

    return PhCard(
      child: Column(
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 8),
          Text(
            '₱${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '≈ \$${(balance / 56).toStringAsFixed(2)} USD',
            style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PhButton(
                  label: 'Cash In',
                  icon: Icons.add_circle_outline,
                  onTap: () => context.go('/wallet-cash-in'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PhButton(
                  label: 'History',
                  icon: Icons.history_outlined,
                  outlined: true,
                  onTap: () => context.go('/wallet-history'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _QuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PhSectionHeader(title: 'Quick Actions', dark: false),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.payment_outlined,
                label: 'Pay Ride',
                color: AppColors.primary,
                onTap: () {
                  // This would be integrated with ride booking flow
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select PasaWallet during ride booking'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.qr_code_outlined,
                label: 'Scan QR',
                color: AppColors.success,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('QR code scanning coming soon'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.share_outlined,
                label: 'Send Money',
                color: AppColors.amber,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Send money feature coming soon'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _QuickActionButton({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
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
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _RecentTransactions() {
    if (_loading) {
      return const SizedBox.shrink();
    }

    if (_recentTransactions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PhSectionHeader(
            title: 'Recent Transactions',
            action: 'View All',
            onAction: null,
            dark: false,
          ),
          const SizedBox(height: 12),
          PhCard(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.textTertiary,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No transactions yet',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Start by adding money to your wallet',
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PhSectionHeader(
          title: 'Recent Transactions',
          action: 'View All',
          onAction: () => context.go('/wallet-history'),
          dark: false,
        ),
        const SizedBox(height: 12),
        PhCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: _recentTransactions
                .take(3)
                .map((transaction) => _TransactionItem(transaction))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _TransactionItem(WalletTransaction transaction) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPositive
                  ? AppColors.successSurface
                  : AppColors.errorSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
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
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.displaySubtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(transaction.timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
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

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.cashIn:
        return Icons.add_circle_outline;
      case TransactionType.payment:
        return Icons.directions_car_outlined;
      case TransactionType.earnings:
        return Icons.attach_money_outlined;
      case TransactionType.withdrawal:
        return Icons.account_balance_wallet_outlined;
      case TransactionType.refund:
        return Icons.refresh_outlined;
      case TransactionType.commission:
        return Icons.percent_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
