import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tema/tokens.dart';
import 'boton.dart';
import 'icono.dart';
import 'presionable.dart';

/// Encabezado de pantalla interna: atrás, título centrado y una acción opcional.
class EncabezadoPd extends StatelessWidget {
  const EncabezadoPd({super.key, required this.titulo, this.alVolver, this.accion, this.conFondo = false});

  final String titulo;

  /// Por defecto vuelve atrás o, si no hay historial, al Inicio.
  final VoidCallback? alVolver;
  final Widget? accion;

  /// Botones en círculo blanco (Mis pagos) o solo el icono (Club, Avisos).
  final bool conFondo;

  @override
  Widget build(BuildContext context) {
    final superior = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(PdEspacio.margen - (conFondo ? 0 : 12), superior + 18, PdEspacio.margen, 8),
      child: Row(
        children: [
          BotonIconoPd(
            icono: Ico.atras,
            etiqueta: 'Volver',
            conFondo: conFondo,
            onPressed: alVolver ?? () => context.canPop() ? context.pop() : context.go('/inicio'),
          ),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: PdTexto.titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: 46, height: 46, child: accion),
        ],
      ),
    );
  }
}

/// Encabezado de Club, Estacionamiento y Tus avisos: flecha de 44 px sin fondo
/// y título centrado, con los márgenes de cada pantalla del mockup.
class EncabezadoSimple extends StatelessWidget {
  const EncabezadoSimple({
    super.key,
    required this.titulo,
    required this.tamano,
    required this.arriba,
    required this.abajo,
  });

  final String titulo;
  final double tamano;
  final double arriba;
  final double abajo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, arriba, 12, abajo),
      child: Row(
        children: [
          Presionable(
            onTap: () => context.canPop() ? context.pop() : context.go('/inicio'),
            etiqueta: 'Volver',
            radio: 22,
            child: const SizedBox(width: 44, height: 44, child: Center(child: IconoPd(Ico.atras, tamano: 22))),
          ),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(titulo, textAlign: TextAlign.center, style: letra(tamano, FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
