import 'package:flutter/material.dart';

import '../tema/tokens.dart';

enum TipoPastilla {
  /// Vence pronto o puntos por ganar: rosa pálido con texto rosa oscuro.
  urgente(PdColor.acentoPalido, PdColor.acentoOscuro),

  /// Vencimiento sin prisa.
  neutra(PdColor.neutroPalido, PdColor.textoNeutro),

  /// Puntos ganados y estados «siempre activo» sobre fondo oscuro.
  lima(PdColor.lima, PdColor.tinta),

  /// Mensaje sobre tarjeta oscura.
  sobreOscuro(Color(0x1FFFFFFF), PdColor.superficie);

  const TipoPastilla(this.fondo, this.texto);
  final Color fondo;
  final Color texto;
}

/// Píldora de estado. Mínimo 11 px; nunca en mayúsculas espaciadas.
class PastillaPd extends StatelessWidget {
  const PastillaPd(this.texto, {super.key, this.tipo = TipoPastilla.urgente, this.grande = false}) : contenido = null;

  /// Para frases con un tramo destacado: «Págalos aquí y ganas **+600 pts** del Club».
  const PastillaPd.rica(TextSpan this.contenido, {super.key, this.tipo = TipoPastilla.sobreOscuro, this.grande = true})
    : texto = '';

  final String texto;
  final TextSpan? contenido;
  final TipoPastilla tipo;
  final bool grande;

  @override
  Widget build(BuildContext context) {
    final estilo = PdTexto.pastilla.copyWith(
      color: tipo.texto,
      fontSize: grande ? 12.5 : 11,
      fontWeight: grande ? FontWeight.w600 : FontWeight.w700,
      fontFeatures: PdTexto.cifras.fontFeatures,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: grande ? 10 : 8, vertical: grande ? 4 : 2),
      decoration: BoxDecoration(color: tipo.fondo, borderRadius: BorderRadius.circular(PdRadio.pildora)),
      child: contenido == null ? Text(texto, style: estilo, maxLines: 1) : Text.rich(contenido!, style: estilo),
    );
  }
}

/// Insignia pequeña que se monta sobre la esquina de otro elemento («+100»).
class InsigniaPd extends StatelessWidget {
  const InsigniaPd(this.texto, {super.key, this.borde = PdColor.fondo});

  final String texto;
  final Color borde;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: PdColor.acentoPalido,
        borderRadius: BorderRadius.circular(PdRadio.pildora),
        border: Border.all(color: borde, width: 2),
      ),
      child: Text(texto, style: PdTexto.pastilla.copyWith(fontFeatures: PdTexto.cifras.fontFeatures)),
    );
  }
}
