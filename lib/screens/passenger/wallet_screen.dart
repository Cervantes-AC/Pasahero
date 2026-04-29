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
      await WalletService.instance.initializeMockData();
      final wallet = await WalletService.instance.getWalletByUserId(
        'passenger_001',
      );
      if (wallet != null) {
        _wallet = wallet;
        _recentTransactions = await WalletService.instance
            .getTransactionHistory(wallet.walletId, limit: 5);
      }
    } catch (e) {
      debugPrint('Error loading wallet: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PhAppBar(
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
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _buildBalanceCard(),
                const SizedBox(height: 24),
                _buildQuickActions(),
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

  Widget _buildBalanceCard() {
    if (_loading) {
      return const PhCard(
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

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PhSectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Icons.payment_outlined,
                label: 'Pay Ride',
                color: AppColors.primary,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Select PasaWallet during ride booking'),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.qr_code_outlined,
                label: 'Scan QR',
                color: AppColors.success,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR scanning coming soon')),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.share_outlined,
                label: 'Send Money',
                color: AppColors.amber,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Send money coming soon')),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    if (_loading) return const SizedBox.shrink();

    if (_recentTransactions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PhSectionHeader(title: 'Recent Transactions'),
          const SizedBox(height: 12),
          const PhCard(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.textTertiary,
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  'No transactions yet',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
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
        PhSectionHeader(
          title: 'Recent Transactions',
          action: 'View All',
          onAction: () => context.go('/wallet-history'),
        ),
        const SizedBox(height: 12),
        PhCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: _recentTransactions
                .take(3)
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => _TransactionTile(
                    transaction: e.value,
                    isLast:
                        e.key ==
                        (_recentTransactions.length > 3
                                ? 3
                                : _recentTransactions.length) -
                            1,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ── Quick Action Tile ─────────────────────────────────────────────────────────

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(
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
}

// ── Transaction Tile ──────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;
  final bool isLast;

  const _TransactionTile({required this.transaction, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPositive
                  ? AppColors.successSurface
                  : AppColors.errorSurface,
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
                    color: AppColors.textPrimary,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    if (diff == 0) return 'Today, $h:$m';
    if (diff == 1) return 'Yesterday, $h:$m';
    return '${date.day}/${date.month}/${date.year}';
  }
}
