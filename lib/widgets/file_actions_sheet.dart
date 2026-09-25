import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../data/sample_folders.dart';
import '../models/file_item.dart';
import '../models/folder_item.dart';
import '../state/app_state.dart';

Future<void> showFileActions(
  BuildContext context,
  FileItem file, {
  required VoidCallback onChanged,
}) async {
  final theme = Theme.of(context);
  final allFolders = [
    ...sampleFolders.where((f) => !AppState.isFolderDeleted(f.name)),
    ...AppState.customFolders.where((f) => !AppState.isFolderDeleted(f.name)),
  ];
  final containing = allFolders
      .where((f) => (AppState.folderContents[f.name] ?? {}).contains(file.id))
      .toList();

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              file.name,
              style: theme.textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ListTile(
            leading: Icon(
              AppState.isFavorite(file.id) ? Icons.star : Icons.star_border,
              color: theme.colorScheme.secondary,
            ),
            title: Text(
              AppState.isFavorite(file.id)
                  ? 'Remove from Favorites'
                  : 'Add to Favorites',
            ),
            onTap: () {
              AppState.toggleFavorite(file.id);
              Navigator.pop(sheetContext);
              onChanged();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.create_new_folder_outlined,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Add to folder...'),
            onTap: () {
              Navigator.pop(sheetContext);
              _showFolderPicker(context, file, allFolders, onChanged);
            },
          ),
          for (final folder in containing)
            ListTile(
              leading: Icon(
                Icons.remove_circle_outline,
                color: theme.colorScheme.error,
              ),
              title: Text('Remove from ${folder.name}'),
              onTap: () {
                AppState.folderContents[folder.name]?.remove(file.id);
                Navigator.pop(sheetContext);
                onChanged();
              },
            ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            title: Text(
              'Delete file',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete file?'),
                  content: Text('"${file.name}" will be removed.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                AppState.deleteFile(file.id);
                if (sheetContext.mounted) Navigator.pop(sheetContext);
                onChanged();
              }
            },
          ),
        ],
      ),
    ),
  );
}

Future<void> _showFolderPicker(
  BuildContext context,
  FileItem file,
  List<FolderItem> allFolders,
  VoidCallback onChanged,
) async {
  final theme = Theme.of(context);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              'Add to which folder?',
              style: theme.textTheme.headlineSmall,
            ),
          ),
          for (final folder in allFolders)
            ListTile(
              leading: Icon(Icons.folder, color: theme.colorScheme.secondary),
              title: Text(folder.name),
              onTap: () {
                AppState.addFileToFolder(folder.name, file.id);
                Navigator.pop(sheetContext);
                onChanged();
              },
            ),
        ],
      ),
    ),
  );
}
