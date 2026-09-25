import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../models/file_item.dart';
import '../state/app_state.dart';

/// Shared file long-press sheet. Favorites, Add to folder, and one
/// Remove-from row per custom folder the file currently lives in.
Future<void> showFileActions(
  BuildContext context,
  FileItem file, {
  required VoidCallback onChanged,
}) async {
  final theme = Theme.of(context);
  final containing = AppState.customFolders
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
            enabled: AppState.customFolders.isNotEmpty,
            subtitle: AppState.customFolders.isEmpty
                ? const Text('Create a folder first from the Folders tab')
                : null,
            onTap: AppState.customFolders.isEmpty
                ? null
                : () {
                    Navigator.pop(sheetContext);
                    showFolderPicker(context, file, onChanged: onChanged);
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
        ],
      ),
    ),
  );
}

/// Picks which custom folder to add a file to.
Future<void> showFolderPicker(
  BuildContext context,
  FileItem file, {
  required VoidCallback onChanged,
}) async {
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
          for (final folder in AppState.customFolders)
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
