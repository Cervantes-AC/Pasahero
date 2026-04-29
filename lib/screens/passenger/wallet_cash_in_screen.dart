/// Cash-in screen for PasaWallet
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';

class WalletCashInScreen extends StatefulWidget {
  const WalletCashInScreen({super.key});

  @override
  State<WalletCashInScreen> createState() => _WalletCashInScreenState();
}

class _WalletCashInScreenState extends State<WalletCashInScreen> {
  final TextEditingController _amountController = TextEditingController();
  CashInMethod _selectedMethod = CashInMethod.gcash;
  bool _processing = false;
  Wallet? _wallet;

  final List<double> _quickAmounts = [50, 100, 200, 500, 1000];

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    final wallet = await WalletService.instance.getWalletByUserId(
      'passenger_001',
    );
    setState(() => _wallet = wallet);
  }

  Future<void> _processCashIn() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (amount < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum cash-in amount is ₱10')),
      );
      return;
    }

    setState(() => _processing = true);

    try {
      final request = CashInRequest(
        walletId: _wallet!.walletId,
        amount: amount,
        method: _selectedMethod,
      );

      final transaction = await WalletService.instance.processCashIn(request);

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully added ₱${amount.toStringAsFixed(2)} to your wallet',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    } finally {
      setState(() => _processing = false);
    }
  }

  void _selectQuickAmount(double amount) {
    _amountController.text = amount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _CashInHeader()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _AmountSection(),
                const SizedBox(height: 24),
                _MethodSection(),
                const SizedBox(height: 32),
                _ActionButtons(),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _CashInHeader() {
    return PhAppBar(
      title: 'Cash In',
      subtitle: 'Add money to your PasaWallet',
      showBack: true,
    );
  }

  Widget _AmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How much would you like to add?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        PhCard(
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    '₱',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiary,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const PhDivider(),
              const SizedBox(height: 16),
              const Text(
                'Quick Amounts',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickAmounts.map((amount) {
                  return GestureDetector(
                    onTap: () => _selectQuickAmount(amount),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '₱${amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _MethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select payment method',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _MethodOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'GCash',
              subtitle: 'Instant transfer',
              method: CashInMethod.gcash,
              isSelected: _selectedMethod == CashInMethod.gcash,
              onTap: () => setState(() => _selectedMethod = CashInMethod.gcash),
            ),
            const SizedBox(height: 8),
            _MethodOption(
              icon: Icons.credit_card_outlined,
              title: 'Maya',
              subtitle: 'Bank transfer',
              method: CashInMethod.maya,
              isSelected: _selectedMethod == CashInMethod.maya,
              onTap: () => setState(() => _selectedMethod = CashInMethod.maya),
            ),
            const SizedBox(height: 8),
            _MethodOption(
              icon: Icons.person_outline,
              title: 'Manual Cash-in',
              subtitle: 'Admin-assisted',
              method: CashInMethod.manual,
              isSelected: _selectedMethod == CashInMethod.manual,
              onTap: () =>
                  setState(() => _selectedMethod = CashInMethod.manual),
            ),
          ],
        ),
      ],
    );
  }

  Widget _MethodOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required CashInMethod method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _ActionButtons() {
    return Column(
      children: [
        PhButton(
          label: _processing ? 'Processing...' : 'Add Money',
          onTap: _processing ? null : _processCashIn,
          loading: _processing,
        ),
        const SizedBox(height: 12),
        PhButton(label: 'Cancel', outlined: true, onTap: () => context.pop()),
      ],
    );
  }
}
