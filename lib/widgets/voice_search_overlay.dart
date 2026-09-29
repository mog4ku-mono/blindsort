import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../services/voice_service.dart';
import '../utils/voice_command_parser.dart';

/// Shows the voice search overlay. Returns the intent the user spoke, or
/// null if they cancelled or speech was not recognised.
Future<VoiceIntent?> showVoiceSearchOverlay(BuildContext context) async {
  final result = await showGeneralDialog<VoiceIntent>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    transitionDuration: const Duration(milliseconds: 420),
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
          child: child,
        ),
      );
    },
    pageBuilder: (_, _, _) => const _VoiceSearchScreen(),
  );
  return result;
}

class _VoiceSearchScreen extends StatefulWidget {
  const _VoiceSearchScreen();

  @override
  State<_VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<_VoiceSearchScreen>
    with SingleTickerProviderStateMixin {
  static const _hints = [
    'Try saying: open settings',
    'Try saying: open file browser',
    'Try saying: go home',
  ];

  final VoiceService _voice = VoiceService();
  late final AnimationController _pulse;
  late final Animation<double> _pulseAnim;
  Timer? _hintTimer;
  Timer? _autoDismiss;
  Timer? _submitTimer;
  int _hintIndex = 0;
  bool _speechReady = false;
  String _lastHeard = '';

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.9,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    _hintTimer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      if (!mounted) return;
      setState(() => _hintIndex = (_hintIndex + 1) % _hints.length);
    });
    _autoDismiss = Timer(const Duration(seconds: 20), () {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
    _startListening();
  }

  Future<void> _startListening() async {
    final ok = await _voice.init();
    if (!mounted) return;
    if (!ok) {
      setState(() => _speechReady = false);
      return;
    }
    setState(() => _speechReady = true);
    await _voice.listen(
      onResult: (text, isFinal) {
        if (!mounted) return;
        // Show what the microphone is hearing in real time.
        setState(() => _lastHeard = text);
        // Reset the auto-submit window on every new phrase.
        _submitTimer?.cancel();
        if (isFinal && text.isNotEmpty) {
          _submitPhrase(text);
          return;
        }
        // If the browser never sends a "final" flag, submit after a pause.
        if (text.isNotEmpty) {
          _submitTimer = Timer(const Duration(milliseconds: 1500), () {
            if (!mounted) return;
            _submitPhrase(_lastHeard);
          });
        }
      },
    );
  }

  void _submitPhrase(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final intent = VoiceCommandParser.parse(trimmed);
    Navigator.of(context).pop(intent);
  }

  @override
  void dispose() {
    _voice.stop();
    _pulse.dispose();
    _hintTimer?.cancel();
    _autoDismiss?.cancel();
    _submitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = _lastHeard.isEmpty
        ? (_speechReady ? _hints[_hintIndex] : 'Microphone not available')
        : '"$_lastHeard"';

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.colorScheme.secondary, const Color(0xFF00695C)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, _) => Transform.scale(
                    scale: _pulseAnim.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.mic,
                        size: 64,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  _speechReady ? 'Listening...' : 'Microphone not available',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    displayText,
                    key: ValueKey(displayText),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontStyle: _lastHeard.isEmpty
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
