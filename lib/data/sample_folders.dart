import '../models/folder_item.dart';

/// Two folders the browser demo shows under Documents. Real folder scanning
/// is the device target; the web build keeps this list fixed.
final List<FolderItem> sampleFolders = [
  FolderItem(
    id: 'd1',
    name: 'Lectures',
    itemCount: 12,
    modifiedAt: DateTime(2026, 5, 20),
  ),
  FolderItem(
    id: 'd2',
    name: 'Assignments',
    itemCount: 7,
    modifiedAt: DateTime(2026, 5, 19),
  ),
];
