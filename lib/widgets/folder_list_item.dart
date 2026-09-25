import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../models/folder_item.dart';
import '../theme.dart';

/// A folder row in the File Browser. Dark teal fill so a folder reads
/// differently from a category tile, which uses a lighter background.
class FolderListItem extends StatelessWidget {
  final FolderItem folder;
  final VoidCallback onTap;

  const FolderListItem({super.key, required this.folder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = DateTime.now().difference(folder.modifiedAt).inDays;
    final rel = days <= 0
        ? 'Today'
        : days == 1
        ? 'Yesterday'
        : '$days days ago';

    return Semantics(
      button: true,
      label: '${folder.name}, folder, ${folder.itemCount} items, $rel',
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kFolderTeal,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.folder, color: Colors.white, size: 22),
        ),
        title: Text(folder.name, style: theme.textTheme.bodyMedium),
        subtitle: Text(
          'Folder · ${folder.itemCount} items · $rel',
          style: theme.textTheme.labelSmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
