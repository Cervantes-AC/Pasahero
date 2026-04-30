/// Cash-in screen for PasaWallet
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/wallet.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';

class WalletCashInScreen extends StatefulWidget {
  const WalletCashInScreen({super.key});

  @override
  State<WalletCashInScreen> createState() => _WalletCashInScreenState();
}

class _WalletCashInScreenState extends State<WalletCashInScreen> {
  final TextEditingController _amountController = TextEditingController();
  CashInMethod _selectedMethod = CashInMethod.gcash;
  bool _processing = false;

  final List<double> _quickAmounts = [50, 100, 200, 500, 1000];

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

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Show success (mock)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Successfully added ₱${amount.toStringAsFixed(2)} to your wallet',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/wallet');
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
          SliverToBoxAdapter(child: _cashInHeader()),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 2),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: Responsive.spacing(context, units: 2.5)),
                _amountSection(),
                SizedBox(height: Responsive.spacing(context, units: 3)),
                _methodSection(),
                SizedBox(height: Responsive.spacing(context, units: 4)),
                _actionButtons(),
                SizedBox(height: Responsive.spacing(context, units: 5)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cashInHeader() {
    return PhAppBar(
      title: 'Cash In',
      subtitle: 'Add money to your PasaWallet',
      showBack: true,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/wallet');
        }
      },
    );
  }

  Widget _amountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How much would you like to add?',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        PhCard(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '₱',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 24),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: Responsive.spacing(context, units: 1)),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 32),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: Responsive.fontSize(context, 32),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiary,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.spacing(context, units: 2)),
              const PhDivider(),
              SizedBox(height: Responsive.spacing(context, units: 2)),
              Text(
                'Quick Amounts',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 13),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: Responsive.spacing(context, units: 1.5)),
              Wrap(
                spacing: Responsive.spacing(context, units: 1),
                runSpacing: Responsive.spacing(context, units: 1),
                children: _quickAmounts.map((amount) {
                  return GestureDetector(
                    onTap: () => _selectQuickAmount(amount),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.spacing(context, units: 2),
                        vertical: Responsive.spacing(context, units: 1.25),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(context, base: 12),
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '₱${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 14),
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

  Widget _methodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select payment method',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        Column(
          children: [
            _methodOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'GCash',
              subtitle: 'Instant transfer',
              method: CashInMethod.gcash,
              isSelected: _selectedMethod == CashInMethod.gcash,
              onTap: () => setState(() => _selectedMethod = CashInMethod.gcash),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            _methodOption(
              icon: Icons.credit_card_outlined,
              title: 'Maya',
              subtitle: 'Bank transfer',
              method: CashInMethod.maya,
              isSelected: _selectedMethod == CashInMethod.maya,
              onTap: () => setState(() => _selectedMethod = CashInMethod.maya),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            _methodOption(
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

  Widget _methodOption({
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
        padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 12),
          ),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: Responsive.iconSize(context, base: 48),
              height: Responsive.iconSize(context, base: 48),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 10),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                size: Responsive.iconSize(context, base: 24),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 15),
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 0.25)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 12),
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: Responsive.iconSize(context, base: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        PhButton(
          label: _processing ? 'Processing...' : 'Add Money',
          onTap: _processing ? null : _processCashIn,
          loading: _processing,
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        PhButton(
          label: 'Cancel',
          outlined: true,
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/wallet');
            }
          },
        ),
      ],
    );
  }
}
