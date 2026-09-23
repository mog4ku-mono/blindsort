/// One file entry in the BlindSort browser. Immutable: screens filter and
/// search the list without mutating the entries themselves.
class FileItem {
  final String id;
  final String name;
  final String type;
  final String location;
  final double sizeMb;
  final DateTime modifiedAt;
  final bool isFavorite;

  const FileItem({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.sizeMb,
    required this.modifiedAt,
    this.isFavorite = false,
  });
}
