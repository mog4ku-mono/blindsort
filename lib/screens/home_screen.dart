import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/category_colors.dart';
import '../data/sample_files.dart';
import '../models/file_item.dart';
import '../state/app_state.dart';
import '../widgets/category_navigation_item.dart';
import '../widgets/file_list_item.dart';
import '../widgets/section_card.dart';
import 'file_browser_screen.dart';

/// Home Dashboard. Entry point of the four-screen journey. Category tiles,
/// View all links, and Browse All Files route to the File Browser; the gear
/// opens Settings; long-pressing a file toggles its favorite state.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<FileItem> _allFiles = sampleFiles;
  String? _selectedFileId;
  bool _entered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _entered = true);
    });
  }

  List<FileItem> get _recent => _allFiles.take(3).toList();

  List<FileItem> get _favorites =>
      _allFiles.where((f) => AppState.isFavorite(f.id)).toList();

  void _toggleFavorite(String id) {
    setState(() => AppState.toggleFavorite(id));
  }

  void _openBrowser({String? category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FileBrowserScreen(initialCategory: category),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  int _countFor(String category) {
    if (category == 'Favorites') {
      return _allFiles.where((f) => AppState.isFavorite(f.id)).length;
    }
    return _allFiles
        .where((f) => f.type.contains(category.substring(0, 3)))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
          tooltip: 'Menu',
        ),
        title: Column(
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
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  iconSize: 20,
                  icon: Icon(
                    Icons.settings,
                    color: theme.colorScheme.secondary,
                  ),
                  onPressed: () {},
                  tooltip: 'Settings',
                ),
              ),
            ),
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
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                opacity: _entered ? 1.0 : 0.0,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    Text(
                      'Your command center. Continue your work.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _VoiceSearchCard(onTap: () => _openBrowser()),
                    const SizedBox(height: AppSpacing.md),
                    _recentSection(),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Showing up to 3 recent files',
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _favoritesSection(),
                    const SizedBox(height: AppSpacing.sm),
                    _categoriesSection(),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap a category to browse filtered files.',
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _browseAllCard(),
                    const SizedBox(height: AppSpacing.sm),
                    _tipCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentSection() => SectionCard(
    title: 'Recent Files',
    leadingIcon: Icons.schedule,
    trailing: TextButton(
      onPressed: () => _openBrowser(),
      child: const Text('View all'),
    ),
    child: Column(
      children: [
        for (var i = 0; i < _recent.length; i++) ...[
          FileListItem(
            file: _recent[i],
            isFavorite: AppState.isFavorite(_recent[i].id),
            isSelected: _selectedFileId == _recent[i].id,
            onTap: () => setState(() {
              _selectedFileId = _selectedFileId == _recent[i].id
                  ? null
                  : _recent[i].id;
            }),
            onLongPress: () => _toggleFavorite(_recent[i].id),
          ),
          if (i < _recent.length - 1)
            Divider(
              height: 1,
              indent: AppSpacing.md,
              endIndent: AppSpacing.md,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
        ],
      ],
    ),
  );

  Widget _favoritesSection() => SectionCard(
    title: 'Favorites',
    leadingIcon: Icons.star_border,
    trailing: TextButton(
      onPressed: () => _openBrowser(category: 'Favorites'),
      child: const Text('View all'),
    ),
    child: _favorites.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text('No favorites yet.'),
          )
        : Column(
            children: [
              for (var i = 0; i < _favorites.length; i++) ...[
                FileListItem(
                  file: _favorites[i],
                  isFavorite: true,
                  isSelected: _selectedFileId == _favorites[i].id,
                  onTap: () => setState(() {
                    _selectedFileId = _selectedFileId == _favorites[i].id
                        ? null
                        : _favorites[i].id;
                  }),
                  onLongPress: () => _toggleFavorite(_favorites[i].id),
                ),
                if (i < _favorites.length - 1)
                  Divider(
                    height: 1,
                    indent: AppSpacing.md,
                    endIndent: AppSpacing.md,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
              ],
            ],
          ),
  );

  Widget _categoriesSection() => SectionCard(
    title: 'Categories',
    leadingIcon: Icons.folder_outlined,
    trailing: TextButton(
      onPressed: () => _openBrowser(),
      child: const Text('More categories →'),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryNavigationItem(
          categoryName: 'Documents',
          icon: Icons.description_outlined,
          tintColor: kDocumentsColors.tint,
          foregroundColor: kDocumentsColors.foreground,
          itemCount: _countFor('Documents'),
          onTap: () => _openBrowser(category: 'Documents'),
        ),
        CategoryNavigationItem(
          categoryName: 'Images',
          icon: Icons.image_outlined,
          tintColor: kImagesColors.tint,
          foregroundColor: kImagesColors.foreground,
          itemCount: _countFor('Images'),
          onTap: () => _openBrowser(category: 'Images'),
        ),
        CategoryNavigationItem(
          categoryName: 'Videos',
          icon: Icons.video_library_outlined,
          tintColor: kVideosColors.tint,
          foregroundColor: kVideosColors.foreground,
          itemCount: _countFor('Videos'),
          onTap: () => _openBrowser(category: 'Videos'),
        ),
        CategoryNavigationItem(
          categoryName: 'Audio',
          icon: Icons.music_note_outlined,
          tintColor: kAudioColors.tint,
          foregroundColor: kAudioColors.foreground,
          itemCount: _countFor('Audio'),
          onTap: () => _openBrowser(category: 'Audio'),
        ),
      ],
    ),
  );

  Widget _browseAllCard() {
    final theme = Theme.of(context);
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
      child: InkWell(
        onTap: () => _openBrowser(),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          leading: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.folder, color: theme.colorScheme.secondary),
          ),
          title: Text('Browse All Files', style: theme.textTheme.bodyMedium),
          subtitle: Text(
            'View all files in your device',
            style: theme.textTheme.labelSmall,
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget _tipCard() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: theme.colorScheme.secondary,
          ),
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
                  'Example: "Find my math notes from last week"',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceSearchCard extends StatelessWidget {
  final VoidCallback onTap;

  const _VoiceSearchCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: 'Voice Search. Tap to speak and find files.',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSecondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic,
                  size: 36,
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
