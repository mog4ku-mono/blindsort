import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../data/sample_files.dart';
import '../models/file_item.dart';
import '../widgets/category_navigation_item.dart';
import '../widgets/file_list_item.dart';
import '../widgets/section_card.dart';

/// Home Dashboard. Entry point of the four-screen journey: a voice search
/// hero, recent files, favorites, a category grid, and a shortcut into the
/// full file browser.
///
/// The category counts are static demo values for now. They come from the
/// mockup, not from the six-file sample dataset, so the grid reads the way
/// the screen was designed. Real counts arrive when device file access does.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<FileItem> _allFiles = sampleFiles;

  List<FileItem> get _recent => _allFiles.take(3).toList();

  List<FileItem> get _favorites =>
      _allFiles.where((f) => f.isFavorite).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BlindSort',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              'Home',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
          tooltip: 'Menu',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Your command center. Continue your work.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          const _VoiceSearchCard(),
          const SizedBox(height: AppSpacing.md),
          _recentSection(theme),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Showing up to 3 recent files',
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          _favoritesSection(theme),
          const SizedBox(height: AppSpacing.sm),
          _categoriesSection(theme),
          const SizedBox(height: AppSpacing.md),
          _browseAllCard(theme),
          const SizedBox(height: AppSpacing.sm),
          _tipCard(theme),
        ],
      ),
    );
  }

  Widget _recentSection(ThemeData theme) => SectionCard(
    title: 'Recent Files',
    trailing: TextButton(onPressed: () {}, child: const Text('View all')),
    child: Column(
      children: [for (final f in _recent) FileListItem(file: f, onTap: () {})],
    ),
  );

  Widget _favoritesSection(ThemeData theme) => SectionCard(
    title: 'Favorites',
    trailing: TextButton(onPressed: () {}, child: const Text('View all')),
    child: _favorites.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text('No favorites yet.'),
          )
        : Column(
            children: [
              for (final f in _favorites) FileListItem(file: f, onTap: () {}),
            ],
          ),
  );

  Widget _categoriesSection(ThemeData theme) => SectionCard(
    title: 'Categories',
    trailing: TextButton(
      onPressed: () {},
      child: const Text('More categories →'),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CategoryNavigationItem(
              categoryName: 'Documents',
              icon: Icons.description_outlined,
              itemCount: 126,
              onTap: _noop,
            ),
            CategoryNavigationItem(
              categoryName: 'Images',
              icon: Icons.image_outlined,
              itemCount: 84,
              onTap: _noop,
            ),
            CategoryNavigationItem(
              categoryName: 'Videos',
              icon: Icons.video_library_outlined,
              itemCount: 52,
              onTap: _noop,
            ),
            CategoryNavigationItem(
              categoryName: 'Audio',
              icon: Icons.music_note_outlined,
              itemCount: 98,
              onTap: _noop,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Tap a category to browse filtered files.',
          style: theme.textTheme.labelSmall,
        ),
      ],
    ),
  );

  Widget _browseAllCard(ThemeData theme) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.folder_outlined,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text('Browse All Files', style: theme.textTheme.bodyMedium),
      subtitle: Text(
        'View all files in your device',
        style: theme.textTheme.labelSmall,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    ),
  );

  Widget _tipCard(ThemeData theme) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip: You can always say what you need.',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Example: \"Find my math notes from last week\"",
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Voice Search hero card. The button itself does not run speech yet; the
/// search flow lands on the File Browser and speech integration is attempted
/// after that flow is stable, per the revised proposal.
class _VoiceSearchCard extends StatelessWidget {
  const _VoiceSearchCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: 'Voice Search. Tap to speak and find files.',
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSecondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic,
                  size: 32,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Voice Search',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              Text(
                'Tap to speak and find files',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _noop() {}
