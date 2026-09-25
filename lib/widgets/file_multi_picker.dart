import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/file_type_colors.dart';
import '../data/sample_files.dart';
import '../state/app_state.dart';

Future<void> showFileMultiPicker(
  BuildContext context,
  String folderName, {
  required VoidCallback onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) =>
        _FileMultiPicker(folderName: folderName, onChanged: onChanged),
  );
}

class _FileMultiPicker extends StatefulWidget {
  final String folderName;
  final VoidCallback onChanged;

  const _FileMultiPicker({required this.folderName, required this.onChanged});

  @override
  State<_FileMultiPicker> createState() => _FileMultiPickerState();
}

class _FileMultiPickerState extends State<_FileMultiPicker> {
  late final Set<String> _selected;
  late final List _candidates;

  @override
  void initState() {
    super.initState();
    _selected = {
      ...(AppState.folderContents[widget.folderName] ?? const <String>{}),
    };
    _candidates = sampleFiles.where((f) => !AppState.isDeleted(f.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    return SizedBox(
      height: media.size.height * 0.78,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xs,
            ),
            child: Text(
              'Files for "${widget.folderName}"',
              style: theme.textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              '${_selected.length} selected',
              style: theme.textTheme.labelSmall,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView.builder(
              itemCount: _candidates.length,
              itemBuilder: (_, i) {
                final file = _candidates[i];
                final selected = _selected.contains(file.id);
                final color = kFileTypeColors[file.type] ?? kDefaultTypeColor;
                return InkWell(
                  onTap: () => setState(() {
                    if (selected) {
                      _selected.remove(file.id);
                    } else {
                      _selected.add(file.id);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.secondaryContainer.withValues(
                              alpha: 0.4,
                            )
                          : Colors.transparent,
                      border: Border(
                        right: BorderSide(
                          color: selected
                              ? theme.colorScheme.secondary
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: ListTile(
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
                      title: Text(file.name, style: theme.textTheme.bodyMedium),
                      subtitle: Text(
                        '${file.sizeMb} MB',
                        style: theme.textTheme.labelSmall,
                      ),
                      trailing: Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: selected
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      AppState.folderContents[widget.folderName] = {
                        ..._selected,
                      };
                      Navigator.pop(context);
                      widget.onChanged();
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
