import 'package:blackout_silent_breach/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app renders splash screen', (tester) async {
    await tester.pumpWidget(const BlackoutApp());
    expect(find.text('BLACKOUT'), findsOneWidget);
  });
}
