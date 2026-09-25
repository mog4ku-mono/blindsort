import 'package:flutter/material.dart';

/// Badge colour per file extension. The mockup gives each type its own
/// swatch so a low-vision user can still tell PDFs from slides at a glance
/// before TalkBack reads the name.
const Map<String, Color> kFileTypeColors = {
  'PDF': Color(0xFFD32F2F),
  'PPT': Color(0xFFF57C00),
  'PPTX': Color(0xFFF57C00),
  'DOC': Color(0xFF1976D2),
  'DOCX': Color(0xFF1976D2),
  'PNG': Color(0xFF43A047),
  'JPG': Color(0xFF43A047),
  'JPEG': Color(0xFF43A047),
  'MKV': Color(0xFF512DA8),
  'MP4': Color(0xFF7B1FA2),
  'MP3': Color(0xFFC2185B),
};

/// Fallback when the extension is not in the map.
const Color kDefaultTypeColor = Color(0xFF546E7A);
