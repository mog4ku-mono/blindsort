import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// A category tile on Home and the File Browser. Outlined so the icon and
/// label carry the meaning, not the fill colour. The item count is optional.
class CategoryNavigationItem extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  final int? itemCount;
  final VoidCallback onTap;

  const CategoryNavigationItem({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.onTap,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: itemCount == null
          ? categoryName
          : '$categoryName, $itemCount items',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: theme.colorScheme.secondary, size: 22),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                categoryName,
                style: theme.textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
              if (itemCount != null)
                Text(
                  '($itemCount)',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
