import 'package:flutter/material.dart';

import '../datos/modelos.dart';
import '../tema/formato.dart';
import '../tema/tokens.dart';
import 'icono.dart';
import 'pastilla.dart';
import 'presionable.dart';

/// Fila de un pago en Mis pagos: empresa, referencia y vencimiento a la
/// izquierda; monto y puntos alineados a la derecha con cifras tabulares.
class FilaPago extends StatelessWidget {
  const FilaPago({super.key, required this.pago, required this.hoy, this.onTap});

  final Pago pago;
  final DateTime hoy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pagado = pago.estado == EstadoPago.pagado;
    final vence = pagado ? 'Pagado' : venceLargo(pago.vence, hoy);
    final caja = Container(
      padding: const EdgeInsets.fromLTRB(PdEspacio.l, 14, PdEspacio.m, 14),
      decoration: BoxDecoration(color: PdColor.superficie, borderRadius: BorderRadius.circular(PdRadio.tarjeta)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pago.alias ?? pago.empresa, style: PdTexto.cuerpoFuerte.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  pago.alias == null ? pago.referencia : '${pago.empresa} · ${pago.referencia}',
                  style: PdTexto.meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                PastillaPd(vence, tipo: pago.prioritario && !pagado ? TipoPastilla.urgente : TipoPastilla.neutra),
              ],
            ),
          ),
          const SizedBox(width: PdEspacio.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                bs(pago.centimos),
                style: PdTexto.cuerpoFuerte.copyWith(fontWeight: FontWeight.w700).merge(PdTexto.cifras),
              ),
              const SizedBox(height: 2),
              Text(
                pagado ? 'Ganaste ${pts(pago.puntos, signo: false)}' : pts(pago.puntos),
                style: PdTexto.meta
                    .copyWith(fontWeight: FontWeight.w600, color: PdColor.acentoOscuro)
                    .merge(PdTexto.cifras),
              ),
            ],
          ),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            const IconoPd(Ico.adelante, tamano: 18, color: PdColor.iconoApagado),
          ],
        ],
      ),
    );

    return Semantics(
      label:
          '${pago.empresa}, ${bs(pago.centimos)}, ${vence.toLowerCase()}, '
          '${pagado ? 'ganaste' : 'ganas'} ${pago.puntos} puntos',
      excludeSemantics: true,
      button: onTap != null,
      child: onTap == null ? caja : Presionable(onTap: onTap, escala: 0.98, child: caja),
    );
  }
}
