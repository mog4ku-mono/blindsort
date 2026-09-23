import '../models/file_item.dart';

/// Controlled dataset for the browser build. Real Android file access is the
/// target on device, but the web demo needs files to exercise the full flow,
/// so the same list feeds every screen until device integration is in place.
/// All names are synthetic; no real student data.
final List<FileItem> sampleFiles = [
  FileItem(
    id: 'f1',
    name: 'Lecture_3_Database.pdf',
    type: 'PDF',
    location: 'Internal Storage > Documents > Lectures',
    sizeMb: 2.4,
    modifiedAt: DateTime(2026, 5, 20, 10, 24),
    isFavorite: true,
  ),
  FileItem(
    id: 'f2',
    name: 'Group_Presentation.pptx',
    type: 'PPT',
    location: 'Internal Storage > Documents',
    sizeMb: 5.1,
    modifiedAt: DateTime(2026, 5, 19, 14, 10),
  ),
  FileItem(
    id: 'f3',
    name: 'Final_Paper.docx',
    type: 'DOC',
    location: 'Internal Storage > Documents > Assignments',
    sizeMb: 1.2,
    modifiedAt: DateTime(2026, 5, 18, 9, 5),
  ),
  FileItem(
    id: 'f4',
    name: 'Calculus_Formula_Sheet.pdf',
    type: 'PDF',
    location: 'Internal Storage > Documents',
    sizeMb: 0.9,
    modifiedAt: DateTime(2026, 5, 17, 21, 40),
    isFavorite: true,
  ),
  FileItem(
    id: 'f5',
    name: 'Lab_Report_Week7.docx',
    type: 'DOC',
    location: 'Internal Storage > Documents > Assignments',
    sizeMb: 0.7,
    modifiedAt: DateTime(2026, 5, 16, 16, 30),
  ),
  FileItem(
    id: 'f6',
    name: 'Research_Sources.pdf',
    type: 'PDF',
    location: 'Internal Storage > Documents',
    sizeMb: 3.8,
    modifiedAt: DateTime(2026, 5, 15, 11, 0),
  ),
];
