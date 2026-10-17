// Prueba básica: la app abre en el Login y navega al Menú
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techstore_app/main.dart';

void main() {
  testWidgets('Login -> Menú con credenciales demo', (tester) async {
    await tester.pumpWidget(const TechStoreApp());
    expect(find.text('Iniciar Sesión'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'admin@techstore.com');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Menú'), findsOneWidget);
  });
}
