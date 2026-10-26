// Plug-in points. These are stubs so the skeleton runs without native setup.

/// Records the child's voice.
/// Real version: `record` package + `permission_handler` (RECORD_AUDIO).
abstract class SpeechRecorder {
  Future<bool> start();
  Future<String?> stop(); // returns file path of the recording
}

class StubRecorder implements SpeechRecorder {
  @override
  Future<bool> start() async => true;
  @override
  Future<String?> stop() async => null;
}

/// Plays the spoken instruction/word.
/// Real version: `audioplayers` with your own recordings, or `flutter_tts`.
class PromptPlayer {
  static Future<void> speak(String text) async {}
}
