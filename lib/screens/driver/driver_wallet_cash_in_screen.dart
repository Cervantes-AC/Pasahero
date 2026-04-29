/// Driver wallet cash-in/top-up screen
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';

class DriverWalletCashInScreen extends StatefulWidget {
  const DriverWalletCashInScreen({super.key});

  @override
  State<DriverWalletCashInScreen> createState() =>
      _DriverWalletCashInScreenState();
}

class _DriverWalletCashInScreenState extends State<DriverWalletCashInScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'gcash';
  bool _processing = false;

  final List<double> _quickAmounts = [100, 500, 1000, 2000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _processTopUp() async {
    if (!mounted) return;

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

    if (amount < 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum top-up amount is ₱50')),
      );
      return;
    }

    setState(() => _processing = true);

    try {
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Show success (mock)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Top-up request submitted for ₱${amount.toStringAsFixed(2)}',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back
      context.pop();
    } catch (e) {
      debugPrint('Error processing top-up: $e');
      if (mounted) {
        setState(() => _processing = false);
      }
    }
  }

  void _selectQuickAmount(double amount) {
    _amountController.text = amount.toStringAsFixed(0);
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
                _buildInfoCard(),
                SizedBox(height: Responsive.spacing(context, units: 2.5)),
                _buildAmountSection(),
                SizedBox(height: Responsive.spacing(context, units: 3)),
                _buildMethodSection(),
                SizedBox(height: Responsive.spacing(context, units: 4)),
                _buildActionButtons(),
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
      title: 'Wallet Top-Up',
      subtitle: 'Add funds to your PasaWallet',
      showBack: true,
      onBack: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          context.go('/driver-wallet');
        }
      },
      dark: true,
    );
  }

  Widget _buildInfoCard() {
    return PhDriverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.driverAccent,
                size: Responsive.iconSize(context, base: 20),
              ),
              SizedBox(width: Responsive.spacing(context, units: 1)),
              Expanded(
                child: Text(
                  'Top up your wallet to have funds ready for expenses',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 13),
                    color: AppColors.driverTextMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How much would you like to add?',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: AppColors.driverText,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        PhDriverCard(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '₱',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 28),
                      fontWeight: FontWeight.w700,
                      color: AppColors.driverText,
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
                        color: AppColors.driverText,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: Responsive.fontSize(context, 32),
                          fontWeight: FontWeight.w700,
                          color: AppColors.driverTextMuted,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.spacing(context, units: 2)),
              Container(height: 1, color: AppColors.driverBorder),
              SizedBox(height: Responsive.spacing(context, units: 2)),
              Text(
                'Quick Amounts',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 13),
                  color: AppColors.driverTextMuted,
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
                        color: AppColors.driverSurface,
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(context, base: 12),
                        ),
                        border: Border.all(color: AppColors.driverBorder),
                      ),
                      child: Text(
                        '₱${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.driverText,
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

  Widget _buildMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select payment method',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: AppColors.driverText,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        Column(
          children: [
            _buildMethodOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'GCash',
              subtitle: 'Instant transfer',
              value: 'gcash',
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            _buildMethodOption(
              icon: Icons.credit_card_outlined,
              title: 'Maya',
              subtitle: 'Bank transfer',
              value: 'maya',
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            _buildMethodOption(
              icon: Icons.account_balance_outlined,
              title: 'Bank Transfer',
              subtitle: '1-2 business days',
              value: 'bank',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _selectedMethod == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: Container(
        padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.driverAccent.withValues(alpha: 0.1)
              : AppColors.driverSurface,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 12),
          ),
          border: Border.all(
            color: isSelected ? AppColors.driverAccent : AppColors.driverBorder,
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
                    ? AppColors.driverAccent.withValues(alpha: 0.15)
                    : AppColors.driverBorder.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 10),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.driverAccent
                    : AppColors.driverTextMuted,
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
                          ? AppColors.driverAccent
                          : AppColors.driverText,
                    ),
                  ),
                  SizedBox(height: Responsive.spacing(context, units: 0.25)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 12),
                      color: AppColors.driverTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.driverAccent,
                size: Responsive.iconSize(context, base: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: Responsive.buttonHeight(context),
          child: ElevatedButton(
            onPressed: _processing ? null : _processTopUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.driverAccent,
              foregroundColor: AppColors.driverBg,
              disabledBackgroundColor: AppColors.driverAccent.withValues(
                alpha: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 12),
                ),
              ),
            ),
            child: _processing
                ? SizedBox(
                    height: Responsive.spacing(context, units: 2),
                    width: Responsive.spacing(context, units: 2),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Add Money',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        SizedBox(
          width: double.infinity,
          height: Responsive.buttonHeight(context),
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.driverAccent,
              side: const BorderSide(color: AppColors.driverAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 12),
                ),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 16),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
