import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/category_colors.dart';
import '../data/sample_files.dart';
import '../data/sample_folders.dart';
import '../widgets/category_navigation_item.dart';
import '../widgets/file_list_item.dart';
import '../widgets/folder_list_item.dart';

/// File Browser. Categories and folders over a list of files. Voice Search
/// lives here as an icon in the app bar; tapping it opens the same list
/// filtered once speech wiring lands.
class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({super.key});

  @override
  State<FileBrowserScreen> createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  int _tabIndex = 0; // 0 = Categories, 1 = Folders

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
                _categoryRow(),
                const SizedBox(height: AppSpacing.md),
                _filesAndFoldersHeader(theme),
                const SizedBox(height: AppSpacing.sm),
                _folderGroup(),
                const SizedBox(height: AppSpacing.sm),
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
                : theme.colorScheme.onSurface,
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
          tintColor: kDocumentsColors.tint,
          foregroundColor: kDocumentsColors.foreground,
          itemCount: 126,
          onTap: _noop,
        ),
        CategoryNavigationItem(
          categoryName: 'Images',
          icon: Icons.image_outlined,
          tintColor: kImagesColors.tint,
          foregroundColor: kImagesColors.foreground,
          itemCount: 84,
          onTap: _noop,
        ),
        CategoryNavigationItem(
          categoryName: 'Videos',
          icon: Icons.video_library_outlined,
          tintColor: kVideosColors.tint,
          foregroundColor: kVideosColors.foreground,
          itemCount: 52,
          onTap: _noop,
        ),
        CategoryNavigationItem(
          categoryName: 'Audio',
          icon: Icons.music_note_outlined,
          tintColor: kAudioColors.tint,
          foregroundColor: kAudioColors.foreground,
          itemCount: 98,
          onTap: _noop,
        ),
        CategoryNavigationItem(
          categoryName: 'More',
          icon: Icons.more_horiz,
          tintColor: theme.colorScheme.surfaceContainerHighest,
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          onTap: _noop,
        ),
      ],
    );
  }

  Widget _filesAndFoldersHeader(ThemeData theme) => Row(
    children: [
      Text(
        'Files & Folders',
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
      const Spacer(),
      Row(
        children: [
          Text('Sorted by recent', style: theme.textTheme.labelSmall),
          const Icon(Icons.expand_more, size: 18),
        ],
      ),
    ],
  );

  Widget _folderGroup() {
    final theme = Theme.of(context);
    return Container(
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
  }

  Widget _fileGroup(ThemeData theme) => Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: theme.colorScheme.outlineVariant),
    ),
    child: Column(
      children: [
        for (var i = 0; i < sampleFiles.length; i++) ...[
          FileListItem(file: sampleFiles[i], onTap: () {}),
          if (i < sampleFiles.length - 1)
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

  Widget _bottomBar(ThemeData theme) => Container(
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    child: Row(
      children: [
        Icon(Icons.home_outlined, color: theme.colorScheme.secondary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'Home',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          'Filter & Sort',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Icon(Icons.grid_view, color: theme.colorScheme.secondary),
      ],
    ),
  );
}

void _noop() {}
