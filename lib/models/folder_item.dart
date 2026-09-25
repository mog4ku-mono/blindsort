/// A folder row in the File Browser. Kept separate from FileItem because a
/// folder navigates, a file opens. Same shape otherwise.
class FolderItem {
  final String id;
  final String name;
  final int itemCount;
  final DateTime modifiedAt;

  const FolderItem({
    required this.id,
    required this.name,
    required this.itemCount,
    required this.modifiedAt,
  });
}
