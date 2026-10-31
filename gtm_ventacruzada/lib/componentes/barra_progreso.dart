import 'package:flutter/material.dart';

import '../tema/tokens.dart';

/// Barra de progreso del Club. Si se indica [desde], anima el avance una vez
/// (p. ej. 1.250 → 1.850 pts en P7).
class BarraProgresoPd extends StatelessWidget {
  const BarraProgresoPd({
    super.key,
    required this.valor,
    this.desde,
    this.pista = const Color(0x40FFFFFF),
    this.relleno = PdColor.superficie,
    this.alto = 8,
    this.etiqueta,
  });

  final double valor;
  final double? desde;
  final Color pista;
  final Color relleno;
  final double alto;
  final String? etiqueta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: etiqueta,
      value: '${(valor * 100).round()} %',
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: desde ?? valor, end: valor),
        duration: PdDuracion.de(context, PdDuracion.progreso),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => Container(
          height: alto,
          decoration: BoxDecoration(color: pista, borderRadius: BorderRadius.circular(PdRadio.pildora)),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: v.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(color: relleno, borderRadius: BorderRadius.circular(PdRadio.pildora)),
            ),
          ),
        ),
      ),
    );
  }
}
