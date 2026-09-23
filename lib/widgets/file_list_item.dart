import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../models/file_item.dart';

/// One row in a file list. Stateless: the parent owns the list and decides
/// what onTap does. Reused on the Home Dashboard and the File Browser.
class FileListItem extends StatelessWidget {
  final FileItem file;
  final VoidCallback onTap;

  const FileListItem({super.key, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label:
          '${file.name}, ${file.type}, '
          '${file.sizeMb} megabytes, opened ${_relativeDate(file.modifiedAt)}',
      child: ListTile(
        leading: _typeBadge(theme),
        title: Text(file.name, style: theme.textTheme.bodyMedium),
        subtitle: Text(
          '${file.sizeMb} MB · ${_relativeDate(file.modifiedAt)}',
          style: theme.textTheme.labelSmall,
        ),
        trailing: file.isFavorite
            ? Icon(Icons.star, color: theme.colorScheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }

  /// Type badge: a small colored box carrying the file extension. Gives
  /// TalkBack a stable, spoken word for the file type without relying on
  /// color alone.
  Widget _typeBadge(ThemeData theme) => Container(
    width: 40,
    height: 40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      file.type,
      style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  /// "Today", "Yesterday", or "N days ago". Kept simple on purpose; the
  /// File Details screen has the full timestamp.
  String _relativeDate(DateTime dt) {
    final days = DateTime.now().difference(dt).inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '$days days ago';
  }
}
