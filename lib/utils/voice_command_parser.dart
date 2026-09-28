/// Turns a spoken phrase into an intent the app can act on.
enum VoiceIntent { openBrowser, openSettings, openHome, search, unknown }

class VoiceCommandParser {
  /// Returns the intent the phrase most likely means, or unknown.
  /// Kept simple on purpose: substring matching, no ML, no external call.
  static VoiceIntent parse(String phrase) {
    final p = phrase.toLowerCase().trim();

    // YOUR EXAMPLE 1 - keep or change
    if (p.contains('browser') || p.contains('files')) {
      return VoiceIntent.openBrowser;
    }

    // YOUR EXAMPLE 2 - keep or change
    if (p.contains('settings') || p.contains('preferences')) {
      return VoiceIntent.openSettings;
    }

    // TODO: add a case for openHome
    // Hint: "home", "main screen", "go back"
    if (p.contains('home') || p.contains('main screen')) {
      return VoiceIntent.openHome;
    }

    // TODO: add a case for search
    // Hint: "search for", "find", "look for"
    if (p.contains('search for') ||
        p.contains('find') ||
        p.contains('look for')) {
      return VoiceIntent.search;
    }

    return VoiceIntent.unknown;
  }
}
