import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// A single category tile on the Home Dashboard and the File Browser. The
/// item count is optional: when the parent has no count yet, only the icon
/// and label are shown. Colour is never the only signal — the icon and the
/// label carry the meaning, the tile just reinforces it.
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
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
