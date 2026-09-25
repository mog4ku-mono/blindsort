import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// A category tile on Home and the File Browser. Takes an explicit tint and
/// foreground so each tile can carry its own colour: Documents blue, Images
/// green, Videos purple, Audio orange.
///
/// The label area has a fixed height so tiles stay equal-sized no matter how
/// many lines a name needs.
class CategoryNavigationItem extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  final Color tintColor;
  final Color foregroundColor;
  final int? itemCount;
  final VoidCallback onTap;

  const CategoryNavigationItem({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.tintColor,
    required this.foregroundColor,
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
            horizontal: 4,
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
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tintColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: foregroundColor, size: 20),
              ),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    categoryName,
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 11),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (itemCount != null)
                Text(
                  '($itemCount)',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10,
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
