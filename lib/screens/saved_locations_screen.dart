import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import '../widgets/ph_widgets.dart';
import '../widgets/toast.dart';

class _Loc {
  final String id, type, label, address;
  final String? details;
  const _Loc({
    required this.id,
    required this.type,
    required this.label,
    required this.address,
    this.details,
  });
  _Loc copyWith({
    String? type,
    String? label,
    String? address,
    String? details,
  }) => _Loc(
    id: id,
    type: type ?? this.type,
    label: label ?? this.label,
    address: address ?? this.address,
    details: details ?? this.details,
  );
}

class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});
  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  var _locs = const [
    _Loc(
      id: '1',
      type: 'home',
      label: 'Home',
      address: '123 Mabolo, Cebu City',
      details: 'Near Mabolo Church',
    ),
    _Loc(
      id: '2',
      type: 'work',
      label: 'Work',
      address: 'IT Park, Lahug, Cebu City',
      details: 'Building 5, 3rd Floor',
    ),
    _Loc(
      id: '3',
      type: 'favorite',
      label: 'Ayala Mall',
      address: 'Ayala Center Cebu, Cebu Business Park',
    ),
    _Loc(
      id: '4',
      type: 'favorite',
      label: 'SM Seaside',
      address: 'SM Seaside City Cebu, South Road Properties',
    ),
  ];

  bool _showDialog = false;
  _Loc? _editing;
  String _dtype = 'home';
  final _labelCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();

  @override
  void dispose() {
    _labelCtrl.dispose();
    _addrCtrl.dispose();
    _detailCtrl.dispose();
    super.dispose();
  }

  void _openAdd() {
    _editing = null;
    _dtype = 'home';
    _labelCtrl.clear();
    _addrCtrl.clear();
    _detailCtrl.clear();
    setState(() => _showDialog = true);
  }

  void _openEdit(_Loc l) {
    _editing = l;
    _dtype = l.type;
    _labelCtrl.text = l.label;
    _addrCtrl.text = l.address;
    _detailCtrl.text = l.details ?? '';
    setState(() => _showDialog = true);
  }

  void _delete(String id) {
    setState(() => _locs = _locs.where((l) => l.id != id).toList());
    showToast(context, 'Location removed');
  }

  void _book(_Loc l) {
    showToast(context, 'Booking ride to ${l.label}...');
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) context.go('/drivers');
    });
  }

  void _save() {
    if (_editing != null) {
      setState(() {
        _locs = _locs
            .map(
              (l) => l.id == _editing!.id
                  ? l.copyWith(
                      type: _dtype,
                      label: _labelCtrl.text,
                      address: _addrCtrl.text,
                      details: _detailCtrl.text.isEmpty
                          ? null
                          : _detailCtrl.text,
                    )
                  : l,
            )
            .toList();
        _showDialog = false;
      });
      showToast(context, 'Location updated');
    } else {
      setState(() {
        _locs = [
          ..._locs,
          _Loc(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: _dtype,
            label: _labelCtrl.text,
            address: _addrCtrl.text,
            details: _detailCtrl.text.isEmpty ? null : _detailCtrl.text,
          ),
        ];
        _showDialog = false;
      });
      showToast(context, 'Location added');
    }
  }

  IconData _icon(String t) => t == 'home'
      ? Icons.home_outlined
      : t == 'work'
      ? Icons.work_outline
      : Icons.bookmark_outline;
  Color _color(String t) => t == 'home'
      ? AppColors.success
      : t == 'work'
      ? AppColors.primary
      : AppColors.amber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: const Text(
                      'Saved Locations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PhButton(
                        label: 'Add New Location',
                        icon: Icons.add,
                        onTap: _openAdd,
                      ).animate().fadeIn(duration: 350.ms),
                      const SizedBox(height: 20),
                      const Text(
                        'Your Locations',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_locs.isEmpty)
                        _EmptyState(onAdd: _openAdd)
                      else
                        ..._locs.asMap().entries.map((e) {
                          final loc = e.value;
                          final color = _color(loc.type);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Icon(
                                        _icon(loc.type),
                                        color: color,
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
                                            loc.label,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            loc.address,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textTertiary,
                                            ),
                                          ),
                                          if (loc.details != null)
                                            Text(
                                              loc.details!,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textTertiary,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 38,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _book(loc),
                                          icon: const Icon(
                                            Icons.place_outlined,
                                            size: 15,
                                          ),
                                          label: const Text(
                                            'Book Ride',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _SmallBtn(
                                      icon: Icons.edit_outlined,
                                      color: AppColors.textTertiary,
                                      onTap: () => _openEdit(loc),
                                    ),
                                    const SizedBox(width: 6),
                                    _SmallBtn(
                                      icon: Icons.delete_outline,
                                      color: AppColors.error,
                                      onTap: () => _delete(loc.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ).animate().fadeIn(
                            delay: (e.key * 60).ms,
                            duration: 350.ms,
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showDialog)
            _Dialog(
              isEditing: _editing != null,
              selectedType: _dtype,
              labelCtrl: _labelCtrl,
              addrCtrl: _addrCtrl,
              detailCtrl: _detailCtrl,
              onTypeChanged: (t) => setState(() => _dtype = t),
              onSave: _save,
              onCancel: () => setState(() => _showDialog = false),
            ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SmallBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

class _Dialog extends StatelessWidget {
  final bool isEditing;
  final String selectedType;
  final TextEditingController labelCtrl, addrCtrl, detailCtrl;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onSave, onCancel;

  const _Dialog({
    required this.isEditing,
    required this.selectedType,
    required this.labelCtrl,
    required this.addrCtrl,
    required this.detailCtrl,
    required this.onTypeChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Location' : 'Add Location',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
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
                    _TypeChip(
                      label: 'Home',
                      icon: Icons.home_outlined,
                      value: 'home',
                      selected: selectedType,
                      onTap: onTypeChanged,
                    ),
                    const SizedBox(width: 8),
                    _TypeChip(
                      label: 'Work',
                      icon: Icons.work_outline,
                      value: 'work',
                      selected: selectedType,
                      onTap: onTypeChanged,
                    ),
                    const SizedBox(width: 8),
                    _TypeChip(
                      label: 'Fave',
                      icon: Icons.bookmark_outline,
                      value: 'favorite',
                      selected: selectedType,
                      onTap: onTypeChanged,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                PhTextField(
                  label: 'Label',
                  hint: 'e.g., Home, Office',
                  controller: labelCtrl,
                ),
                const SizedBox(height: 12),
                PhTextField(
                  label: 'Address',
                  hint: 'Enter full address',
                  controller: addrCtrl,
                ),
                const SizedBox(height: 12),
                PhTextField(
                  label: 'Details (optional)',
                  hint: 'Near landmark, floor, etc.',
                  controller: detailCtrl,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: PhButton(
                        label: 'Cancel',
                        outlined: true,
                        height: 44,
                        onTap: onCancel,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PhButton(
                        label: isEditing ? 'Update' : 'Add',
                        height: 44,
                        onTap: onSave,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label, value, selected;
  final IconData icon;
  final ValueChanged<String> onTap;
  const _TypeChip({
    required this.label,
    required this.icon,
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
          child: Column(
            children: [
              Icon(
                icon,
                size: 16,
                color: active ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: active ? AppColors.primary : AppColors.textTertiary,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_outline,
                size: 36,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No saved locations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add your frequently visited places\nfor faster booking',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 20),
            PhButton(label: 'Add First Location', onTap: onAdd, height: 44),
          ],
        ),
      ),
    );
  }
}
