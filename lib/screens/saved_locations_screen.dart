import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../widgets/toast.dart';

class _SavedLocation {
  final String id;
  final String type; // 'home' | 'work' | 'favorite'
  final String label;
  final String address;
  final String? details;

  const _SavedLocation({
    required this.id,
    required this.type,
    required this.label,
    required this.address,
    this.details,
  });

  _SavedLocation copyWith({
    String? label,
    String? address,
    String? details,
    String? type,
  }) {
    return _SavedLocation(
      id: id,
      type: type ?? this.type,
      label: label ?? this.label,
      address: address ?? this.address,
      details: details ?? this.details,
    );
  }
}

class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  var _locations = const [
    _SavedLocation(
      id: '1',
      type: 'home',
      label: 'Home',
      address: '123 Mabolo, Cebu City',
      details: 'Near Mabolo Church',
    ),
    _SavedLocation(
      id: '2',
      type: 'work',
      label: 'Work',
      address: 'IT Park, Lahug, Cebu City',
      details: 'Building 5, 3rd Floor',
    ),
    _SavedLocation(
      id: '3',
      type: 'favorite',
      label: 'Ayala Mall',
      address: 'Ayala Center Cebu, Cebu Business Park',
    ),
    _SavedLocation(
      id: '4',
      type: 'favorite',
      label: 'SM Seaside',
      address: 'SM Seaside City Cebu, South Road Properties',
    ),
  ];

  bool _showDialog = false;
  _SavedLocation? _editingLocation;
  String _dialogType = 'home';
  final _labelController = TextEditingController();
  final _addressController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _openAdd() {
    _editingLocation = null;
    _dialogType = 'home';
    _labelController.clear();
    _addressController.clear();
    _detailsController.clear();
    setState(() => _showDialog = true);
  }

  void _openEdit(_SavedLocation loc) {
    _editingLocation = loc;
    _dialogType = loc.type;
    _labelController.text = loc.label;
    _addressController.text = loc.address;
    _detailsController.text = loc.details ?? '';
    setState(() => _showDialog = true);
  }

  void _handleDelete(String id) {
    setState(() => _locations = _locations.where((l) => l.id != id).toList());
    showToast(context, 'Location removed');
  }

  void _handleBook(_SavedLocation loc) {
    showToast(context, 'Booking ride to ${loc.label}...');
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) context.go('/drivers');
    });
  }

  void _handleSave() {
    if (_editingLocation != null) {
      setState(() {
        _locations = _locations.map((l) {
          if (l.id == _editingLocation!.id) {
            return l.copyWith(
              type: _dialogType,
              label: _labelController.text,
              address: _addressController.text,
              details: _detailsController.text.isEmpty
                  ? null
                  : _detailsController.text,
            );
          }
          return l;
        }).toList();
        _showDialog = false;
      });
      showToast(context, 'Location updated');
    } else {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      setState(() {
        _locations = [
          ..._locations,
          _SavedLocation(
            id: newId,
            type: _dialogType,
            label: _labelController.text,
            address: _addressController.text,
            details: _detailsController.text.isEmpty
                ? null
                : _detailsController.text,
          ),
        ];
        _showDialog = false;
      });
      showToast(context, 'Location added');
    }
  }

  IconData _iconFor(String type) {
    if (type == 'home') return Icons.home;
    if (type == 'work') return Icons.work;
    return Icons.star;
  }

  Color _colorFor(String type) {
    if (type == 'home') return AppColors.green;
    if (type == 'work') return AppColors.primary;
    return AppColors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Saved Locations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add button
                      SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _openAdd,
                              icon: const Icon(Icons.add),
                              label: const Text(
                                'Add New Location',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 24),

                      const Text(
                        'Your Locations',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (_locations.isEmpty)
                        _EmptyState(onAdd: _openAdd)
                      else
                        ...List.generate(_locations.length, (index) {
                          final loc = _locations[index];
                          final color = _colorFor(loc.type);
                          final icon = _iconFor(loc.type);
                          return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.06,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: color.withValues(
                                              alpha: 0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            icon,
                                            color: color,
                                            size: 24,
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
                                                ),
                                              ),
                                              Text(
                                                loc.address,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      AppColors.mutedForeground,
                                                ),
                                              ),
                                              if (loc.details != null)
                                                Text(
                                                  loc.details!,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors
                                                        .mutedForeground,
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
                                            height: 40,
                                            child: ElevatedButton.icon(
                                              onPressed: () => _handleBook(loc),
                                              icon: const Icon(
                                                Icons.place,
                                                size: 16,
                                              ),
                                              label: const Text('Book Ride'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        _ActionIconBtn(
                                          icon: Icons.edit_outlined,
                                          color: AppColors.mutedForeground,
                                          borderColor: AppColors.border,
                                          onTap: () => _openEdit(loc),
                                        ),
                                        const SizedBox(width: 8),
                                        _ActionIconBtn(
                                          icon: Icons.delete_outline,
                                          color: AppColors.red,
                                          borderColor: AppColors.red.withValues(
                                            alpha: 0.3,
                                          ),
                                          onTap: () => _handleDelete(loc.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                              .slideX(begin: -0.2, end: 0);
                        }),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Dialog overlay
          if (_showDialog)
            _LocationDialog(
              isEditing: _editingLocation != null,
              selectedType: _dialogType,
              labelController: _labelController,
              addressController: _addressController,
              detailsController: _detailsController,
              onTypeChanged: (t) => setState(() => _dialogType = t),
              onSave: _handleSave,
              onCancel: () => setState(() => _showDialog = false),
            ),
        ],
      ),
    );
  }
}

class _LocationDialog extends StatelessWidget {
  final bool isEditing;
  final String selectedType;
  final TextEditingController labelController;
  final TextEditingController addressController;
  final TextEditingController detailsController;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _LocationDialog({
    required this.isEditing,
    required this.selectedType,
    required this.labelController,
    required this.addressController,
    required this.detailsController,
    required this.onTypeChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Location' : 'Add New Location',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditing
                      ? 'Update the details of your saved location'
                      : 'Save a location for quick access',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 20),

                // Type selector
                const Text(
                  'Location Type',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _TypeBtn(
                      icon: Icons.home,
                      label: 'Home',
                      value: 'home',
                      selected: selectedType,
                      onTap: onTypeChanged,
                    ),
                    const SizedBox(width: 8),
                    _TypeBtn(
                      icon: Icons.work,
                      label: 'Work',
                      value: 'work',
                      selected: selectedType,
                      onTap: onTypeChanged,
                    ),
                    const SizedBox(width: 8),
                    _TypeBtn(
                      icon: Icons.star,
                      label: 'Favorite',
                      value: 'favorite',
                      selected: selectedType,
                      onTap: onTypeChanged,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _DialogField(
                  label: 'Label',
                  hint: 'e.g., Home, Office, Gym',
                  controller: labelController,
                ),
                const SizedBox(height: 12),
                _DialogField(
                  label: 'Address',
                  hint: 'Enter full address',
                  controller: addressController,
                ),
                const SizedBox(height: 12),
                _DialogField(
                  label: 'Additional Details (Optional)',
                  hint: 'e.g., Near landmark, Building name',
                  controller: detailsController,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(isEditing ? 'Update' : 'Add Location'),
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

class _TypeBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;

  const _TypeBtn({
    required this.icon,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.green : AppColors.border,
              width: 2,
            ),
            color: isSelected
                ? AppColors.green.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.green : AppColors.mutedForeground,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? AppColors.green
                      : AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const _DialogField({
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  const _ActionIconBtn({
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: color),
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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.muted,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.place,
                size: 40,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Saved Locations',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your frequently visited places\nfor faster booking',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.mutedForeground),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add Your First Location'),
            ),
          ],
        ),
      ),
    );
  }
}
