import 'package:flutter_test/flutter_test.dart';
import 'package:my_app_incitech_ua/app/app.dart';

void main() {
  testWidgets('Muestra pantalla principal', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('CONTINUAR'), findsOneWidget);
    expect(find.text('InciTech UA'), findsOneWidget);
  });
}
