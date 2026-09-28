import 'package:speech_to_text/speech_to_text.dart';

/// Wraps speech_to_text so the app can start and stop listening without
/// knowing the package API. Text is handed back through a callback.
class VoiceService {
  final SpeechToText _speech = SpeechToText();
  bool _available = false;

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  Future<bool> init() async {
    _available = await _speech.initialize();
    return _available;
  }

  Future<void> listen({
    required void Function(String text) onResult,
    void Function()? onDone,
  }) async {
    if (!_available) return;
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 12),
        pauseFor: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
