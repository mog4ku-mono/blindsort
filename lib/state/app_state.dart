import '../models/file_item.dart';
import '../models/folder_item.dart';

/// In-memory application state that survives route changes. Real persistence
/// (shared_preferences) is a Week 3 task.
class AppState {
  AppState._();

  static final List<FolderItem> customFolders = [];
  static final Set<String> favoriteIds = {};
  static final Map<String, Set<String>> folderContents = {};
  static final Set<String> deletedFileIds = {};
  static final Set<String> deletedFolderNames = {};

  static void init(List<FileItem> files) {
    if (favoriteIds.isEmpty) {
      favoriteIds.addAll(files.where((f) => f.isFavorite).map((f) => f.id));
    }
  }

  static bool isFavorite(String id) => favoriteIds.contains(id);

  static void toggleFavorite(String id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
  }

  static bool isDeleted(String fileId) => deletedFileIds.contains(fileId);

  static void deleteFile(String fileId) {
    deletedFileIds.add(fileId);
    favoriteIds.remove(fileId);
    for (final set in folderContents.values) {
      set.remove(fileId);
    }
  }

  static bool isFolderDeleted(String name) => deletedFolderNames.contains(name);

  static void addFolder(String name) {
    customFolders.add(
      FolderItem(
        id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        itemCount: 0,
        modifiedAt: DateTime.now(),
      ),
    );
    folderContents.putIfAbsent(name, () => {});
  }

  static void deleteFolder(String name) {
    customFolders.removeWhere((f) => f.name == name);
    folderContents.remove(name);
    deletedFolderNames.add(name);
  }

  static void addFileToFolder(String folderName, String fileId) {
    folderContents.putIfAbsent(folderName, () => {}).add(fileId);
  }

  /// Files in a folder, merging location-derived and contents-derived sets.
  static Set<String> filesInFolder(String folderName, List<FileItem> allFiles) {
    final fromLocation = allFiles
        .where((f) => f.location.contains(folderName))
        .map((f) => f.id);
    final fromContents = folderContents[folderName] ?? const <String>{};
    return {...fromLocation, ...fromContents};
  }
}
