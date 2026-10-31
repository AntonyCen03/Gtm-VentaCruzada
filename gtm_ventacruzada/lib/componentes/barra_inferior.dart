import 'package:flutter/material.dart';

import '../tema/tokens.dart';
import 'icono.dart';
import 'presionable.dart';

enum DestinoBarra {
  inicio('Home', Ico.inicio),
  movimientos('Movimientos', Ico.movimientos),
  estacionar('Estacionar', Ico.estacionar),
  misPagos('Mis pagos', Ico.misPagos),
  menu('Menu', Ico.menu);

  const DestinoBarra(this.etiqueta, this.icono);
  final String etiqueta;
  final Ico icono;
}

/// Barra inferior de 5 destinos con el botón rosado de Estacionar elevado.
class BarraInferiorPd extends StatelessWidget {
  const BarraInferiorPd({super.key, required this.actual, required this.onSeleccion});

  final DestinoBarra? actual;
  final ValueChanged<DestinoBarra> onSeleccion;

  static const _alto = 77.0;
  static const _elevacion = 30.0;

  @override
  Widget build(BuildContext context) {
    final inferior = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: _elevacion + _alto + inferior,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _alto + inferior,
            child: Container(
              padding: EdgeInsets.fromLTRB(6, 12, 6, 20 + inferior),
              decoration: BoxDecoration(
                color: PdColor.superficie,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                boxShadow: sombraCss(-6, 20, const Color.fromRGBO(28, 27, 46, 0.07)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final d in DestinoBarra.values)
                    Expanded(
                      child: d == DestinoBarra.estacionar
                          ? const SizedBox()
                          : _Destino(destino: d, activo: d == actual, onTap: () => onSeleccion(d)),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Presionable(
                onTap: () => onSeleccion(DestinoBarra.estacionar),
                radio: 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        color: PdColor.acento,
                        shape: BoxShape.circle,
                        border: Border.all(color: PdColor.superficie, width: 4),
                        boxShadow: sombraCss(8, 18, const Color.fromRGBO(214, 48, 91, 0.35)),
                      ),
                      alignment: Alignment.center,
                      child: const IconoPd(Ico.estacionar, tamano: 28, color: PdColor.superficie),
                    ),
                    const SizedBox(height: 4),
                    Text(DestinoBarra.estacionar.etiqueta, style: letra(12, FontWeight.w700, PdColor.acento)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Destino extends StatelessWidget {
  const _Destino({required this.destino, required this.activo, required this.onTap});

  final DestinoBarra destino;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = activo ? PdColor.acento : PdColor.textoSecundario;
    return Presionable(
      onTap: onTap,
      seleccionado: activo,
      radio: 12,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconoPd(destino.icono, tamano: 24, color: color),
            const SizedBox(height: 4),
            // A 360 px «Movimientos» no cabe a 12 px: se reduce un poco en vez de chocar.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  destino.etiqueta,
                  maxLines: 1,
                  style: letra(12, activo ? FontWeight.w600 : FontWeight.w500, color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
