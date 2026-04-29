/// Passenger wallet overview screen for PasaWallet
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';

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
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 2),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: Responsive.spacing(context, units: 2.5)),
                _buildBalanceCard(),
                SizedBox(height: Responsive.spacing(context, units: 3)),
                _buildQuickActions(),
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

  Widget _buildBalanceCard() {
    if (_loading) {
      return PhCard(
        child: SizedBox(
          height: Responsive.buttonHeight(context) * 2,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    final balance = _wallet?.balance ?? 0.0;

    return PhCard(
      child: Column(
        children: [
          Text(
            'Available Balance',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 13),
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1)),
          Text(
            '₱${balance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 48),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 0.5)),
          Text(
            '≈ \${(balance / 56).toStringAsFixed(2)} USD',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 12),
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 2.5)),
          Row(
            children: [
              Expanded(
                child: PhButton(
                  label: 'Cash In',
                  icon: Icons.add_circle_outline,
                  onTap: () => context.go('/wallet-cash-in'),
                ),
              ),
              SizedBox(width: Responsive.spacing(context, units: 1.5)),
              Expanded(
                child: PhButton(
                  label: 'History',
                  icon: Icons.history_outlined,
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
        PhSectionHeader(title: 'Quick Actions'),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        Row(
          children: [
            Expanded(
              child: _quickActionTile(
                icon: Icons.payment_outlined,
                label: 'Pay Ride',
                color: AppColors.primary,
                onTap: () => _showPayRideModal(),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.5)),
            Expanded(
              child: _quickActionTile(
                icon: Icons.qr_code_outlined,
                label: 'Scan QR',
                color: AppColors.success,
                onTap: () => _showScanQRModal(),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.5)),
            Expanded(
              child: _quickActionTile(
                icon: Icons.share_outlined,
                label: 'Send Money',
                color: AppColors.amber,
                onTap: () => _showSendMoneyModal(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPayRideModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            SizedBox(height: Responsive.spacing(context, units: 2)),
            Icon(
              Icons.payment_outlined,
              size: Responsive.iconSize(context, base: 48),
              color: AppColors.primary,
            ),
            SizedBox(height: Responsive.spacing(context, units: 2)),
            Text(
              'Pay for Your Ride',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            Text(
              'Select PasaWallet as your payment method when booking a ride to pay directly from your wallet balance.',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
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
                  'Got it',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.fontSize(context, 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScanQRModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            SizedBox(height: Responsive.spacing(context, units: 2)),
            Icon(
              Icons.qr_code_outlined,
              size: Responsive.iconSize(context, base: 48),
              color: AppColors.success,
            ),
            SizedBox(height: Responsive.spacing(context, units: 2)),
            Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            Text(
              'Scan a merchant QR code to make payments directly from your PasaWallet. This feature is coming soon.',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.spacing(context, units: 3)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
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
                  'Notify Me',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.fontSize(context, 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSendMoneyModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            SizedBox(height: Responsive.spacing(context, units: 2)),
            Icon(
              Icons.share_outlined,
              size: Responsive.iconSize(context, base: 48),
              color: AppColors.amber,
            ),
            SizedBox(height: Responsive.spacing(context, units: 2)),
            Text(
              'Send Money',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            Text(
              'Transfer money to other PasaWallet users or to bank accounts. This feature is coming soon.',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.spacing(context, units: 3)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.amber,
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
                  'Notify Me',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.fontSize(context, 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionTile({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 12),
          ),
          border: Border.all(color: AppColors.border),
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
                color: AppColors.textSecondary,
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

    if (_recentTransactions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhSectionHeader(title: 'Recent Transactions'),
          SizedBox(height: Responsive.spacing(context, units: 1.5)),
          PhCard(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.textTertiary,
                  size: Responsive.iconSize(context, base: 48),
                ),
                SizedBox(height: Responsive.spacing(context, units: 1.5)),
                Text(
                  'No transactions yet',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 14),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, units: 0.5)),
                Text(
                  'Start by adding money to your wallet',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 12),
                    color: AppColors.textTertiary,
                  ),
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
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        PhCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: _recentTransactions
                .take(3)
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => _transactionTile(
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

  Widget _transactionTile({
    required WalletTransaction transaction,
    required bool isLast,
  }) {
    final isPositive = transaction.isPositive;
    final amountColor = isPositive ? AppColors.success : AppColors.error;

    return Container(
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
            width: Responsive.iconSize(context, base: 40),
            height: Responsive.iconSize(context, base: 40),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppColors.successSurface
                  : AppColors.errorSurface,
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
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, units: 0.25)),
                Text(
                  _formatDate(transaction.timestamp),
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 11),
                    color: AppColors.textTertiary,
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
