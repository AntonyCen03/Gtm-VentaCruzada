import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../componentes/presionable.dart';
import '../../datos/demo_store.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

/// P4 · Pantalla de bloqueo simulada con el único aviso de la semana. La
/// fecha y la hora salen de Tus avisos (P8); el texto, de los pagos pendientes.
class PantallaResumenSemanal extends StatelessWidget {
  const PantallaResumenSemanal({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final ajustes = store.perfil.ajustes;
    // Primer día elegido a partir del domingo 1 de noviembre (hoy en la demo).
    final dia = store.hoy.add(Duration(days: (ajustes.dia - store.hoy.weekday) % 7));
    final superior = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: GestureDetector(
        // Fuera de la notificación, un toque vuelve a la app (no hay botón atrás).
        onTap: () => context.canPop() ? context.pop() : context.go('/inicio'),
        child: Container(
          decoration: BoxDecoration(
            gradient: degradadoCss(
              170,
              const [Color(0xFF2A2940), Color(0xFF1C1B2E), Color(0xFF3A1A2E)],
              const [0, 0.55, 1],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.fromLTRB(0, superior + 90, 0, 24),
            children: [
              Text(
                '${diaSemanaCapital(dia)}, ${fechaLarga(dia)}',
                textAlign: TextAlign.center,
                style: letra(17, FontWeight.w500, PdColor.grisClaro),
              ),
              const SizedBox(height: 4),
              Text(
                horaReloj(ajustes.hora),
                textAlign: TextAlign.center,
                style: letra(86, FontWeight.w300, Colors.white, 1, 86 * -0.02),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ajustes.resumenSemanal && ajustes.enApp
                    ? const _Notificacion()
                    : Text(
                        'Tus avisos están en pausa. Puedes activarlos en Tus avisos.',
                        textAlign: TextAlign.center,
                        style: letra(14, FontWeight.w400, PdColor.grisClaro, 1.4),
                      ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Text(
                  'Un solo aviso por semana, el día y la hora que tú elegiste',
                  textAlign: TextAlign.center,
                  style: letra(12.5, FontWeight.w400, PdColor.grisClaro, 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Notificacion extends StatelessWidget {
  const _Notificacion();

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final pendientes = store.pendientes;
    final whatsapp = store.perfil.ajustes.whatsapp;

    String cuerpo;
    if (pendientes.isEmpty) {
      cuerpo = 'Esta semana no tienes vencimientos. Sigues al día con tu racha.';
    } else {
      final lista = pendientes.map((p) => '${p.empresa} (${diaSemana(p.vence)})').toList();
      final unidos = lista.length == 1
          ? lista.first
          : '${lista.sublist(0, lista.length - 1).join(', ')} y ${lista.last}';
      cuerpo =
          'Esta semana ${lista.length == 1 ? 'vence' : 'vencen'} $unidos. '
          '${lista.length == 1 ? 'Págalo' : 'Págalos'} aquí y ganas ${pts(store.puntosPendientes)} del Club.';
    }
    if (whatsapp) cuerpo += ' También te llega por WhatsApp con Wisi.';

    return Presionable(
      onTap: () => context.go('/mis-pagos'),
      escala: 0.98,
      radio: 22,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(22),
          boxShadow: sombraCss(10, 30, const Color.fromRGBO(0, 0, 0, 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: PdColor.rosaMarca, borderRadius: BorderRadius.circular(7)),
                  child: Text('pd', style: letra(12, FontWeight.w700, Colors.white)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('PAGODIRECTO', style: letra(13, FontWeight.w600, const Color(0xFF4A4959)))),
                Text('ahora', style: letra(12, FontWeight.w400, PdColor.textoSecundario)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Tu semana de pagos', style: letra(16, FontWeight.w700)),
            const SizedBox(height: 6),
            Text(cuerpo, style: letra(14, FontWeight.w400, const Color(0xFF2E2D40), 1.4)),
          ],
        ),
      ),
    );
  }
}
