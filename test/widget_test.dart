import 'package:flutter_test/flutter_test.dart';
import 'package:khedma/app.dart';
import 'package:khedma/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('Khedma app test', (WidgetTester tester) async {
    await tester.pumpWidget(const KhedmaApp());

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
