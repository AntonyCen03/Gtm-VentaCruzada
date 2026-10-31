import 'package:flutter/material.dart';

import '../tema/tokens.dart';
import 'icono.dart';
import 'presionable.dart';

const colorBurbujaPropia = Color(0xFFDDF3E2);
const colorFondoChat = Color(0xFFECEEF1);
const _azulLeido = Color(0xFF3B82F6);

/// Burbuja de la conversación simulada con Wisi (P5).
class BurbujaChat extends StatelessWidget {
  const BurbujaChat({super.key, required this.child, required this.hora, this.propia = false, this.leido = true});

  final Widget child;
  final String hora;
  final bool propia;
  final bool leido;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: propia ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: propia ? 260 : 300),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
          decoration: BoxDecoration(
            color: propia ? colorBurbujaPropia : PdColor.superficie,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(propia ? 18 : 4),
              topRight: Radius.circular(propia ? 4 : 18),
              bottomLeft: const Radius.circular(18),
              bottomRight: const Radius.circular(18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTextStyle.merge(style: PdTexto.cuerpo.copyWith(fontSize: 15), child: child),
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(hora, style: PdTexto.meta.copyWith(fontSize: 11)),
                    if (propia) ...[
                      const SizedBox(width: 4),
                      IconoPd(Ico.dobleCheck, tamano: 10, color: leido ? _azulLeido : PdColor.iconoApagado),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Respuesta rápida bajo un mensaje de Wisi.
class RespuestaRapida extends StatelessWidget {
  const RespuestaRapida({super.key, required this.texto, required this.onTap, this.icono});

  final String texto;
  final VoidCallback? onTap;
  final Ico? icono;

  @override
  Widget build(BuildContext context) {
    final color = onTap == null ? PdColor.iconoApagado : PdColor.exitoTexto;
    return Presionable(
      onTap: onTap,
      radio: 14,
      escala: 0.98,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: PdColor.superficie, borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icono != null) ...[IconoPd(icono!, tamano: 16, color: color), const SizedBox(width: 6)],
            Text(texto, style: PdTexto.cuerpoFuerte.copyWith(fontSize: 15, color: color)),
          ],
        ),
      ),
    );
  }
}
