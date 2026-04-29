/// Driver withdrawal screen for PasaWallet
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/wallet.dart';
import '../../services/wallet_service.dart';
import '../../widgets/ph_widgets.dart';
import '../../theme/app_colors.dart';

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
  Wallet? _wallet;

  final List<double> _quickAmounts = [100, 200, 500, 1000, 2000];

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    final wallet = await WalletService.instance.getWalletByUserId('driver_001');
    setState(() => _wallet = wallet);
  }

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

    if (_wallet == null || amount > _wallet!.balance) {
      _showError('Insufficient balance');
      return;
    }

    if (_selectedMethod != WithdrawMethod.manual &&
        _accountController.text.isEmpty) {
      _showError('Please enter your account number');
      return;
    }

    setState(() => _processing = true);

    try {
      final request = WithdrawalRequest(
        walletId: _wallet!.walletId,
        amount: amount,
        method: _selectedMethod,
        accountNumber: _accountController.text.isNotEmpty
            ? _accountController.text
            : null,
        accountName: _nameController.text.isNotEmpty
            ? _nameController.text
            : null,
      );

      await WalletService.instance.processWithdrawal(request);

      if (context.mounted) {
        _showSuccessSheet(amount);
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _processing = false);
    }
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
      builder: (ctx) => _WithdrawSuccessSheet(
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _buildBalanceInfo(),
                const SizedBox(height: 20),
                _buildAmountSection(),
                const SizedBox(height: 20),
                _buildMethodSection(),
                const SizedBox(height: 20),
                _buildAccountSection(),
                const SizedBox(height: 32),
                _buildActionButtons(),
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
      title: 'Withdraw Funds',
      subtitle: 'Transfer earnings to your account',
      showBack: true,
      dark: true,
    );
  }

  Widget _buildBalanceInfo() {
    final balance = _wallet?.balance ?? 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.driverBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.driverAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.driverAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Balance',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.driverTextMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₱${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.driverText,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _amountController.text = (_wallet?.balance ?? 0).toStringAsFixed(
                0,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.driverAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.driverAccent.withValues(alpha: 0.3),
                ),
              ),
              child: const Text(
                'Max',
                style: TextStyle(
                  fontSize: 12,
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
        const Text(
          'Withdrawal Amount',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.driverText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.driverSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.driverBorder),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    '₱',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.driverText,
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
                        color: AppColors.driverText,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.driverTextMuted,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.driverBorder),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickAmounts.map((amount) {
                  return GestureDetector(
                    onTap: () =>
                        _amountController.text = amount.toStringAsFixed(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.driverBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.driverBorder),
                      ),
                      child: Text(
                        '₱${amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
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
        const Text(
          'Withdrawal Method',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.driverText,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _MethodTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'GCash',
              subtitle: 'Instant payout',
              method: WithdrawMethod.gcash,
              isSelected: _selectedMethod == WithdrawMethod.gcash,
              onTap: () =>
                  setState(() => _selectedMethod = WithdrawMethod.gcash),
            ),
            const SizedBox(height: 8),
            _MethodTile(
              icon: Icons.credit_card_outlined,
              title: 'Maya',
              subtitle: 'Bank transfer',
              method: WithdrawMethod.maya,
              isSelected: _selectedMethod == WithdrawMethod.maya,
              onTap: () =>
                  setState(() => _selectedMethod = WithdrawMethod.maya),
            ),
            const SizedBox(height: 8),
            _MethodTile(
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

  Widget _MethodTile({
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.driverAccent.withValues(alpha: 0.08)
              : AppColors.driverSurface,
          borderRadius: BorderRadius.circular(12),
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.driverAccent.withValues(alpha: 0.15)
                    : AppColors.driverBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.driverAccent
                    : AppColors.driverTextMuted,
                size: 22,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.driverAccent
                          : AppColors.driverText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.driverTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.driverAccent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    if (_selectedMethod == WithdrawMethod.manual) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.driverAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.driverAccent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.driverAccent,
              size: 18,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Admin will contact you to process your withdrawal within 1-2 business days.',
                style: TextStyle(
                  fontSize: 12,
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
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.driverText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.driverSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.driverBorder),
          ),
          child: Column(
            children: [
              _DarkTextField(
                label: 'Mobile Number',
                hint: '09XX XXX XXXX',
                controller: _accountController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              _DarkTextField(
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _processing ? null : _processWithdrawal,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.driverAccent,
              foregroundColor: AppColors.driverBg,
              disabledBackgroundColor: AppColors.driverAccent.withValues(
                alpha: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
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
                : const Text(
                    'Request Withdrawal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.driverTextMuted,
              side: const BorderSide(color: AppColors.driverBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _DarkTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _DarkTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.driverTextMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.driverText, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.driverTextMuted,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.driverBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.driverBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.driverBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.driverAccent,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _WithdrawSuccessSheet extends StatelessWidget {
  final double amount;
  final WithdrawMethod method;
  final VoidCallback onDone;

  const _WithdrawSuccessSheet({
    required this.amount,
    required this.method,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.driverSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Withdrawal Requested!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.driverText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₱${amount.toStringAsFixed(2)} will be sent to your ${method.name.toUpperCase()} account.',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.driverTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Status: Pending Admin Approval',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.amber,
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.driverAccent,
                foregroundColor: AppColors.driverBg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Back to Wallet',
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
