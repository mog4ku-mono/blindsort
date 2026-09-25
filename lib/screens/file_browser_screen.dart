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

/// File Browser. Categories tab shows tiles, folders, and files; Folders tab
/// shows only the folder list. Category tiles filter the file list by broad
/// type. Voice Search and Filter & Sort live in the app bar and bottom bar.
class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({super.key});

  @override
  State<FileBrowserScreen> createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  int _tabIndex = 0; // 0 = Categories, 1 = Folders
  String? _categoryFilter;
  SortMode _sort = SortMode.recent;
  bool _entered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _entered = true);
    });
  }

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

  int _countFor(String category) =>
      sampleFiles.where((f) => kFileTypeCategory[f.type] == category).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: false,
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
              theme.colorScheme.secondaryContainer.withValues(alpha: 0.20),
              theme.colorScheme.surface,
            ],
            stops: const [0.0, 0.25],
          ),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          opacity: _entered ? 1.0 : 0.0,
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
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
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
        if (_categoryFilter != null) ...[
          _activeFilterChip(theme),
          const SizedBox(height: AppSpacing.sm),
        ],
        _filesAndFoldersHeader(theme),
        const SizedBox(height: AppSpacing.sm),
        _folderGroup(theme),
        const SizedBox(height: AppSpacing.sm),
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
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
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
          itemCount: _countFor('Documents'),
          onTap: () => _toggleFilter('Documents'),
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
          itemCount: _countFor('Images'),
          onTap: () => _toggleFilter('Images'),
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
          itemCount: _countFor('Videos'),
          onTap: () => _toggleFilter('Videos'),
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
          itemCount: _countFor('Audio'),
          onTap: () => _toggleFilter('Audio'),
        ),
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
                _moreChip(theme, 'Apps', Icons.android_outlined),
                _moreChip(theme, 'Archives', Icons.folder_zip_outlined),
                _moreChip(theme, 'Downloads', Icons.download_outlined),
                _moreChip(theme, 'Favorites', Icons.star_border),
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
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
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
