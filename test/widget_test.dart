import 'package:blindsort/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home Dashboard shows the app title and recent files', (
    tester,
  ) async {
    await tester.pumpWidget(const BlindSortApp());

    expect(find.text('BlindSort'), findsOneWidget);
    expect(find.text('Recent Files'), findsOneWidget);
    expect(find.text('Lecture_3_Database.pdf'), findsOneWidget);
  });
}
