import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../componentes/barra_inferior.dart';
import '../componentes/hoja_inferior.dart';
import '../datos/demo_store.dart';
import '../pantallas/avisos/pantalla_avisos.dart';
import '../pantallas/catalogo/pantalla_catalogo.dart';
import '../pantallas/club/pantalla_club.dart';
import '../pantallas/estacionar/pantalla_estacionar.dart';
import '../pantallas/estacionar/pantalla_salida.dart';
import '../pantallas/inicio/pantalla_inicio.dart';
import '../pantallas/mis_pagos/hoja_afiliar.dart';
import '../pantallas/mis_pagos/pantalla_mis_pagos.dart';
import '../pantallas/mis_pagos/pantalla_semana_al_dia.dart';
import '../pantallas/resumen_semanal/pantalla_resumen_semanal.dart';
import '../pantallas/wisi/pantalla_wisi.dart';
import 'avisos_demo.dart';
import 'menu_demo.dart';

/// Mapa de navegación de docs/PLAN_UI.md §4. Cada pantalla tiene su ruta para
/// poder enlazarla directamente en la demo y en las capturas
/// (p. ej. `/#/mis-pagos?perfil=carlos`).
GoRouter crearRutas(DemoStore store, {String rutaInicial = '/inicio'}) {
  final raiz = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: raiz,
    initialLocation: rutaInicial,
    redirect: (context, state) {
      final perfil = state.uri.queryParameters['perfil'];
      if (perfil != null) store.cambiarPerfil(perfil, notificar: false);
      return state.uri.path == '/' ? '/inicio' : null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => ContenedorPrincipal(ruta: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/inicio',
            pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const PantallaInicio()),
          ),
          GoRoute(
            path: '/mis-pagos',
            pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const PantallaMisPagos()),
            routes: [
              GoRoute(
                path: 'afiliar',
                parentNavigatorKey: raiz,
                pageBuilder: (context, state) => PaginaHoja(key: state.pageKey, child: const HojaAfiliar()),
              ),
              GoRoute(
                path: 'listo',
                parentNavigatorKey: raiz,
                builder: (context, state) => const PantallaSemanaAlDia(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/club', builder: (context, state) => const PantallaClub()),
      GoRoute(path: '/avisos', builder: (context, state) => const PantallaAvisos()),
      GoRoute(path: '/resumen', builder: (context, state) => const PantallaResumenSemanal()),
      GoRoute(path: '/wisi', builder: (context, state) => const PantallaWisi()),
      GoRoute(
        path: '/estacionar',
        builder: (context, state) => const PantallaEstacionar(),
        routes: [GoRoute(path: 'listo', builder: (context, state) => const PantallaSalida())],
      ),
      GoRoute(path: '/catalogo', builder: (context, state) => const PantallaCatalogo()),
    ],
  );
}

/// Inicio y Mis pagos comparten la barra inferior. El resto de pantallas son
/// a pantalla completa, como en el mockup.
class ContenedorPrincipal extends StatelessWidget {
  const ContenedorPrincipal({super.key, required this.ruta, required this.child});

  final String ruta;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final actual = ruta.startsWith('/mis-pagos') ? DestinoBarra.misPagos : DestinoBarra.inicio;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: child,
      bottomNavigationBar: BarraInferiorPd(
        actual: actual,
        onSeleccion: (d) => switch (d) {
          DestinoBarra.inicio => context.go('/inicio'),
          DestinoBarra.misPagos => context.go('/mis-pagos'),
          DestinoBarra.estacionar => context.push('/estacionar'),
          DestinoBarra.movimientos => avisoFueraDeDemo(context, 'Movimientos'),
          DestinoBarra.menu => mostrarMenuDemo(context),
        },
      ),
    );
  }
}
