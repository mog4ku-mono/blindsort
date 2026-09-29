import '../models/file_item.dart';

/// The kind of action a spoken phrase maps to.
enum VoiceCommandType { browser, settings, home, search, file, unknown }

/// A parsed voice command. `value` carries the category name, search query,
/// or file id depending on the type.
class VoiceCommand {
  final VoiceCommandType type;
  final String? value;

  const VoiceCommand(this.type, [this.value]);

  const VoiceCommand.browser([String? category])
    : type = VoiceCommandType.browser,
      value = category;
  const VoiceCommand.settings()
    : type = VoiceCommandType.settings,
      value = null;
  const VoiceCommand.home() : type = VoiceCommandType.home, value = null;
  const VoiceCommand.search(String query)
    : type = VoiceCommandType.search,
      value = query;
  const VoiceCommand.file(String fileId)
    : type = VoiceCommandType.file,
      value = fileId;
  const VoiceCommand.unknown() : type = VoiceCommandType.unknown, value = null;
}

/// Turns a spoken phrase into a command. Uses simple substring matching so
/// it runs offline and does not need a language model. The order of checks
/// matters: specific phrases before general ones.
class VoiceCommandParser {
  static const _categoryWords = {
    'document': 'Documents',
    'pdf': 'Documents',
    'image': 'Images',
    'photo': 'Images',
    'picture': 'Images',
    'video': 'Videos',
    'audio': 'Audio',
    'music': 'Audio',
    'favorite': 'Favorites',
    'favourite': 'Favorites',
  };

  static VoiceCommand parse(String phrase, List<FileItem> files) {
    final p = phrase.toLowerCase().trim();
    if (p.isEmpty) return const VoiceCommand.unknown();

    if (p.contains('settings') || p.contains('preferences')) {
      return const VoiceCommand.settings();
    }

    if (p.contains('home') || p.contains('main screen')) {
      return const VoiceCommand.home();
    }

    // "open file browser" or "open files" comes before category checks so
    // a bare "files" doesn't get misread as a folder name.
    if (p.contains('browser')) {
      return const VoiceCommand.browser();
    }

    for (final entry in _categoryWords.entries) {
      if (p.contains(entry.key)) {
        return VoiceCommand.browser(entry.value);
      }
    }

    // Search — matches "search for X", "find X", "look for X".
    final searchMatch = RegExp(
      r'\b(?:search|find|look)\s+(?:for\s+)?(.+)',
    ).firstMatch(p);
    if (searchMatch != null) {
      final q = searchMatch.group(1)?.trim() ?? '';
      if (q.isNotEmpty && q.length < 40) {
        return VoiceCommand.search(q);
      }
    }

    // File name matching. Strip common command words, then score each file
    // by how many of the remaining words its name contains.
    final file = _matchFile(p, files);
    if (file != null) return VoiceCommand.file(file.id);

    return const VoiceCommand.unknown();
  }

  static FileItem? _matchFile(String phrase, List<FileItem> files) {
    final words = phrase
        .replaceAll(
          RegExp(r'\b(open|show|the|file|please|my|go|to|me|a|an)\b'),
          ' ',
        )
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2)
        .toList();
    if (words.isEmpty) return null;

    FileItem? best;
    var bestScore = 0;
    for (final f in files) {
      final name = f.name.toLowerCase();
      var score = 0;
      for (final w in words) {
        if (name.contains(w)) score++;
      }
      if (score > bestScore) {
        bestScore = score;
        best = f;
      }
    }
    return bestScore >= 1 ? best : null;
  }
}
