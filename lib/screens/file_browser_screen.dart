import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/category_colors.dart';
import '../constants/file_type_colors.dart';
import '../data/sample_files.dart';
import '../data/sample_folders.dart';
import '../widgets/category_navigation_item.dart';
import '../widgets/file_list_item.dart';
import '../widgets/folder_list_item.dart';

/// Sort options offered by the "Sorted by ..." dropdown.
enum SortMode { recent, name, size }

/// File Browser. Category tiles filter the file list by broad type, the
/// Files & Folders header lets the user switch sort order, and the bottom
/// bar carries Home and Filter & Sort. Tapping a row will route to File
/// Details once that screen lands.
class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({super.key});

  @override
  State<FileBrowserScreen> createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  int _tabIndex = 0; // 0 = Categories, 1 = Folders
  String? _categoryFilter; // null = all types
  SortMode _sort = SortMode.recent;

  List get _visibleFiles {
    final list = sampleFiles
        .where(
          (f) =>
              _categoryFilter == null ||
              kFileTypeCategory[f.type] == _categoryFilter,
        )
        .toList();

    switch (_sort) {
      case SortMode.recent:
        list.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
      case SortMode.name:
        list.sort((a, b) => a.name.compareTo(b.name));
      case SortMode.size:
        list.sort((a, b) => b.sizeMb.compareTo(a.sizeMb));
    }
    return list;
  }

  String get _sortLabel {
    switch (_sort) {
      case SortMode.recent:
        return 'Sorted by recent';
      case SortMode.name:
        return 'Sorted by name';
      case SortMode.size:
        return 'Sorted by size';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          'File Browser',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.mic_none),
            onPressed: () {},
            tooltip: 'Voice search',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            tooltip: 'More',
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          _breadcrumb(theme),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _tabs(theme),
                const SizedBox(height: AppSpacing.md),
                if (_tabIndex == 0) _categoryRow(),
                if (_tabIndex == 0) const SizedBox(height: AppSpacing.md),
                if (_categoryFilter != null) _activeFilterChip(theme),
                if (_categoryFilter != null)
                  const SizedBox(height: AppSpacing.sm),
                _filesAndFoldersHeader(theme),
                const SizedBox(height: AppSpacing.sm),
                if (_tabIndex == 0) _folderGroup(theme),
                if (_tabIndex == 0) const SizedBox(height: AppSpacing.sm),
                _fileGroup(theme),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(theme),
    );
  }

  Widget _breadcrumb(ThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current location',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(
              Icons.folder_outlined,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Internal Storage  ›  Documents',
              style: theme.textTheme.bodyMedium,
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ],
    ),
  );

  Widget _tabs(ThemeData theme) => Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(4),
    child: Row(
      children: [
        Expanded(child: _tabButton('Categories', 0, theme)),
        Expanded(child: _tabButton('Folders', 1, theme)),
      ],
    ),
  );

  Widget _tabButton(String label, int index, ThemeData theme) {
    final active = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: active ? theme.colorScheme.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: active
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _categoryRow() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryNavigationItem(
          categoryName: 'Documents',
          icon: Icons.description_outlined,
          tintColor: _categoryFilter == 'Documents'
              ? kDocumentsColors.foreground
              : kDocumentsColors.tint,
          foregroundColor: _categoryFilter == 'Documents'
              ? Colors.white
              : kDocumentsColors.foreground,
          itemCount: sampleFiles
              .where((f) => kFileTypeCategory[f.type] == 'Documents')
              .length,
          onTap: () => setState(
            () => _categoryFilter = _categoryFilter == 'Documents'
                ? null
                : 'Documents',
          ),
        ),
        CategoryNavigationItem(
          categoryName: 'Images',
          icon: Icons.image_outlined,
          tintColor: _categoryFilter == 'Images'
              ? kImagesColors.foreground
              : kImagesColors.tint,
          foregroundColor: _categoryFilter == 'Images'
              ? Colors.white
              : kImagesColors.foreground,
          itemCount: sampleFiles
              .where((f) => kFileTypeCategory[f.type] == 'Images')
              .length,
          onTap: () => setState(
            () =>
                _categoryFilter = _categoryFilter == 'Images' ? null : 'Images',
          ),
        ),
        CategoryNavigationItem(
          categoryName: 'Videos',
          icon: Icons.video_library_outlined,
          tintColor: _categoryFilter == 'Videos'
              ? kVideosColors.foreground
              : kVideosColors.tint,
          foregroundColor: _categoryFilter == 'Videos'
              ? Colors.white
              : kVideosColors.foreground,
          itemCount: sampleFiles
              .where((f) => kFileTypeCategory[f.type] == 'Videos')
              .length,
          onTap: () => setState(
            () =>
                _categoryFilter = _categoryFilter == 'Videos' ? null : 'Videos',
          ),
        ),
        CategoryNavigationItem(
          categoryName: 'Audio',
          icon: Icons.music_note_outlined,
          tintColor: _categoryFilter == 'Audio'
              ? kAudioColors.foreground
              : kAudioColors.tint,
          foregroundColor: _categoryFilter == 'Audio'
              ? Colors.white
              : kAudioColors.foreground,
          itemCount: sampleFiles
              .where((f) => kFileTypeCategory[f.type] == 'Audio')
              .length,
          onTap: () => setState(
            () => _categoryFilter = _categoryFilter == 'Audio' ? null : 'Audio',
          ),
        ),
        CategoryNavigationItem(
          categoryName: 'More',
          icon: Icons.more_horiz,
          tintColor: theme.colorScheme.surfaceContainerHighest,
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _activeFilterChip(ThemeData theme) => Row(
    children: [
      Chip(
        label: Text('Showing: $_categoryFilter'),
        onDeleted: () => setState(() => _categoryFilter = null),
        deleteIcon: const Icon(Icons.close, size: 16),
      ),
    ],
  );

  Widget _filesAndFoldersHeader(ThemeData theme) => Row(
    children: [
      Text(
        'Files & Folders',
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
      const Spacer(),
      PopupMenuButton<SortMode>(
        initialValue: _sort,
        onSelected: (v) => setState(() => _sort = v),
        child: Row(
          children: [
            Text(_sortLabel, style: theme.textTheme.labelSmall),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
        itemBuilder: (context) => const [
          PopupMenuItem(value: SortMode.recent, child: Text('Recent')),
          PopupMenuItem(value: SortMode.name, child: Text('Name')),
          PopupMenuItem(value: SortMode.size, child: Text('Size')),
        ],
      ),
    ],
  );

  Widget _folderGroup(ThemeData theme) => Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: theme.colorScheme.outlineVariant),
    ),
    child: Column(
      children: [
        for (var i = 0; i < sampleFolders.length; i++) ...[
          FolderListItem(folder: sampleFolders[i], onTap: () {}),
          if (i < sampleFolders.length - 1)
            Divider(
              height: 1,
              indent: AppSpacing.md,
              endIndent: AppSpacing.md,
              color: theme.colorScheme.outlineVariant,
            ),
        ],
      ],
    ),
  );

  Widget _fileGroup(ThemeData theme) {
    final files = _visibleFiles;
    if (files.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'No files match this filter.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            for (var i = 0; i < files.length; i++) ...[
              FileListItem(file: files[i], onTap: () {}),
              if (i < files.length - 1)
                Divider(
                  height: 1,
                  indent: AppSpacing.md,
                  endIndent: AppSpacing.md,
                  color: theme.colorScheme.outlineVariant,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _bottomBar(ThemeData theme) => Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs,
    ),
    child: Row(
      children: [
        Expanded(
          child: _bottomBarButton(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () {},
            theme: theme,
          ),
        ),
        Expanded(
          child: _bottomBarButton(
            icon: Icons.grid_view,
            label: 'Filter & Sort',
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (_) => _filterSortSheet(theme),
              );
            },
            theme: theme,
            iconAfterLabel: true,
          ),
        ),
      ],
    ),
  );

  Widget _bottomBarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
    bool iconAfterLabel = false,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: iconAfterLabel
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!iconAfterLabel) ...[
                Icon(icon, color: theme.colorScheme.secondary, size: 22),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (iconAfterLabel) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(icon, color: theme.colorScheme.secondary, size: 22),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterSortSheet(ThemeData theme) => Padding(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sort by', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        RadioGroup<SortMode>(
          groupValue: _sort,
          onChanged: (v) {
            if (v != null) {
              setState(() => _sort = v);
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode in SortMode.values)
                RadioListTile<SortMode>(title: Text(mode.name), value: mode),
            ],
          ),
        ),
      ],
    ),
  );
}
