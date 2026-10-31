import 'package:flutter/material.dart';

import '../tema/tokens.dart';
import 'presionable.dart';

/// Interruptor en verde semántico (no en el acento de marca).
class InterruptorPd extends StatelessWidget {
  const InterruptorPd({super.key, required this.valor, required this.onCambio});

  final bool valor;
  final ValueChanged<bool>? onCambio;

  @override
  Widget build(BuildContext context) {
    final duracion = PdDuracion.de(context, PdDuracion.cambio);
    return ExcludeSemantics(
      child: AnimatedContainer(
        duration: duracion,
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: valor ? PdColor.exito : PdColor.interruptorApagado,
          borderRadius: BorderRadius.circular(PdRadio.pildora),
        ),
        child: AnimatedAlign(
          duration: duracion,
          curve: Curves.easeOutCubic,
          alignment: valor ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(color: PdColor.superficie, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

/// Fila de ajustes: toda la fila cambia el interruptor.
class FilaInterruptor extends StatelessWidget {
  const FilaInterruptor({
    super.key,
    required this.titulo,
    this.subtitulo,
    required this.valor,
    required this.onCambio,
    this.tituloFuerte = false,
    this.tamanoSubtitulo = 12.5,
  });

  final String titulo;
  final String? subtitulo;
  final bool valor;
  final ValueChanged<bool>? onCambio;
  final bool tituloFuerte;
  final double tamanoSubtitulo;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: onCambio == null ? null : () => onCambio!(!valor),
      alternado: valor,
      escala: 1,
      radio: PdRadio.campo,
      // El relleno queda dentro del área táctil: toda la fila (≥ 54 px) cambia el valor.
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(titulo, style: letra(15, tituloFuerte ? FontWeight.w600 : FontWeight.w400)),
                  if (subtitulo != null)
                    Text(subtitulo!, style: letra(tamanoSubtitulo, FontWeight.w400, PdColor.textoSecundario)),
                ],
              ),
            ),
            const SizedBox(width: PdEspacio.m),
            InterruptorPd(valor: valor, onCambio: onCambio),
          ],
        ),
      ),
    );
  }
}
