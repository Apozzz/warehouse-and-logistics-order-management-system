import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:inventory_system/features/role/models/role_model.dart';

class PermissionMultiSelect extends StatelessWidget {
  final List<Permission> initialValue;
  final ValueChanged<List<Permission>> onSelectionChanged;
  final Color? chipColor;
  final Color? chipTextColor;

  const PermissionMultiSelect({
    Key? key,
    required this.initialValue,
    required this.onSelectionChanged,
    this.chipColor,
    this.chipTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        chipTheme: ChipThemeData(
          backgroundColor: chipColor ?? Theme.of(context).primaryColor,
          labelStyle: TextStyle(
            color: chipTextColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
          disabledColor: chipColor ?? Theme.of(context).primaryColor,
          selectedColor: chipColor?.withOpacity(0.5) ??
              Theme.of(context).primaryColor.withOpacity(0.5),
          secondarySelectedColor: chipColor?.withOpacity(0.5) ??
              Theme.of(context).primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      child: MultiSelectDialogField<Permission>(
        items: Permission.values
            .map((permission) =>
                MultiSelectItem(permission, permission.toString()))
            .toList(),
        initialValue: initialValue,
        onConfirm: onSelectionChanged,
        listType: MultiSelectListType.CHIP,
        searchable: true,
      ),
    );
  }
}
