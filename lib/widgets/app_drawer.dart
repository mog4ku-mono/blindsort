import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/file_type_colors.dart';
import '../data/sample_files.dart';
import '../state/app_state.dart';

/// Navigation drawer opened from the hamburger on Home. Groups quick
/// navigation, Recently Deleted, Storage, and About into one sheet.
class AppDrawer extends StatelessWidget {
  final VoidCallback onOpenBrowser;
  final VoidCallback onOpenSettings;
  final VoidCallback onClose;

  const AppDrawer({
    super.key,
    required this.onOpenBrowser,
    required this.onOpenSettings,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _header(theme),
            const SizedBox(height: AppSpacing.sm),
            _tile(
              context,
              icon: Icons.home_outlined,
              title: 'Home',
              subtitle: 'Overview and categories',
              onTap: onClose,
            ),
            _tile(
              context,
              icon: Icons.folder_open_outlined,
              title: 'File Browser',
              subtitle: 'Browse, search, and filter',
              onTap: () {
                Navigator.pop(context);
                onOpenBrowser();
              },
            ),
            _tile(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Accessibility and preferences',
              onTap: () {
                Navigator.pop(context);
                onOpenSettings();
              },
            ),
            const Divider(height: 1),
            _tile(
              context,
              icon: Icons.delete_outline,
              title: 'Recently Deleted',
              subtitle: AppState.deletedIdsList.isEmpty
                  ? 'No deleted files'
                  : '${AppState.deletedIdsList.length} file(s)',
              onTap: () {
                Navigator.pop(context);
                _showRecentlyDeleted(context);
              },
            ),
            _tile(
              context,
              icon: Icons.pie_chart_outline,
              title: 'Storage',
              subtitle: 'Space used by category',
              onTap: () {
                Navigator.pop(context);
                _showStorage(context);
              },
            ),
            const Divider(height: 1),
            _tile(
              context,
              icon: Icons.info_outline,
              title: 'About BlindSort',
              subtitle: 'What this app is for',
              onTap: () {
                Navigator.pop(context);
                _showAbout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(ThemeData theme) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [theme.colorScheme.secondary, const Color(0xFF00695C)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BlindSort',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Accessibility-first file manager',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    ),
  );

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.secondary),
      title: Text(title, style: theme.textTheme.bodyMedium),
      subtitle: Text(subtitle, style: theme.textTheme.labelSmall),
      onTap: onTap,
    );
  }

  void _showRecentlyDeleted(BuildContext context) {
    final theme = Theme.of(context);
    final deleted = AppState.deletedIdsList;

    showModalBottomSheet<void>(
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
                'Recently Deleted',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            if (deleted.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'No files have been deleted. Long-press a file and choose '
                  'Delete to move it here.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              for (final id in deleted)
                Builder(
                  builder: (context) {
                    final file = sampleFiles.firstWhere((f) => f.id == id);
                    final color =
                        kFileTypeColors[file.type] ?? kDefaultTypeColor;
                    return ListTile(
                      leading: Container(
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
                      ),
                      title: Text(file.name),
                      subtitle: Text('Tap to restore'),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.restore,
                          color: theme.colorScheme.secondary,
                        ),
                        tooltip: 'Restore',
                        onPressed: () {
                          AppState.restoreFile(file.id);
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${file.name} restored'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        AppState.restoreFile(file.id);
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${file.name} restored'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }

  void _showStorage(BuildContext context) {
    final theme = Theme.of(context);
    final counts = <String, int>{};
    var totalMb = 0.0;
    for (final f in sampleFiles) {
      if (AppState.isDeleted(f.id)) continue;
      final cat = kFileTypeCategory[f.type] ?? 'Other';
      counts[cat] = (counts[cat] ?? 0) + 1;
      totalMb += f.sizeMb;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
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
              Text('Storage', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${totalMb.toStringAsFixed(1)} MB used across '
                '${counts.values.fold(0, (a, b) => a + b)} files',
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final entry in counts.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '${entry.value} files',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About BlindSort'),
        content: Text(
          'BlindSort is an accessibility-first file manager for blind and '
          'low-vision users. It speaks file names, types, and metadata so '
          'you can find what you need without reading a screen.\n\n'
          'Long-press a file to favorite, add to a folder, or delete. Tap a '
          'file to see details and an AI summary.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
