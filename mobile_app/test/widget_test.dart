import 'package:flutter_test/flutter_test.dart';

import 'package:lto_exam_reviewer/main.dart';

void main() {
  testWidgets('App boots to the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LtoReviewerApp());
    await tester.pump();

    expect(find.text('DriverLingo'), findsOneWidget);
  });
}
