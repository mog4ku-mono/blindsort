import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/file_type_colors.dart';
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
        leading: _typeBadge(),
        title: Text(file.name, style: theme.textTheme.bodyMedium),
        subtitle: Text(
          '${file.sizeMb} MB · ${_relativeDate(file.modifiedAt)}',
          style: theme.textTheme.labelSmall,
        ),
        trailing: file.isFavorite
            ? const Icon(Icons.star, color: Color(0xFF26A69A))
            : null,
        onTap: onTap,
      ),
    );
  }

  /// Colored badge per extension so a low-vision user can tell types apart
  /// without reading. Falls back to a neutral slate for unknown extensions.
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
