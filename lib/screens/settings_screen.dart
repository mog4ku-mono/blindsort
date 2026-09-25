import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../state/app_state.dart';

/// Settings. Six groups of toggles with Save and Revert at the bottom when
/// there are pending changes. Dark mode applies immediately so the user sees
/// the effect; other toggles commit together on Save.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? _pScreenReader;
  bool? _pFocusIndicators;
  bool? _pVoiceInput;
  bool? _pReadAloud;
  bool? _pAudioFeedback;
  bool? _pHaptic;
  bool? _pHapticActions;
  bool? _pAutoBackup;
  String? _pLanguage;

  bool _dirty = false;

  bool get _screenReader => _pScreenReader ?? AppState.screenReaderHints;
  bool get _focusIndicators => _pFocusIndicators ?? AppState.focusIndicators;
  bool get _voiceInput => _pVoiceInput ?? AppState.voiceInput;
  bool get _readAloud => _pReadAloud ?? AppState.readAloud;
  bool get _audioFeedback => _pAudioFeedback ?? AppState.audioFeedback;
  bool get _haptic => _pHaptic ?? AppState.hapticFeedback;
  bool get _hapticActions => _pHapticActions ?? AppState.hapticOnActions;
  bool get _autoBackup => _pAutoBackup ?? AppState.autoBackup;
  String get _language => _pLanguage ?? AppState.language;

  void _mark() => setState(() => _dirty = true);

  bool _groupDirty({required List<bool?> pending}) =>
      pending.any((p) => p != null);

  void _save() {
    if (_pScreenReader != null) AppState.screenReaderHints = _pScreenReader!;
    if (_pFocusIndicators != null) {
      AppState.focusIndicators = _pFocusIndicators!;
    }
    if (_pVoiceInput != null) AppState.voiceInput = _pVoiceInput!;
    if (_pReadAloud != null) AppState.readAloud = _pReadAloud!;
    if (_pAudioFeedback != null) AppState.audioFeedback = _pAudioFeedback!;
    if (_pHaptic != null) AppState.hapticFeedback = _pHaptic!;
    if (_pHapticActions != null) AppState.hapticOnActions = _pHapticActions!;
    if (_pAutoBackup != null) AppState.autoBackup = _pAutoBackup!;
    if (_pLanguage != null) AppState.language = _pLanguage!;
    setState(() {
      _pScreenReader = null;
      _pFocusIndicators = null;
      _pVoiceInput = null;
      _pReadAloud = null;
      _pAudioFeedback = null;
      _pHaptic = null;
      _pHapticActions = null;
      _pAutoBackup = null;
      _pLanguage = null;
      _dirty = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _revert() {
    setState(() {
      _pScreenReader = null;
      _pFocusIndicators = null;
      _pVoiceInput = null;
      _pReadAloud = null;
      _pAudioFeedback = null;
      _pHaptic = null;
      _pHapticActions = null;
      _pAutoBackup = null;
      _pLanguage = null;
      _dirty = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        title: Text(
          'Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
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
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  _settingsCard(
                    theme,
                    icon: Icons.accessibility_new,
                    title: 'Accessibility',
                    subtitle: 'Screen reader, focus, touch, and navigation',
                    dirty: _groupDirty(
                      pending: [_pScreenReader, _pFocusIndicators],
                    ),
                    onTap: () => _openSheet(
                      title: 'Accessibility',
                      childrenBuilder: (rebuild) => [
                        _switchTile(
                          'Screen reader hints',
                          'Announce actions and outcomes',
                          _screenReader,
                          (v) {
                            _pScreenReader = v;
                            _mark();
                            rebuild();
                          },
                        ),
                        _switchTile(
                          'Focus indicators',
                          'Show current element focus',
                          _focusIndicators,
                          (v) {
                            _pFocusIndicators = v;
                            _mark();
                            rebuild();
                          },
                        ),
                      ],
                    ),
                  ),
                  _settingsCard(
                    theme,
                    icon: Icons.chat_bubble_outline,
                    title: 'Speech',
                    subtitle: 'Voice, reading, and audio feedback',
                    dirty: _groupDirty(
                      pending: [_pVoiceInput, _pReadAloud, _pAudioFeedback],
                    ),
                    onTap: () => _openSheet(
                      title: 'Speech',
                      childrenBuilder: (rebuild) => [
                        _switchTile(
                          'Voice input',
                          'Allow voice commands',
                          _voiceInput,
                          (v) {
                            _pVoiceInput = v;
                            _mark();
                            rebuild();
                          },
                        ),
                        _switchTile(
                          'Read aloud',
                          'Read screen content aloud',
                          _readAloud,
                          (v) {
                            _pReadAloud = v;
                            _mark();
                            rebuild();
                          },
                        ),
                        _switchTile(
                          'Audio feedback',
                          'Play sounds on actions',
                          _audioFeedback,
                          (v) {
                            _pAudioFeedback = v;
                            _mark();
                            rebuild();
                          },
                        ),
                      ],
                    ),
                  ),
                  _settingsCard(
                    theme,
                    icon: Icons.visibility_outlined,
                    title: 'Appearance',
                    subtitle: 'Text, contrast, color, and layout',
                    dirty: AppState.themeMode.value == ThemeMode.dark,
                    onTap: () => _openSheet(
                      title: 'Appearance',
                      childrenBuilder: (rebuild) => [
                        _switchTile(
                          'Dark mode',
                          'Use dark surfaces across the app',
                          AppState.themeMode.value == ThemeMode.dark,
                          (v) {
                            AppState.themeMode.value = v
                                ? ThemeMode.dark
                                : ThemeMode.light;
                            setState(() {});
                            rebuild();
                          },
                        ),
                      ],
                    ),
                  ),
                  _settingsCard(
                    theme,
                    icon: Icons.vibration,
                    title: 'Haptic Feedback',
                    subtitle: 'Vibration and touch feedback',
                    dirty: _groupDirty(pending: [_pHaptic, _pHapticActions]),
                    onTap: () => _openSheet(
                      title: 'Haptic Feedback',
                      childrenBuilder: (rebuild) => [
                        _switchTile(
                          'Enable haptics',
                          'Vibrate on interactions',
                          _haptic,
                          (v) {
                            _pHaptic = v;
                            _mark();
                            rebuild();
                          },
                        ),
                        _switchTile(
                          'Haptics on actions',
                          'Vibrate on save and delete',
                          _hapticActions,
                          (v) {
                            _pHapticActions = v;
                            _mark();
                            rebuild();
                          },
                        ),
                      ],
                    ),
                  ),
                  _settingsCard(
                    theme,
                    icon: Icons.settings_outlined,
                    title: 'General',
                    subtitle: 'Backup, language, and other preferences',
                    dirty: _pAutoBackup != null || _pLanguage != null,
                    onTap: () => _openSheet(
                      title: 'General',
                      childrenBuilder: (rebuild) => [
                        _switchTile(
                          'Auto backup',
                          'Back up preferences weekly',
                          _autoBackup,
                          (v) {
                            _pAutoBackup = v;
                            _mark();
                            rebuild();
                          },
                        ),
                        Builder(
                          builder: (context) {
                            final t = Theme.of(context);
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Language',
                                style: t.textTheme.bodyMedium?.copyWith(
                                  color: _language != 'English'
                                      ? t.colorScheme.secondary
                                      : null,
                                  fontWeight: _language != 'English'
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(
                                _language,
                                style: t.textTheme.labelSmall,
                              ),
                              trailing: DropdownButton<String>(
                                value: _language,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'English',
                                    child: Text('English'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Filipino',
                                    child: Text('Filipino'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Spanish',
                                    child: Text('Spanish'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() {
                                    _pLanguage = v;
                                    _dirty = true;
                                  });
                                  rebuild();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _settingsCard(
                    theme,
                    icon: Icons.restore,
                    title: 'Reset to Defaults',
                    subtitle: 'Restore all settings to recommended values',
                    dirty: false,
                    onTap: _confirmReset,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _tipCard(theme),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
            if (_dirty) _saveBar(theme),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(theme),
    );
  }

  Widget _settingsCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool dirty,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: dirty
                ? theme.colorScheme.secondary
                : theme.colorScheme.outlineVariant,
            width: dirty ? 1.5 : 1,
          ),
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.onSecondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (dirty)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                Icon(
                  Icons.chevron_right,
                  color: dirty
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Switch tile that reads the current theme itself, so dark-mode changes
  /// reach it. When value is true, the title turns teal so it stands out
  /// against siblings that are still off.
  Widget _switchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: value ? theme.colorScheme.secondary : null,
              fontWeight: value ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: Text(subtitle, style: theme.textTheme.labelSmall),
          value: value,
          activeThumbColor: theme.colorScheme.secondary,
          onChanged: onChanged,
        );
      },
    );
  }

  void _openSheet({
    required String title,
    required List<Widget> Function(void Function() rebuild) childrenBuilder,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) {
          final currentTheme = Theme.of(context);
          final children = childrenBuilder(() => setSheetState(() {}));
          return Padding(
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
                Text(title, style: currentTheme.textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                for (final child in children) child,
              ],
            ),
          );
        },
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _confirmReset() async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset to defaults?'),
        content: const Text(
          'All settings will return to their recommended values. Favorites '
          'and folders are not affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      AppState.resetSettings();
      setState(() {
        _dirty = false;
        _pScreenReader = null;
        _pFocusIndicators = null;
        _pVoiceInput = null;
        _pReadAloud = null;
        _pAudioFeedback = null;
        _pHaptic = null;
        _pHapticActions = null;
        _pAutoBackup = null;
        _pLanguage = null;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings reset to defaults'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _saveBar(ThemeData theme) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    decoration: BoxDecoration(
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
      border: Border(top: BorderSide(color: theme.colorScheme.secondary)),
    ),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _revert,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Revert'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Save changes'),
          ),
        ),
      ],
    ),
  );

  Widget _tipCard(ThemeData theme) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 20, color: theme.colorScheme.secondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tip: Adjust one setting at a time.',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Your changes are saved automatically once you tap Save.',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );

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
}
