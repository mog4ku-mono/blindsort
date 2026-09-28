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
  static const _statuses = [
    'Listening...',
    'Speak your command',
    "I'm listening...",
    'Try saying: open settings',
    'Say: open file browser',
  ];

  final VoiceService _voice = VoiceService();
  late final AnimationController _pulse;
  late final Animation<double> _pulseAnim;
  Timer? _statusTimer;
  Timer? _autoDismiss;
  int _statusIndex = 0;
  bool _speechReady = false;

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
    _statusTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!mounted) return;
      setState(() => _statusIndex = (_statusIndex + 1) % _statuses.length);
    });
    _autoDismiss = Timer(const Duration(seconds: 12), () {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
    _startListening();
  }

  Future<void> _startListening() async {
    final ok = await _voice.init();
    if (!mounted) return;
    if (!ok) {
      setState(() {
        _speechReady = false;
        _statusIndex = 0;
      });
      return;
    }
    setState(() => _speechReady = true);
    await _voice.listen(
      onResult: (text) {
        if (!mounted) return;
        final intent = VoiceCommandParser.parse(text);
        Navigator.of(context).pop(intent);
      },
    );
  }

  @override
  void dispose() {
    _voice.stop();
    _pulse.dispose();
    _statusTimer?.cancel();
    _autoDismiss?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: Text(
                    _speechReady
                        ? _statuses[_statusIndex]
                        : 'Microphone not available',
                    key: ValueKey(_statusIndex),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
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
