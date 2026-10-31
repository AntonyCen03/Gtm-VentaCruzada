import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtm_ventacruzada/app/app.dart';
import 'package:gtm_ventacruzada/datos/datos_demo.dart';
import 'package:gtm_ventacruzada/datos/demo_store.dart';
import 'package:gtm_ventacruzada/datos/modelos.dart';
import 'package:gtm_ventacruzada/tema/formato.dart';

import 'fuentes.dart';

void main() {
  setUpAll(cargarOutfit);

  group('formato', () {
    test('bolívares con miles y decimales', () {
      expect(bs(124050), 'Bs 1.240,50');
      expect(bs(2543000), 'Bs 25.430,00');
      expect(bs(0), 'Bs 0,00');
      expect(pts(600), '+600 pts');
      expect(miles(1850), '1.850');
    });

    test('horas en español de Venezuela', () {
      expect(hora(const TimeOfDay(hour: 18, minute: 0)), '6:00\u00A0p.\u00A0m.');
      expect(hora(const TimeOfDay(hour: 8, minute: 0)), '8:00\u00A0a.\u00A0m.');
      expect(hora(const TimeOfDay(hour: 12, minute: 0)), '12:00\u00A0m.');
    });
  });

  group('DemoStore: las cifras cuadran (§10)', () {
    test('total y puntos de María', () {
      final s = DemoStore();
      expect(s.totalPendiente, 187040);
      expect(s.puntosPendientes, 600);
      expect(s.puntosFaltantes, 750);
      expect(s.totalEstacionamiento, 165547);
    });

    test('pagar todo sube la racha y activa el premio', () {
      final s = DemoStore();
      final r = s.pagar(s.pendientes.map((p) => p.id), MetodoPago.pagoDirecto);
      expect(r.totalCentimos, 187040);
      expect(s.perfil.puntos, 1850);
      expect(s.puntosFaltantes, 150);
      expect(s.perfil.racha, 4);
      expect(s.totalEstacionamiento, 124160);
      expect(s.misiones.any((m) => m.accion == AccionMision.pagarServicio), isFalse);
    });

    test('el primer servicio de Carlos da +200 pts', () {
      final s = DemoStore()..cambiarPerfil('carlos');
      final antes = s.perfil.puntos;
      expect(s.primerServicio, isTrue);
      s.afiliar(facturaDe('Corpoelec', '3001 4582 77'));
      expect(s.perfil.puntos, antes + 200);
      expect(s.primerServicio, isFalse);
    });
  });

  Future<DemoStore> abrir(WidgetTester tester, {String ruta = '/inicio'}) async {
    tester.view
      ..devicePixelRatio = 2
      ..physicalSize = const Size(390 * 2, 844 * 2);
    addTearDown(tester.view.reset);
    final store = DemoStore();
    await tester.pumpWidget(AppPagoDirecto(store: store, rutaInicial: ruta));
    await tester.pumpAndSettle();
    return store;
  }

  Future<void> tocar(WidgetTester tester, String texto) async {
    await tester.tap(find.text(texto).last);
    await tester.pumpAndSettle();
  }

  testWidgets('María: Inicio → Mis pagos → pagar → semana al día (P1, P6, P7)', (tester) async {
    final store = await abrir(tester);
    expect(find.text('@maria'), findsOneWidget);
    expect(find.text('Bs 25.430,00'), findsOneWidget);
    expect(find.text('Vence jue'), findsOneWidget);
    expect(find.text('Renueva tu RCV aquí'), findsOneWidget);

    await tocar(tester, 'Ver todos');
    expect(find.text('Bs. 1.870,40'), findsOneWidget);
    expect(find.text('2 pagos vencen esta semana'), findsOneWidget);
    expect(find.text('Seguro RCV · AB123CD'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp('^Corpoelec')));
    await tester.pumpAndSettle();
    expect(find.text('Tu semana está al día'), findsOneWidget);
    expect(find.text('Pagaste 2 servicios en un toque'), findsOneWidget);
    expect(
      find.text('1.850 pts · te faltan 150 para el siguiente nivel. Tu racha suma una semana al día.'),
      findsOneWidget,
    );

    await tocar(tester, 'Volver al inicio');
    expect(store.perfil.racha, 4);
    expect(find.bySemanticsLabel(RegExp('Racha de 4 semanas al día')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Estacionar con el premio de la racha y salida sin avisos (A2, A3)', (tester) async {
    final store = await abrir(tester);
    store.pagar(store.pendientes.map((p) => p.id), MetodoPago.pagoDirecto);
    await tester.pumpAndSettle();

    await tocar(tester, 'Estacionar');
    expect(find.text('Servicio PagoDirecto · premio de tu racha'), findsOneWidget);
    expect(find.text('Bs 1.241,60'), findsWidgets);
    await tocar(tester, 'Confirmar');
    expect(find.text('¡Listo, María!'), findsOneWidget);
    expect(store.manejando, isTrue);
    await tocar(tester, 'Salir del estacionamiento');
    expect(find.text('@maria'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Carlos registra su primer servicio y gana +200 pts (P2, P3)', (tester) async {
    final store = await abrir(tester, ruta: '/inicio?perfil=carlos');
    expect(find.text('@carlos'), findsOneWidget);
    expect(find.text('+200 pts'), findsOneWidget);
    expect(find.text('Verifica tu vehículo'), findsOneWidget);

    await tocar(tester, 'Registra tu servicio');
    expect(find.text('Añadir directorio'), findsOneWidget);
    expect(find.text('Encontramos tu factura:', findRichText: true), findsNothing);
    expect(find.textContaining('Encontramos tu factura:', findRichText: true), findsOneWidget);
    await tocar(tester, 'Listo');
    expect(find.text('Luz de la casa'), findsOneWidget);
    expect(store.perfil.puntos, 450);
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Wisi engancha con el premio, sin montos, y «Más información» abre el Club (P5)', (tester) async {
    final store = await abrir(tester, ruta: '/wisi?perfil=carlos');
    expect(
      find.text(
        '¡Hola, Carlos! ¿Sabías que con 1.000 pts puedes canjear un boleto para el concierto de Karol G?',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Bs', findRichText: true), findsNothing);

    await tester.enterText(find.byType(TextField), 'Hola');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(store.perfil.chat.length, 3);

    await tocar(tester, 'Más información');
    expect(find.text('Misiones para ti'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el resumen semanal sigue el día y la hora de Tus avisos (P4, P8)', (tester) async {
    final store = await abrir(tester, ruta: '/resumen');
    expect(find.text('Domingo, 1 de noviembre'), findsOneWidget);
    expect(find.text('6:00'), findsOneWidget);
    expect(
      find.text(
        'Esta semana vencen Corpoelec (jueves) y Movistar (martes). Págalos aquí y ganas +600 pts del Club. '
        'También te llega por WhatsApp con Wisi.',
      ),
      findsOneWidget,
    );
    store.cambiarAjustes((a) {
      a.dia = DateTime.monday;
      a.hora = const TimeOfDay(hour: 8, minute: 0);
    });
    await tester.pumpAndSettle();
    expect(find.text('Lunes, 2 de noviembre'), findsOneWidget);
    expect(find.text('8:00'), findsOneWidget);

    await tocar(tester, 'Tu semana de pagos');
    expect(find.text('Bs. 1.870,40'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cada pantalla se dibuja sin desbordes a 360, 390 y 430 px', (tester) async {
    for (final ancho in [360.0, 390.0, 430.0]) {
      for (final ruta in [
        '/inicio',
        '/inicio?perfil=carlos',
        '/mis-pagos',
        '/mis-pagos/afiliar?perfil=carlos',
        '/mis-pagos/listo',
        '/club',
        '/avisos',
        '/resumen',
        '/wisi',
        '/estacionar',
        '/estacionar/listo',
      ]) {
        tester.view
          ..devicePixelRatio = 2
          ..physicalSize = Size(ancho * 2, 844 * 2);
        await tester.pumpWidget(AppPagoDirecto(key: UniqueKey(), store: DemoStore(), rutaInicial: ruta));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$ruta a $ancho px');
      }
    }
    tester.view.reset();
  });
}
