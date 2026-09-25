import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/category_colors.dart';
import '../constants/file_type_colors.dart';
import '../data/sample_files.dart';
import '../data/sample_folders.dart';
import '../widgets/category_navigation_item.dart';
import '../widgets/file_list_item.dart';
import '../widgets/folder_list_item.dart';

enum SortMode { recent, name, size }

/// File Browser. Categories tab shows tiles, folders, and files; Folders tab
/// shows only folders. Category tiles filter the file list; tapping a folder
/// narrows to that folder's files.
class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({super.key});

  @override
  State<FileBrowserScreen> createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  int _tabIndex = 0;
  String? _categoryFilter;
  String? _folderFilter;
  String? _selectedFileId;
  SortMode _sort = SortMode.recent;

  List get _visibleFiles {
    var list = sampleFiles;

    if (_categoryFilter == 'Favorites') {
      list = list.where((f) => f.isFavorite).toList();
    } else if (_categoryFilter == 'Downloads') {
      list = list.where((f) => f.location.contains('Download')).toList();
    } else if (_categoryFilter != null) {
      list = list
          .where((f) => kFileTypeCategory[f.type] == _categoryFilter)
          .toList();
    }

    if (_folderFilter != null) {
      list = list.where((f) => f.location.contains(_folderFilter!)).toList();
    }

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

  int _countFor(String category) =>
      sampleFiles.where((f) => kFileTypeCategory[f.type] == category).length;

  String get _breadcrumbText {
    if (_folderFilter != null) {
      return 'Internal Storage  ›  Documents  ›  $_folderFilter';
    }
    return 'Internal Storage  ›  Documents';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.secondaryContainer.withValues(alpha: 0.22),
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            const Divider(height: 1),
            _breadcrumb(theme),
            const Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: _tabs(theme),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _tabBody(theme),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(theme),
    );
  }

  Widget _tabBody(ThemeData theme) {
    if (_tabIndex == 1) {
      return ListView(
        key: const ValueKey('folders'),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _sectionLabel(theme, 'Folders'),
          const SizedBox(height: AppSpacing.sm),
          _folderGroup(theme),
        ],
      );
    }

    return ListView(
      key: const ValueKey('categories'),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _categoryRow(),
        const SizedBox(height: AppSpacing.md),
        if (_categoryFilter != null || _folderFilter != null) ...[
          _activeFiltersRow(theme),
          const SizedBox(height: AppSpacing.sm),
        ],
        _filesAndFoldersHeader(theme),
        const SizedBox(height: AppSpacing.sm),
        if (_folderFilter == null) ...[
          _folderGroup(theme),
          const SizedBox(height: AppSpacing.sm),
        ],
        _fileGroup(theme),
      ],
    );
  }

  Widget _sectionLabel(ThemeData theme, String text) => Text(
    text,
    style: theme.textTheme.headlineSmall?.copyWith(
      color: theme.colorScheme.secondary,
    ),
  );

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
            Expanded(
              child: Text(
                _breadcrumbText,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: active ? theme.colorScheme.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 280),
            style: theme.textTheme.bodyMedium!.copyWith(
              color: active
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text(label, textAlign: TextAlign.center),
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
        _categoryTile(
          'Documents',
          Icons.description_outlined,
          kDocumentsColors,
          theme,
        ),
        _categoryTile('Images', Icons.image_outlined, kImagesColors, theme),
        _categoryTile(
          'Videos',
          Icons.video_library_outlined,
          kVideosColors,
          theme,
        ),
        _categoryTile('Audio', Icons.music_note_outlined, kAudioColors, theme),
        CategoryNavigationItem(
          categoryName: 'More',
          icon: Icons.more_horiz,
          tintColor: theme.colorScheme.surfaceContainerHighest,
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          onTap: () => _showMoreCategories(theme),
        ),
      ],
    );
  }

  Widget _categoryTile(
    String label,
    IconData icon,
    CategoryColorPair colors,
    ThemeData theme,
  ) {
    final selected = _categoryFilter == label;
    return CategoryNavigationItem(
      categoryName: label,
      icon: icon,
      tintColor: selected ? colors.foreground : colors.tint,
      foregroundColor: selected ? Colors.white : colors.foreground,
      itemCount: _countFor(label),
      onTap: () => _toggleFilter(label),
    );
  }

  void _toggleFilter(String category) {
    setState(() {
      _categoryFilter = _categoryFilter == category ? null : category;
    });
  }

  void _showMoreCategories(ThemeData theme) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All categories', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _moreChip(theme, 'Favorites', Icons.star_border),
                _moreChip(theme, 'Apps', Icons.android_outlined),
                _moreChip(theme, 'Archives', Icons.folder_zip_outlined),
                _moreChip(theme, 'Downloads', Icons.download_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _moreChip(ThemeData theme, String label, IconData icon) {
    final selected = _categoryFilter == label;
    return ActionChip(
      avatar: Icon(
        icon,
        size: 18,
        color: selected
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.secondary,
      ),
      label: Text(label),
      backgroundColor: selected
          ? theme.colorScheme.secondary
          : theme.colorScheme.surface,
      labelStyle: TextStyle(
        color: selected
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.onSurface,
      ),
      onPressed: () {
        Navigator.pop(context);
        setState(() => _categoryFilter = selected ? null : label);
      },
    );
  }

  Widget _activeFiltersRow(ThemeData theme) => Wrap(
    spacing: AppSpacing.sm,
    runSpacing: AppSpacing.xs,
    children: [
      if (_categoryFilter != null)
        Chip(
          label: Text('Showing: $_categoryFilter'),
          onDeleted: () => setState(() => _categoryFilter = null),
          deleteIcon: const Icon(Icons.close, size: 16),
        ),
      if (_folderFilter != null)
        Chip(
          label: Text('Folder: $_folderFilter'),
          onDeleted: () => setState(() => _folderFilter = null),
          deleteIcon: const Icon(Icons.close, size: 16),
        ),
    ],
  );

  Widget _filesAndFoldersHeader(ThemeData theme) => Row(
    children: [
      Text(
        _folderFilter == null ? 'Files & Folders' : 'Files',
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
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        for (var i = 0; i < sampleFolders.length; i++) ...[
          FolderListItem(
            folder: sampleFolders[i],
            onTap: () => setState(() {
              final name = sampleFolders[i].name;
              _folderFilter = _folderFilter == name ? null : name;
            }),
          ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < files.length; i++) ...[
            FileListItem(
              file: files[i],
              isSelected: _selectedFileId == files[i].id,
              onTap: () => setState(() {
                _selectedFileId = _selectedFileId == files[i].id
                    ? null
                    : files[i].id;
              }),
            ),
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
            onTap: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (_) => _filterSortSheet(theme),
            ),
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
        Text('Filter', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _filterChip(theme, 'Favorites', Icons.star_border),
            _filterChip(theme, 'Documents', Icons.description_outlined),
            _filterChip(theme, 'Images', Icons.image_outlined),
            _filterChip(theme, 'Videos', Icons.video_library_outlined),
            _filterChip(theme, 'Audio', Icons.music_note_outlined),
            _filterChip(theme, 'Downloads', Icons.download_outlined),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Sort by', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
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
                RadioListTile<SortMode>(
                  title: Text(mode.name),
                  value: mode,
                  dense: true,
                ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _filterChip(ThemeData theme, String label, IconData icon) {
    final selected = _categoryFilter == label;
    return FilterChip(
      avatar: Icon(
        icon,
        size: 18,
        color: selected
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.secondary,
      ),
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        Navigator.pop(context);
        setState(() => _categoryFilter = selected ? null : label);
      },
      selectedColor: theme.colorScheme.secondary,
      checkmarkColor: theme.colorScheme.onSecondary,
      labelStyle: TextStyle(
        color: selected
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.onSurface,
      ),
    );
  }
}
