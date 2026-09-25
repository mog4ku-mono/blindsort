import 'package:flutter/material.dart';

import '../constants/file_type_colors.dart';
import '../models/file_item.dart';

/// One row in a file list. Stateless: the parent owns the list, the selection
/// state, and what onTap does.
class FileListItem extends StatelessWidget {
  final FileItem file;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isFavorite;
  final bool isSelected;

  const FileListItem({
    super.key,
    required this.file,
    required this.onTap,
    this.onLongPress,
    this.isFavorite = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teal = theme.colorScheme.secondary;
    return Semantics(
      button: true,
      selected: isSelected,
      label:
          '${file.name}, ${file.type}, '
          '${file.sizeMb} megabytes${isFavorite ? ", favorited" : ""}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          splashColor: teal.withValues(alpha: 0.18),
          highlightColor: teal.withValues(alpha: 0.12),
          hoverColor: teal.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: isSelected
                  ? teal.withValues(alpha: 0.10)
                  : Colors.transparent,
              border: Border(
                right: BorderSide(
                  color: isSelected ? teal : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: ListTile(
              leading: _typeBadge(),
              title: Text(file.name, style: theme.textTheme.bodyMedium),
              subtitle: Text(
                '${file.sizeMb} MB · ${_relativeDate(file.modifiedAt)}',
                style: theme.textTheme.labelSmall,
              ),
              trailing: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: isFavorite
                    ? const Icon(
                        Icons.star,
                        key: ValueKey('star'),
                        color: Color(0xFF26A69A),
                      )
                    : const SizedBox.shrink(key: ValueKey('none')),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeBadge() {
    final color = kFileTypeColors[file.type] ?? kDefaultTypeColor;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        file.type,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _relativeDate(DateTime dt) {
    final days = DateTime.now().difference(dt).inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '$days days ago';
  }
}
