import 'package:flutter_test/flutter_test.dart';
import 'package:khedma/app.dart';
<<<<<<< HEAD
import 'package:khedma/features/auth/presentation/screens/login_screen.dart';
=======
>>>>>>> 81082e6e2591ca1637ec3975c040b5221486732a

void main() {
  testWidgets('Khedma app test', (WidgetTester tester) async {
    await tester.pumpWidget(const KhedmaApp());

<<<<<<< HEAD
    expect(find.byType(LoginScreen), findsOneWidget);
=======
    expect(find.byType(KhedmaApp), findsOneWidget);
>>>>>>> 81082e6e2591ca1637ec3975c040b5221486732a
  });
}
