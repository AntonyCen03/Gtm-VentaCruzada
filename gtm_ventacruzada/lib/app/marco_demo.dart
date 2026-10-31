import 'dart:math' as math;

import 'package:flutter/material.dart';

/// En pantallas anchas (proyector, escritorio) muestra la app dentro de un
/// teléfono de 390×844. En el móvil no hace nada.
class MarcoDemo extends StatelessWidget {
  const MarcoDemo({super.key, required this.child});

  final Widget child;

  static const _ancho = 390.0;
  static const _alto = 844.0;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (mq.size.width < 600) return child;

    final alto = math.min(_alto, mq.size.height - 48);
    return ColoredBox(
      color: const Color(0xFFE4E4EA),
      child: Center(
        child: Container(
          width: _ancho + 20,
          height: alto + 20,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF15141F), borderRadius: BorderRadius.circular(54)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(44),
            child: MediaQuery(
              data: mq.copyWith(size: Size(_ancho, alto), padding: EdgeInsets.zero, viewPadding: EdgeInsets.zero),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
