import 'package:speech_to_text/speech_to_text.dart';

/// Wraps speech_to_text so the app can start and stop listening without
/// knowing the package API. Every recognised phrase (interim or final) is
/// handed back through the callback, so the overlay can show what the
/// microphone is hearing as the user speaks.
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
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (!_available) return;
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
      ),
    );
  }

  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
