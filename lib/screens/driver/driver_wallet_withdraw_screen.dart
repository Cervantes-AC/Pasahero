/// Driver withdrawal screen for PasaWallet
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/wallet.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';

class DriverWalletWithdrawScreen extends StatefulWidget {
  const DriverWalletWithdrawScreen({super.key});

  @override
  State<DriverWalletWithdrawScreen> createState() =>
      _DriverWalletWithdrawScreenState();
}

class _DriverWalletWithdrawScreenState
    extends State<DriverWalletWithdrawScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  WithdrawMethod _selectedMethod = WithdrawMethod.gcash;
  bool _processing = false;

  // Mock wallet balance
  final double _balance = 912.50;

  final List<double> _quickAmounts = [100, 200, 500, 1000, 2000];

  Future<void> _processWithdrawal() async {
    if (_amountController.text.isEmpty) {
      _showError('Please enter an amount');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    if (amount < 50) {
      _showError('Minimum withdrawal amount is ₱50');
      return;
    }

    if (amount > _balance) {
      _showError('Insufficient balance');
      return;
    }

    if (_selectedMethod != WithdrawMethod.manual &&
        _accountController.text.isEmpty) {
      _showError('Please enter your account number');
      return;
    }

    setState(() => _processing = true);

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    _showSuccessSheet(amount);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccessSheet(double amount) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _withdrawSuccessSheet(
        amount: amount,
        method: _selectedMethod,
        onDone: () {
          Navigator.pop(ctx);
          context.go('/driver-wallet');
        },
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _nameController.dispose();
    super.dispose();
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
                _buildBalanceInfo(),
                SizedBox(height: Responsive.spacing(context, units: 2.5)),
                _buildAmountSection(),
                SizedBox(height: Responsive.spacing(context, units: 2.5)),
                _buildMethodSection(),
                SizedBox(height: Responsive.spacing(context, units: 2.5)),
                _buildAccountSection(),
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
      title: 'Withdraw Funds',
      subtitle: 'Transfer earnings to your account',
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

  Widget _buildBalanceInfo() {
    final balance = _balance;
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
      decoration: BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, base: 14),
        ),
        border: Border.all(color: AppColors.driverBorder),
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.iconSize(context, base: 44),
            height: Responsive.iconSize(context, base: 44),
            decoration: BoxDecoration(
              color: AppColors.driverAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 10),
              ),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.driverAccent,
              size: Responsive.iconSize(context, base: 22),
            ),
          ),
          SizedBox(width: Responsive.spacing(context, units: 1.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Balance',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 12),
                    color: AppColors.driverTextMuted,
                  ),
                ),
                SizedBox(height: Responsive.spacing(context, units: 0.25)),
                Text(
                  '₱${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.driverText,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _amountController.text = _balance.toStringAsFixed(0);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, units: 1.5),
                vertical: Responsive.spacing(context, units: 0.75),
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
              child: Text(
                'Max',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 12),
                  fontWeight: FontWeight.w700,
                  color: AppColors.driverAccent,
                ),
              ),
            ),
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
          'Withdrawal Amount',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: AppColors.driverText,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        Container(
          padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
          decoration: BoxDecoration(
            color: AppColors.driverSurface,
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 14),
            ),
            border: Border.all(color: AppColors.driverBorder),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '₱',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 24),
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
              SizedBox(height: Responsive.spacing(context, units: 1.5)),
              const Divider(color: AppColors.driverBorder),
              SizedBox(height: Responsive.spacing(context, units: 1.5)),
              Wrap(
                spacing: Responsive.spacing(context, units: 1),
                runSpacing: Responsive.spacing(context, units: 1),
                children: _quickAmounts.map((amount) {
                  return GestureDetector(
                    onTap: () =>
                        _amountController.text = amount.toStringAsFixed(0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.spacing(context, units: 1.75),
                        vertical: Responsive.spacing(context, units: 1),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.driverBg,
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(context, base: 10),
                        ),
                        border: Border.all(color: AppColors.driverBorder),
                      ),
                      child: Text(
                        '₱${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 13),
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
          'Withdrawal Method',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: AppColors.driverText,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        Column(
          children: [
            _methodTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'GCash',
              subtitle: 'Instant payout',
              method: WithdrawMethod.gcash,
              isSelected: _selectedMethod == WithdrawMethod.gcash,
              onTap: () =>
                  setState(() => _selectedMethod = WithdrawMethod.gcash),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            _methodTile(
              icon: Icons.credit_card_outlined,
              title: 'Maya',
              subtitle: 'Bank transfer',
              method: WithdrawMethod.maya,
              isSelected: _selectedMethod == WithdrawMethod.maya,
              onTap: () =>
                  setState(() => _selectedMethod = WithdrawMethod.maya),
            ),
            SizedBox(height: Responsive.spacing(context, units: 1)),
            _methodTile(
              icon: Icons.support_agent_outlined,
              title: 'Admin Payout',
              subtitle: 'Manual processing (1-2 days)',
              method: WithdrawMethod.manual,
              isSelected: _selectedMethod == WithdrawMethod.manual,
              onTap: () =>
                  setState(() => _selectedMethod = WithdrawMethod.manual),
            ),
          ],
        ),
      ],
    );
  }

  Widget _methodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required WithdrawMethod method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Responsive.spacing(context, units: 1.75)),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.driverAccent.withValues(alpha: 0.08)
              : AppColors.driverSurface,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 12),
          ),
          border: Border.all(
            color: isSelected
                ? AppColors.driverAccent.withValues(alpha: 0.5)
                : AppColors.driverBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: Responsive.iconSize(context, base: 44),
              height: Responsive.iconSize(context, base: 44),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.driverAccent.withValues(alpha: 0.15)
                    : AppColors.driverBg,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 10),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.driverAccent
                    : AppColors.driverTextMuted,
                size: Responsive.iconSize(context, base: 22),
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
                      fontSize: Responsive.fontSize(context, 14),
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

  Widget _buildAccountSection() {
    if (_selectedMethod == WithdrawMethod.manual) {
      return Container(
        padding: EdgeInsets.all(Responsive.spacing(context, units: 1.75)),
        decoration: BoxDecoration(
          color: AppColors.driverAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, base: 12),
          ),
          border: Border.all(
            color: AppColors.driverAccent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.driverAccent,
              size: Responsive.iconSize(context, base: 18),
            ),
            SizedBox(width: Responsive.spacing(context, units: 1.25)),
            Expanded(
              child: Text(
                'Admin will contact you to process your withdrawal within 1-2 business days.',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 12),
                  color: AppColors.driverTextMuted,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_selectedMethod == WithdrawMethod.gcash ? 'GCash' : 'Maya'} Account Details',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 15),
            fontWeight: FontWeight.w600,
            color: AppColors.driverText,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 1.5)),
        Container(
          padding: EdgeInsets.all(Responsive.spacing(context, units: 2)),
          decoration: BoxDecoration(
            color: AppColors.driverSurface,
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, base: 14),
            ),
            border: Border.all(color: AppColors.driverBorder),
          ),
          child: Column(
            children: [
              _darkTextField(
                label: 'Mobile Number',
                hint: '09XX XXX XXXX',
                controller: _accountController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: Responsive.spacing(context, units: 1.75)),
              _darkTextField(
                label: 'Account Name',
                hint: 'Full name on account',
                controller: _nameController,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _darkTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 12),
            color: AppColors.driverTextMuted,
          ),
        ),
        SizedBox(height: Responsive.spacing(context, units: 0.75)),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: AppColors.driverText,
            fontSize: Responsive.fontSize(context, 15),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.driverTextMuted,
              fontSize: Responsive.fontSize(context, 14),
            ),
            filled: true,
            fillColor: AppColors.driverBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 10),
              ),
              borderSide: const BorderSide(color: AppColors.driverBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 10),
              ),
              borderSide: const BorderSide(color: AppColors.driverBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 10),
              ),
              borderSide: const BorderSide(
                color: AppColors.driverAccent,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 1.75),
              vertical: Responsive.spacing(context, units: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final fee = _calculateFee(amount);
    final netAmount = amount - fee;

    return Column(
      children: [
        // Fee breakdown
        if (amount > 0)
          Container(
            padding: EdgeInsets.all(Responsive.spacing(context, units: 1.75)),
            decoration: BoxDecoration(
              color: AppColors.driverAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 12),
              ),
              border: Border.all(
                color: AppColors.driverAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Withdrawal Amount',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 12),
                        color: AppColors.driverTextMuted,
                      ),
                    ),
                    Text(
                      '₱${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 12),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.spacing(context, units: 0.75)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Processing Fee',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 12),
                        color: AppColors.driverTextMuted,
                      ),
                    ),
                    Text(
                      '-₱${fee.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.spacing(context, units: 0.75)),
                Divider(
                  color: AppColors.driverBorder,
                  height: Responsive.spacing(context, units: 1.5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You\'ll Receive',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 13),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '₱${netAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 13),
                        fontWeight: FontWeight.w700,
                        color: AppColors.driverAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        SizedBox(height: Responsive.spacing(context, units: 2)),
        SizedBox(
          width: double.infinity,
          height: Responsive.buttonHeight(context),
          child: ElevatedButton(
            onPressed: _processing ? null : _processWithdrawal,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.driverAccent,
              foregroundColor: AppColors.driverBg,
              disabledBackgroundColor: AppColors.driverAccent.withValues(
                alpha: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 14),
                ),
              ),
            ),
            child: _processing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.driverBg,
                    ),
                  )
                : Text(
                    'Request Withdrawal',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 15),
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
              foregroundColor: AppColors.driverTextMuted,
              side: const BorderSide(color: AppColors.driverBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, base: 14),
                ),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.fontSize(context, 15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateFee(double amount) {
    if (_selectedMethod == WithdrawMethod.gcash) {
      return amount * 0.02; // 2% fee for GCash
    } else if (_selectedMethod == WithdrawMethod.maya) {
      return amount * 0.025; // 2.5% fee for Maya
    } else {
      return 0; // No fee for manual
    }
  }

  Widget _withdrawSuccessSheet({
    required double amount,
    required WithdrawMethod method,
    required VoidCallback onDone,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(Responsive.spacing(context, units: 4)),
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
          Container(
            width: Responsive.iconSize(context, base: 72),
            height: Responsive.iconSize(context, base: 72),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: Responsive.iconSize(context, base: 36),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 2.5)),
          Text(
            'Withdrawal Requested!',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 20),
              fontWeight: FontWeight.w700,
              color: AppColors.driverText,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1)),
          Text(
            '₱${amount.toStringAsFixed(2)} will be sent to your ${method.name.toUpperCase()} account.',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 14),
              color: AppColors.driverTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Responsive.spacing(context, units: 1)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, units: 1.5),
              vertical: Responsive.spacing(context, units: 0.75),
            ),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, base: 8),
              ),
            ),
            child: Text(
              'Status: Pending Admin Approval',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 12),
                fontWeight: FontWeight.w600,
                color: AppColors.amber,
              ),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 3.5)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
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
                'Back to Wallet',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Responsive.fontSize(context, 15),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.spacing(context, units: 1)),
        ],
      ),
    );
  }
}
