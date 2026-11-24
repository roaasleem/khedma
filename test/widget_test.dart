import 'package:flutter_test/flutter_test.dart';
import 'package:khedma/app.dart';
import 'package:khedma/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('Khedma app test', (WidgetTester tester) async {
    await tester.pumpWidget(const KhedmaApp());

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
