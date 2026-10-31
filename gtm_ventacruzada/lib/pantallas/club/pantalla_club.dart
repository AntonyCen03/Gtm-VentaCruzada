import 'package:flutter/material.dart';

import '../../app/avisos_demo.dart';
import '../../componentes/barra_progreso.dart';
import '../../componentes/encabezado.dart';
import '../../componentes/icono.dart';
import '../../componentes/presionable.dart';
import '../../datos/datos_demo.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';
import '../inicio/pantalla_inicio.dart';
import 'capsula_sorpresa.dart';

final _sombraTarjeta = sombraCss(4, 14, const Color.fromRGBO(28, 27, 46, 0.06));

/// Colores de icono de cada misión, como en el mockup.
Color _colorMision(Mision m) => switch (m.accion) {
  AccionMision.pagarServicio => const Color(0xFFE07A26),
  AccionMision.renovarRcv => const Color(0xFF6343B5),
  AccionMision.verificarVehiculo => PdColor.tinta,
};

/// A1 · Club PagoDirecto: nivel, racha, misiones y canje.
class PantallaClub extends StatelessWidget {
  const PantallaClub({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final perfil = store.perfil;
    final superior = MediaQuery.paddingOf(context).top;
    final inferior = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: PdColor.fondo,
      body: Column(
        children: [
          EncabezadoSimple(titulo: 'Club PagoDirecto', tamano: 19, arriba: superior + 16, abajo: 6),
          Expanded(
            child: ListView(
              clipBehavior: Clip.none,
              padding: EdgeInsets.fromLTRB(18, 6, 18, inferior + 18),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: PdColor.degradadoSaldo,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: sombraCss(8, 22, const Color.fromRGBO(194, 38, 90, 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  perfil.nivel,
                                  style: letra(14, FontWeight.w400, Colors.white.withValues(alpha: 0.9)),
                                ),
                                Text('${miles(perfil.puntos)} pts', style: letra(30, FontWeight.w700, Colors.white)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(PdRadio.pildora),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const IconoPd(Ico.rachaLinea, tamano: 16, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  '${perfil.racha} ${perfil.racha == 1 ? 'semana' : 'semanas'} al día',
                                  style: letra(13, FontWeight.w600, Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      BarraProgresoPd(valor: store.progresoNivel, etiqueta: 'Progreso del nivel'),
                      const SizedBox(height: 12),
                      Text(
                        store.puntosFaltantes == 0
                            ? '¡Alcanzaste el siguiente nivel!'
                            : 'Te faltan ${miles(store.puntosFaltantes)} pts para el siguiente nivel',
                        style: letra(13, FontWeight.w400, Colors.white.withValues(alpha: 0.95)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text('Misiones para ti', style: letra(19, FontWeight.w700)),
                for (final (i, m) in store.misiones.indexed) ...[
                  SizedBox(height: i == 0 ? 14 : 10),
                  _Mision(mision: m),
                ],
                if (store.misiones.isEmpty) ...[
                  const SizedBox(height: 10),
                  Text('Completaste todas tus misiones.', style: letra(14, FontWeight.w400, PdColor.textoSecundario)),
                ],
                const SizedBox(height: 14),
                Text('Canjea tus puntos', style: letra(19, FontWeight.w700)),
                const SizedBox(height: 14),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (i, c) in canjesDemo.indexed) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(child: _Canje(canje: c)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const TarjetaCapsula(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Mision extends StatelessWidget {
  const _Mision({required this.mision});

  final Mision mision;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: PdColor.superficie,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _sombraTarjeta,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: PdColor.fondo, borderRadius: BorderRadius.circular(14)),
            child: IconoPd(mision.icono, tamano: 24, color: _colorMision(mision)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mision.titulo, style: letra(15, FontWeight.w700)),
                Text(mision.detalle, style: letra(12.5, FontWeight.w400, PdColor.textoSecundario)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(pts(mision.puntos), style: letra(14, FontWeight.w700)),
              const SizedBox(height: 4),
              BotonCompletar(
                mision: mision,
                tamano: 13,
                relleno: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sorteo del Club: se participa canjeando puntos.
class _Canje extends StatelessWidget {
  const _Canje({required this.canje});

  final Canje canje;

  @override
  Widget build(BuildContext context) {
    final oscuro = canje.oscuro;
    final participa = Demo.of(context).perfil.sorteos.contains(canje.titulo);
    return Presionable(
      onTap: () {
        final store = Demo.leer(context);
        final faltan = canje.puntos - store.perfil.puntos;
        if (store.canjear(canje)) {
          avisoBreve(context, '¡Ya participas en el sorteo: ${canje.titulo}!');
        } else {
          avisoBreve(context, 'Te faltan ${miles(faltan)} pts para este sorteo.');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: oscuro ? null : PdColor.superficie,
          gradient: oscuro
              ? degradadoCss(160, const [Color(0xFF1C1B2E), Color(0xFF2A2D1E), Color(0xFF6E8F1E)], const [0, 0.55, 1])
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: oscuro ? null : _sombraTarjeta,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: oscuro ? const Color(0xFF34391F) : PdColor.acentoPalido,
                borderRadius: BorderRadius.circular(PdRadio.pildora),
              ),
              child: Text(
                participa ? 'Participando' : 'Sorteo',
                style: letra(12, FontWeight.w700, oscuro ? PdColor.lima : PdColor.acentoOscuro),
              ),
            ),
            const SizedBox(height: 10),
            Text(canje.titulo, style: letra(15, FontWeight.w700, oscuro ? Colors.white : PdColor.tinta, 1.25)),
            const Spacer(),
            const SizedBox(height: 8),
            Text(
              '${miles(canje.puntos)} pts',
              style: letra(15, FontWeight.w700, oscuro ? PdColor.lima : PdColor.acentoOscuro),
            ),
          ],
        ),
      ),
    );
  }
}
