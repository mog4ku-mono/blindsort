import 'package:flutter/material.dart';

/// A colour pair for one category tile. The tint is the tile background, the
/// foreground is the icon and label. Distinct colours per category so the
/// four tiles are told apart without relying on position.
class CategoryColorPair {
  final Color tint;
  final Color foreground;
  const CategoryColorPair(this.tint, this.foreground);
}

const CategoryColorPair kDocumentsColors = CategoryColorPair(
  Color(0xFFE3F2FD),
  Color(0xFF1565C0),
);
const CategoryColorPair kImagesColors = CategoryColorPair(
  Color(0xFFE8F5E9),
  Color(0xFF2E7D32),
);
const CategoryColorPair kVideosColors = CategoryColorPair(
  Color(0xFFEDE7F6),
  Color(0xFF5E35B1),
);
const CategoryColorPair kAudioColors = CategoryColorPair(
  Color(0xFFFFF3E0),
  Color(0xFFE65100),
);
