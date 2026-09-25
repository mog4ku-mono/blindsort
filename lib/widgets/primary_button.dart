import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// The single most important action on a screen. Sits at the bottom of a
/// details view or the top of a dashboard. A leading icon is optional; the
/// caller decides what the button does, the widget only renders it.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final onTap = isLoading ? null : onPressed;
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : (icon == null
              ? Text(label)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Text(label),
                  ],
                ));

    return Semantics(
      button: true,
      label: label,
      child: FilledButton(onPressed: onTap, child: child),
    );
  }
}
