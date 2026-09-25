import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// A label/value pair on the File Details screen. Kept as a row rather than
/// loose text so TalkBack reads the pair as a single unit ("Location,
/// Internal Storage > Documents").
class MetadataRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const MetadataRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$label, $value',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
            ],
            SizedBox(
              width: 96,
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
