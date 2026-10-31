import 'package:flutter/material.dart';

import '../tema/tokens.dart';
import 'presionable.dart';

enum EstiloSegmentado {
  /// Inicio | Club: carril gris, pulgar blanco con sombra suave.
  claro,

  /// Pendientes | Programados | Pagados: carril blanco, pulgar rosa.
  acento,
}

/// Control segmentado con pulgar que se desliza entre opciones.
class SegmentadoPd extends StatelessWidget {
  const SegmentadoPd({
    super.key,
    required this.opciones,
    required this.seleccion,
    required this.onCambio,
    this.estilo = EstiloSegmentado.claro,
    this.etiqueta,
  });

  final List<String> opciones;
  final int seleccion;
  final ValueChanged<int> onCambio;
  final EstiloSegmentado estilo;
  final String? etiqueta;

  @override
  Widget build(BuildContext context) {
    final claro = estilo == EstiloSegmentado.claro;
    final duracion = PdDuracion.de(context, PdDuracion.cambio);

    TextStyle estiloDe(bool activo) => claro
        ? letra(14.5, activo ? FontWeight.w700 : FontWeight.w600, activo ? PdColor.tinta : PdColor.textoNeutro)
        : letra(14, activo ? FontWeight.w600 : FontWeight.w500, activo ? PdColor.superficie : PdColor.tinta);

    return Semantics(
      label: etiqueta,
      container: true,
      child: Container(
        height: claro ? 44 : 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: claro ? PdColor.superficieHundida : PdColor.superficie,
          borderRadius: BorderRadius.circular(PdRadio.pildora),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final ancho = c.maxWidth / opciones.length;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: duracion,
                  curve: Curves.easeOutCubic,
                  left: ancho * seleccion,
                  top: 0,
                  bottom: 0,
                  width: ancho,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: claro ? PdColor.superficie : PdColor.acentoVivo,
                      borderRadius: BorderRadius.circular(PdRadio.pildora),
                      boxShadow: claro ? sombraCss(2, 6, const Color.fromRGBO(28, 27, 46, 0.08)) : null,
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < opciones.length; i++)
                      Expanded(
                        child: Presionable(
                          onTap: i == seleccion ? () {} : () => onCambio(i),
                          seleccionado: i == seleccion,
                          radio: PdRadio.pildora,
                          escala: 1,
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: duracion,
                              style: estiloDe(i == seleccion),
                              child: Text(opciones[i], maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
