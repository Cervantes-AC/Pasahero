/// Passenger profile screen — fully functional with mock data
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/ph_widgets.dart';
import '../../widgets/toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Add payment method sheet ──────────────────────────────────────────────
  void _showAddPaymentSheet() {
    final typeNotifier = ValueNotifier<String>('gcash');
    final numberCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SheetHandle(),
              const Text(
                'Add Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: typeNotifier,
                builder: (_, type, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _PayTypeChip(
                          label: 'GCash',
                          value: 'gcash',
                          selected: type,
                          onTap: (v) => typeNotifier.value = v,
                        ),
                        const SizedBox(width: 8),
                        _PayTypeChip(
                          label: 'Maya',
                          value: 'maya',
                          selected: type,
                          onTap: (v) => typeNotifier.value = v,
                        ),
                        const SizedBox(width: 8),
                        _PayTypeChip(
                          label: 'Cash',
                          value: 'cash',
                          selected: type,
                          onTap: (v) => typeNotifier.value = v,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (type != 'cash')
                      PhTextField(
                        label: 'Mobile Number',
                        hint: '09XX XXX XXXX',
                        controller: numberCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PhButton(
                label: 'Add Method',
                onTap: () {
                  final type = typeNotifier.value;
                  AppState.instance.addPaymentMethod(
                    PaymentMethod(
                      id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
                      type: type,
                      displayName: type == 'gcash'
                          ? 'GCash'
                          : type == 'maya'
                          ? 'Maya'
                          : 'Cash',
                      accountNumber: type == 'cash'
                          ? 'Pay on Ride'
                          : numberCtrl.text.isEmpty
                          ? 'Not set'
                          : numberCtrl.text,
                    ),
                  );
                  Navigator.pop(ctx);
                  setState(() {});
                  showToast(context, 'Payment method added');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add emergency contact sheet ───────────────────────────────────────────
  void _showAddContactSheet({EmergencyContact? editing}) {
    final nameCtrl = TextEditingController(text: editing?.name ?? '');
    final relCtrl = TextEditingController(text: editing?.relationship ?? '');
    final phoneCtrl = TextEditingController(text: editing?.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SheetHandle(),
              Text(
                editing != null ? 'Edit Contact' : 'Add Emergency Contact',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              PhTextField(
                label: 'Full Name',
                hint: 'Contact name',
                controller: nameCtrl,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              PhTextField(
                label: 'Relationship',
                hint: 'e.g., Spouse, Parent, Sibling',
                controller: relCtrl,
                prefixIcon: Icons.people_outline,
              ),
              const SizedBox(height: 12),
              PhTextField(
                label: 'Phone Number',
                hint: '+63 9XX XXX XXXX',
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: 20),
              PhButton(
                label: editing != null ? 'Update Contact' : 'Add Contact',
                onTap: () {
                  if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
                    showToast(
                      ctx,
                      'Name and phone are required',
                      isError: true,
                    );
                    return;
                  }
                  if (editing != null) {
                    editing.name = nameCtrl.text;
                    editing.relationship = relCtrl.text;
                    editing.phone = phoneCtrl.text;
                    AppState.instance.updateEmergencyContact(editing);
                  } else {
                    AppState.instance.addEmergencyContact(
                      EmergencyContact(
                        id: 'ec_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameCtrl.text,
                        relationship: relCtrl.text,
                        phone: phoneCtrl.text,
                      ),
                    );
                  }
                  Navigator.pop(ctx);
                  setState(() {});
                  showToast(
                    context,
                    editing != null
                        ? 'Contact updated'
                        : 'Emergency contact added',
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Forgot password sheet ─────────────────────────────────────────────────
  void _showForgotPasswordSheet() {
    final phoneCtrl = TextEditingController();
    bool sent = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHandle(),
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your registered phone number and we\'ll send you a reset code.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (!sent) ...[
                  PhTextField(
                    label: 'Phone Number',
                    hint: '+63 9XX XXX XXXX',
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 20),
                  PhButton(
                    label: 'Send Reset Code',
                    onTap: () async {
                      if (phoneCtrl.text.isEmpty) {
                        showToast(
                          ctx,
                          'Please enter your phone number',
                          isError: true,
                        );
                        return;
                      }
                      await Future.delayed(const Duration(milliseconds: 800));
                      setSheetState(() => sent = true);
                    },
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Reset code sent to ${phoneCtrl.text}. Check your SMS.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PhButton(label: 'Done', onTap: () => Navigator.pop(ctx)),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = AppState.instance;
    final name = state.passengerName;
    final phone = state.passengerPhone;
    final initials = name.split(' ').map((n) => n[0]).join();
    final hp = Responsive.hPad(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          PhAppBar(
            title: 'Profile',
            showBack: true,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  // ── Profile card ─────────────────────────────────────────
                  PhCard(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => showToast(
                                      context,
                                      'Photo upload coming soon',
                                    ),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              name,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(phone, style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Member since Jan 2024',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            PhButton(
                              label: 'Edit Profile',
                              outlined: true,
                              height: 48,
                              onTap: () async {
                                await context.push('/edit-profile');
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 20),

                  // ── Payment methods ───────────────────────────────────────
                  PhSectionHeader(
                    title: 'Payment Methods',
                    action: '+ Add',
                    onAction: _showAddPaymentSheet,
                  ),
                  const SizedBox(height: 10),
                  ...state.paymentMethods.asMap().entries.map((e) {
                    final m = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child:
                          PhCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _payColor(
                                      m.type,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _payIcon(m.type),
                                    color: _payColor(m.type),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        m.accountNumber,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (m.isPrimary)
                                  const PhBadge(
                                    label: 'Primary',
                                    color: AppColors.primary,
                                  )
                                else
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            AppState.instance.setPrimaryPayment(
                                              m.id,
                                            );
                                          });
                                          showToast(
                                            context,
                                            '${m.displayName} set as primary',
                                          );
                                        },
                                        child: const Text(
                                          'Set primary',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            AppState.instance
                                                .removePaymentMethod(m.id);
                                          });
                                          showToast(
                                            context,
                                            '${m.displayName} removed',
                                          );
                                        },
                                        child: const Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ).animate().fadeIn(
                            delay: (e.key * 60).ms,
                            duration: 350.ms,
                          ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // ── Emergency contacts ────────────────────────────────────
                  PhSectionHeader(
                    title: 'Emergency Contacts',
                    action: '+ Add',
                    onAction: _showAddContactSheet,
                  ),
                  const SizedBox(height: 10),
                  ...state.emergencyContacts.asMap().entries.map((e) {
                    final c = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child:
                          PhCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.errorLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.phone_outlined,
                                    color: AppColors.error,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        c.relationship,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                      Text(
                                        c.phone,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          _showAddContactSheet(editing: c),
                                      child: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          AppState.instance
                                              .removeEmergencyContact(c.id);
                                        });
                                        showToast(context, '${c.name} removed');
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ).animate().fadeIn(
                            delay: (e.key * 60).ms,
                            duration: 350.ms,
                          ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // ── Account actions ───────────────────────────────────────
                  PhCard(
                    child: Column(
                      children: [
                        _AccountRow(
                          icon: Icons.lock_outline,
                          label: 'Change Password',
                          onTap: _showForgotPasswordSheet,
                        ),
                        const PhDivider(),
                        _AccountRow(
                          icon: Icons.notifications_outlined,
                          label: 'Notification Settings',
                          onTap: () => showToast(
                            context,
                            'Notification settings coming soon',
                          ),
                        ),
                        const PhDivider(),
                        _AccountRow(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Privacy Policy',
                          onTap: () =>
                              showToast(context, 'Opening privacy policy...'),
                        ),
                        const PhDivider(),
                        _AccountRow(
                          icon: Icons.help_outline,
                          label: 'Help & Support',
                          onTap: () =>
                              showToast(context, 'Opening help center...'),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 350.ms),

                  const SizedBox(height: 24),

                  PhButton(
                    label: 'Log Out',
                    outlined: true,
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.error,
                    icon: Icons.logout,
                    onTap: () {
                      showToast(context, 'Logged out successfully');
                      Future.delayed(const Duration(milliseconds: 800), () {
                        if (context.mounted) context.go('/');
                      });
                    },
                  ).animate().fadeIn(delay: 300.ms, duration: 350.ms),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _payIcon(String type) {
    switch (type) {
      case 'gcash':
        return Icons.account_balance_wallet_outlined;
      case 'maya':
        return Icons.credit_card_outlined;
      case 'pasawallet':
        return Icons.wallet_outlined;
      default:
        return Icons.payments_outlined;
    }
  }

  Color _payColor(String type) {
    switch (type) {
      case 'gcash':
        return AppColors.primary;
      case 'maya':
        return AppColors.success;
      case 'pasawallet':
        return AppColors.amber;
      default:
        return AppColors.textTertiary;
    }
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AccountRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _PayTypeChip extends StatelessWidget {
  final String label, value, selected;
  final ValueChanged<String> onTap;

  const _PayTypeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primarySurface : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
