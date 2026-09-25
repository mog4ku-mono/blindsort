import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme.dart';

/// One row on the Settings screen. Filled teal circle with a white icon,
/// matching the mockup. An outlined variant is available when the row is
/// destructive or a reset action.
class SettingsItem extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool outlined;

  const SettingsItem({
    super.key,
    required this.title,
    required this.icon,
    this.description,
    this.trailing,
    this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: onTap != null,
      label: description == null ? title : '$title, $description',
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        elevation: 1,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          leading: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: outlined ? Colors.white : kSecondaryTeal,
              shape: BoxShape.circle,
              border: outlined
                  ? Border.all(color: kSecondaryTeal, width: 2)
                  : null,
            ),
            child: Icon(
              icon,
              color: outlined ? kSecondaryTeal : Colors.white,
              size: 22,
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: description == null
              ? null
              : Text(description!, style: theme.textTheme.labelSmall),
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
