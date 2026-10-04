// Prueba básica de la pantalla principal de la demo.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profiler_app/main.dart';

void main() {
  testWidgets('Muestra los 4 casos del profiler', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfilerApp());

    // Verifica que se rendericen los títulos de los 4 casos.
    expect(find.text('Caso 1'), findsOneWidget);
    expect(find.text('Caso 2'), findsOneWidget);
    expect(find.text('Caso 3'), findsOneWidget);
    expect(find.text('Caso 4'), findsOneWidget);

    // Verifica que exista un botón accionable por cada caso.
    expect(find.byIcon(Icons.arrow_forward), findsNWidgets(4));
  });
}
