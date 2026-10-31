import 'package:flutter/material.dart';

import '../tema/tokens.dart';

const _velo = Color(0x7A14141E);

/// Contenido de una hoja inferior: asa, título opcional y cuerpo.
/// Sube con el teclado para que el campo activo siga visible.
class HojaPd extends StatelessWidget {
  const HojaPd({super.key, this.titulo, required this.child});

  final String? titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final teclado = MediaQuery.viewInsetsOf(context).bottom;
    final inferior = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: teclado),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: PdColor.superficie,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(PdEspacio.xl, 14, PdEspacio.xl, PdEspacio.xl + inferior),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: PdColor.superficieHundida,
                  borderRadius: BorderRadius.circular(PdRadio.pildora),
                ),
              ),
            ),
            if (titulo != null) ...[
              const SizedBox(height: PdEspacio.l),
              Semantics(header: true, child: Text(titulo!, style: PdTexto.titulo.copyWith(fontSize: 22))),
            ],
            const SizedBox(height: PdEspacio.l),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// Hoja inferior fuera del enrutador (opciones de un selector, menú de demo).
Future<T?> mostrarHojaPd<T>(BuildContext context, WidgetBuilder builder) {
  return showModalBottomSheet<T>(
    context: context,
    // Por encima de la barra inferior, que vive fuera del navegador anidado.
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: _velo,
    elevation: 0,
    sheetAnimationStyle: AnimationStyle(duration: PdDuracion.de(context, PdDuracion.hoja)),
    builder: builder,
  );
}

/// Página del enrutador que se muestra como hoja inferior (P3, Confirmar pago).
class PaginaHoja<T> extends Page<T> {
  const PaginaHoja({super.key, super.name, required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      builder: (_) => child,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      modalBarrierColor: _velo,
      elevation: 0,
      sheetAnimationStyle: AnimationStyle(duration: PdDuracion.de(context, PdDuracion.hoja)),
    );
  }
}
