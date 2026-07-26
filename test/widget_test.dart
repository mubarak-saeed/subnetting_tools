import 'package:flutter_test/flutter_test.dart';
import 'package:subnetting_tools/main.dart';

void main() {
  testWidgets('ThemeSwitcherApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ThemeSwitcherApp());
    await tester.pumpAndSettle();

    // Verify main title or icon is rendered
    expect(find.byType(ThemeSwitcherApp), findsOneWidget);
  });
}
