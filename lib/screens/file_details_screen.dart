import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/file_type_colors.dart';
import '../data/file_insights.dart';
import '../models/file_item.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/file_actions_sheet.dart';

/// File Details. Hero block, AI Summary, swipeable Preview, Details, and
/// Actions. Every action button does something: Open shows a placeholder,
/// Share opens a share sheet, Locate shows a snackbar.
class FileDetailsScreen extends StatefulWidget {
  final FileItem file;

  const FileDetailsScreen({super.key, required this.file});

  @override
  State<FileDetailsScreen> createState() => _FileDetailsScreenState();
}

class _FileDetailsScreenState extends State<FileDetailsScreen> {
  bool _expandedSummary = false;
  int _previewPage = 0;
  late final PageController _pageController;

  FileItem get file => widget.file;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insight = insightFor(file.id, file.name, file.type);
    final pages = insight.pages;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          'File Details',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              AppState.isFavorite(file.id) ? Icons.star : Icons.star_border,
              color: AppState.isFavorite(file.id)
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.onSurface,
            ),
            onPressed: () => setState(() {
              AppState.toggleFavorite(file.id);
            }),
            tooltip: 'Favorite',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _openActions,
            tooltip: 'More',
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _heroCard(theme),
                const SizedBox(height: AppSpacing.md),
                _summarySection(theme, insight),
                const SizedBox(height: AppSpacing.md),
                _previewSection(theme, pages),
                const SizedBox(height: AppSpacing.md),
                _detailsSection(theme),
                const SizedBox(height: AppSpacing.md),
                _actionsSection(theme),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(theme),
    );
  }

  Widget _heroCard(ThemeData theme) {
    final badgeColor = kFileTypeColors[file.type] ?? kDefaultTypeColor;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              file.type,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name, style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${_typeLabel(file.type)} · ${file.sizeMb} MB',
                  style: theme.textTheme.labelSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      AppState.isFavorite(file.id)
                          ? Icons.star
                          : Icons.star_border,
                      size: 16,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppState.isFavorite(file.id)
                          ? 'Favorite'
                          : 'Add to favorites',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summarySection(ThemeData theme, FileInsight insight) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 16,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'AI SUMMARY',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: kFolderTeal,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '(What this file is about)',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: Text(
              insight.summary,
              style: theme.textTheme.bodyMedium,
              maxLines: _expandedSummary ? null : 3,
              overflow: _expandedSummary
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Key themes:',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final t in insight.themes)
                Chip(
                  label: Text(t, style: theme.textTheme.labelSmall),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: () =>
                  setState(() => _expandedSummary = !_expandedSummary),
              icon: Icon(
                _expandedSummary ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: theme.colorScheme.secondary,
              ),
              label: Text(
                _expandedSummary ? 'Show less' : 'Show more',
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewSection(ThemeData theme, List<PreviewPage> pages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'PREVIEW',
              style: theme.textTheme.labelSmall?.copyWith(
                color: kFolderTeal,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              pages.length > 1
                  ? '(Page ${_previewPage + 1} of ${pages.length})'
                  : '(First page)',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.secondary.withValues(alpha: 0.35),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 220,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  physics: const PageScrollPhysics(),
                  pageSnapping: true,
                  onPageChanged: (i) => setState(() => _previewPage = i),
                  itemBuilder: (_, i) => _previewPageContent(theme, pages[i]),
                ),
                if (_previewPage > 0)
                  Positioned(
                    left: 4,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _previewArrow(
                        theme,
                        Icons.chevron_left,
                        'Previous page',
                        () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                  ),
                if (_previewPage < pages.length - 1)
                  Positioned(
                    right: 4,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _previewArrow(
                        theme,
                        Icons.chevron_right,
                        'Next page',
                        () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (pages.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < pages.length; i++)
                GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    width: _previewPage == i ? 10 : 8,
                    height: _previewPage == i ? 10 : 8,
                    decoration: BoxDecoration(
                      color: _previewPage == i
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.outlineVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _previewArrow(
    ThemeData theme,
    IconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: theme.colorScheme.surface.withValues(alpha: 0.85),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Icon(icon, size: 22, color: theme.colorScheme.secondary),
          ),
        ),
      ),
    );
  }

  Widget _previewPageContent(ThemeData theme, PreviewPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  page.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final b in page.bullets)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• '),
                        Expanded(
                          child: Text(b, style: theme.textTheme.labelSmall),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (page.hasDiagram) ...[
            const SizedBox(width: AppSpacing.sm),
            Expanded(flex: 2, child: _diagram(theme)),
          ],
        ],
      ),
    );
  }

  Widget _diagram(ThemeData theme) {
    Widget box() => Container(
      width: 28,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(3),
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        box(),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [box(), const SizedBox(width: 4), box()],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [box(), const SizedBox(width: 4), box()],
        ),
      ],
    );
  }

  Widget _detailsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DETAILS',
          style: theme.textTheme.labelSmall?.copyWith(
            color: kFolderTeal,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              _detailRow(
                theme,
                Icons.folder_outlined,
                'Location',
                file.location,
              ),
              Divider(
                height: 1,
                indent: AppSpacing.md,
                endIndent: AppSpacing.md,
                color: theme.colorScheme.outlineVariant,
              ),
              _detailRow(
                theme,
                Icons.access_time,
                'Modified',
                _fullDate(file.modifiedAt),
              ),
              Divider(
                height: 1,
                indent: AppSpacing.md,
                endIndent: AppSpacing.md,
                color: theme.colorScheme.outlineVariant,
              ),
              _detailRow(
                theme,
                Icons.description_outlined,
                'Type',
                _typeLabel(file.type),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _actionsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIONS',
          style: theme.textTheme.labelSmall?.copyWith(
            color: kFolderTeal,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: FilledButton.icon(
                onPressed: _onOpen,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                icon: const Icon(Icons.visibility_outlined, size: 20),
                label: const Text('Open'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 3,
              child: OutlinedButton.icon(
                onPressed: _onShare,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                icon: const Icon(Icons.share_outlined, size: 20),
                label: const Text('Share'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                onPressed: _onLocate,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                icon: const Icon(Icons.folder_outlined, size: 20),
                label: const Text('Locate'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onOpen() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Opening file'),
        content: Text(
          'In the Android build, ${file.name} would open in the app that '
          'handles ${file.type} files. The browser demo shows a placeholder '
          'here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _onShare() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy file name'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy location'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share via...'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onLocate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Located in ${file.location}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openActions() {
    showFileActions(
      context,
      file,
      onChanged: () {
        if (mounted) setState(() {});
      },
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
          child: Semantics(
            button: true,
            label: 'Home',
            child: InkWell(
              onTap: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: theme.colorScheme.secondary,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Home',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  String _typeLabel(String t) {
    switch (t) {
      case 'PDF':
        return 'PDF Document';
      case 'DOC':
      case 'DOCX':
        return 'Word Document';
      case 'PPT':
      case 'PPTX':
        return 'Presentation';
      case 'PNG':
      case 'JPG':
      case 'JPEG':
        return 'Image';
      case 'MP4':
      case 'MKV':
        return 'Video';
      case 'MP3':
        return 'Audio';
      case 'ZIP':
        return 'Archive';
      case 'APK':
        return 'App Package';
      default:
        return '$t file';
    }
  }

  String _fullDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  ·  $h:$m $ampm';
  }
}
