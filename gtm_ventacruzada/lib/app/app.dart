import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../datos/demo_store.dart';
import '../tema/tema.dart';
import 'marco_demo.dart';
import 'rutas.dart';

class AppPagoDirecto extends StatefulWidget {
  const AppPagoDirecto({super.key, this.store, this.rutaInicial = '/inicio'});

  /// Inyectables en las pruebas y en las capturas.
  final DemoStore? store;
  final String rutaInicial;

  @override
  State<AppPagoDirecto> createState() => _AppPagoDirectoState();
}

class _AppPagoDirectoState extends State<AppPagoDirecto> {
  late final DemoStore _store = widget.store ?? DemoStore();
  late final GoRouter _rutas = crearRutas(_store, rutaInicial: widget.rutaInicial);

  @override
  void dispose() {
    _rutas.dispose();
    if (widget.store == null) _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Demo(
      store: _store,
      child: MaterialApp.router(
        title: 'PagoDirecto',
        debugShowCheckedModeBanner: false,
        theme: temaPagoDirecto(),
        locale: const Locale('es', 'VE'),
        supportedLocales: const [Locale('es', 'VE'), Locale('es')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: _rutas,
        builder: (context, child) => MarcoDemo(child: child!),
      ),
    );
  }
}
