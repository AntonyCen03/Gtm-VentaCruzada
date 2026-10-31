import 'package:flutter/material.dart';

import '../tema/tokens.dart';
import 'presionable.dart';

/// Superficie blanca sobre el fondo gris. Se separa por tono, no por sombra.
class TarjetaPd extends StatelessWidget {
  const TarjetaPd({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(PdEspacio.l),
    this.color = PdColor.superficie,
    this.radio = PdRadio.tarjeta,
    this.onTap,
    this.etiqueta,
  });

  /// Variante oscura: Total por pagar, «Nunca mientras manejo», Club en P7.
  const TarjetaPd.oscura({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 18),
    this.radio = 22,
    this.onTap,
    this.etiqueta,
  }) : color = PdColor.tinta;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double radio;
  final VoidCallback? onTap;
  final String? etiqueta;

  @override
  Widget build(BuildContext context) {
    final caja = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radio)),
      child: color == PdColor.tinta
          ? DefaultTextStyle.merge(
              style: const TextStyle(color: PdColor.superficie),
              child: IconTheme.merge(
                data: const IconThemeData(color: PdColor.superficie),
                child: child,
              ),
            )
          : child,
    );
    if (onTap == null) return caja;
    return Presionable(onTap: onTap, etiqueta: etiqueta, radio: radio, escala: 0.98, child: caja);
  }
}

/// Encabezado de sección: título a la izquierda y, opcionalmente, un enlace o
/// una nota a la derecha («Ver todos», «1.ª vez: +100 pts»).
class TituloSeccion extends StatelessWidget {
  const TituloSeccion(this.texto, {super.key, this.derecha});

  final String texto;
  final Widget? derecha;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Semantics(header: true, child: Text(texto, style: PdTexto.titulo)),
        ),
        ?derecha,
      ],
    );
  }
}

/// Enlace de texto en rosa oscuro con área táctil de 44 px.
class EnlacePd extends StatelessWidget {
  const EnlacePd(this.texto, {super.key, required this.onTap});

  final String texto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: onTap,
      radio: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Align(
          widthFactor: 1,
          child: Text(
            texto,
            style: PdTexto.cuerpo.copyWith(fontWeight: FontWeight.w600, color: PdColor.acentoOscuro),
          ),
        ),
      ),
    );
  }
}
