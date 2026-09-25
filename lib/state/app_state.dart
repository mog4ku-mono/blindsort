import '../models/file_item.dart';
import '../models/folder_item.dart';

/// In-memory application state that survives route changes. Real persistence
/// (shared_preferences) is a Week 3 task. This holds favorites, custom
/// folders, and the mapping from folder name to the files placed inside it.
class AppState {
  AppState._();

  static final List<FolderItem> customFolders = [];
  static final Set<String> favoriteIds = {};
  static final Map<String, Set<String>> folderContents = {};

  /// Seeds favorites from the sample dataset. Called once at startup so
  /// initial favourites persist alongside the ones the user toggles.
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

  static void addFileToFolder(String folderName, String fileId) {
    folderContents.putIfAbsent(folderName, () => {}).add(fileId);
  }

  static int itemCountFor(FolderItem folder) {
    final contents = folderContents[folder.name];
    if (contents != null) return contents.length;
    return folder.itemCount;
  }

  static bool isCustomFolder(String name) => folderContents.containsKey(name);
}
