import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// One row on the Settings screen. The trailing widget is where the parent
/// puts a Switch, a chevron, or nothing at all. The component does not know
/// what the setting means, only how to present it.
class SettingsItem extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.title,
    required this.icon,
    this.description,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: onTap != null,
      label: description == null ? title : '$title, $description',
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 22),
        ),
        title: Text(title, style: theme.textTheme.bodyMedium),
        subtitle: description == null
            ? null
            : Text(description!, style: theme.textTheme.labelSmall),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
