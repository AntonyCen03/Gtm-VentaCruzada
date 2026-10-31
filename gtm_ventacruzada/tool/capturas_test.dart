// Capturas de revisión (docs/capturas/<carpeta>/) a tamaño exacto de teléfono.
// Chrome sin interfaz no baja de ~500 px de ancho, así que se usa el
// renderizador de pruebas de Flutter, que admite 360, 390 o 430 px.
//
//   flutter test tool/capturas_test.dart --update-goldens
//   flutter test tool/capturas_test.dart --update-goldens --dart-define=CARPETA=fase3 --dart-define=ANCHO=360

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtm_ventacruzada/app/app.dart';
import 'package:gtm_ventacruzada/datos/demo_store.dart';

import '../test/fuentes.dart';

const _carpeta = String.fromEnvironment('CARPETA', defaultValue: 'final');
const _ancho = int.fromEnvironment('ANCHO', defaultValue: 390);
const _alto = 844.0;

/// (archivo, ruta, desplazamientos verticales, texto a tocar antes de capturar).
/// Una captura por desplazamiento.
const _pantallas = <(String, String, List<double>, String?)>[
  ('p01_inicio_maria', '/inicio', [0.0], null),
  ('p02_inicio_carlos', '/inicio?perfil=carlos', [0.0], null),
  ('p03_anadir_directorio', '/mis-pagos/afiliar?perfil=carlos', [0.0], null),
  ('p04_resumen_semanal', '/resumen', [0.0], null),
  ('p05_wisi_whatsapp', '/wisi?perfil=carlos', [0.0], null),
  ('p06_mis_pagos', '/mis-pagos', [0.0], null),
  ('p07_semana_al_dia', '/mis-pagos/listo', [0.0], null),
  ('p08_tus_avisos', '/avisos', [0.0], null),
  ('a1_club', '/club', [0.0], null),
  ('a2_estacionar_pago', '/estacionar', [0.0], null),
  ('a3_salida', '/estacionar/listo', [0.0], null),
  ('menu_demo', '/inicio', [0.0], 'Menu'),
];

void main() {
  setUpAll(cargarOutfit);

  for (final (archivo, ruta, desplazamientos, tocar) in _pantallas) {
    testWidgets(archivo, (tester) async {
      // flutter_test pinta las sombras como bloques sólidos; aquí queremos verlas reales.
      debugDisableShadows = false;
      tester.view
        ..devicePixelRatio = 2
        ..physicalSize = Size(_ancho * 2.0, _alto * 2);
      addTearDown(tester.view.reset);

      // Los SVG se decodifican fuera del reloj falso de las pruebas.
      await tester.runAsync(() async {
        await tester.pumpWidget(AppPagoDirecto(store: DemoStore(), rutaInicial: ruta));
        await Future<void>.delayed(const Duration(milliseconds: 400));
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 400));
      });
      // Sin pumpAndSettle: los indicadores de carga giran sin fin.
      await tester.pump(const Duration(seconds: 1));
      if (tocar != null) {
        await tester.tap(find.text(tocar).last);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        // Respuestas con retraso simulado (Wisi «escribiendo…»).
        await tester.pump(const Duration(seconds: 1));
      }

      for (var i = 0; i < desplazamientos.length; i++) {
        if (desplazamientos[i] > 0) {
          tester.state<ScrollableState>(find.byType(Scrollable).last).position.jumpTo(desplazamientos[i]);
          await tester.pump(const Duration(milliseconds: 100));
        }
        final sufijo = desplazamientos.length > 1 ? '_${i + 1}' : '';
        await expectLater(
          find.byType(AppPagoDirecto),
          matchesGoldenFile('../docs/capturas/$_carpeta/$archivo${sufijo}_$_ancho.png'),
        );
      }
      debugDisableShadows = true;
    });
  }
}
