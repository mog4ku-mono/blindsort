import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../data/sample_files.dart';
import '../models/file_item.dart';
import '../widgets/app_header.dart';
import '../widgets/file_list_item.dart';
import '../widgets/section_card.dart';

/// Home Dashboard. First screen of the four-screen journey: recent files and
/// favorites, with a View all shortcut into the File Browser later.
///
/// Scope for this first slice: Recent Files and Favorites only. The category
/// grid, Voice Search hero, and Browser route come in the next increment.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controlled dataset. On device this will come from a service that reads
  /// the real filesystem; the browser build keeps the sample list.
  final List<FileItem> _allFiles = sampleFiles;

  List<FileItem> get _recent => _allFiles.take(3).toList();

  List<FileItem> get _favorites =>
      _allFiles.where((f) => f.isFavorite).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const AppHeader(title: 'BlindSort'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Your command center. Continue your work.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SectionCard(
            title: 'Recent Files',
            trailing: TextButton(
              onPressed: () {},
              child: const Text('View all'),
            ),
            child: Column(
              children: [
                for (final f in _recent) FileListItem(file: f, onTap: () {}),
              ],
            ),
          ),
          SectionCard(
            title: 'Favorites',
            trailing: TextButton(
              onPressed: () {},
              child: const Text('View all'),
            ),
            child: _favorites.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Text('No favorites yet.'),
                  )
                : Column(
                    children: [
                      for (final f in _favorites)
                        FileListItem(file: f, onTap: () {}),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
