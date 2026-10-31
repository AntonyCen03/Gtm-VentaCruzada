import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../componentes/barra_progreso.dart';
import '../../componentes/icono.dart';
import '../../componentes/presionable.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

/// P7 · Tu semana está al día: lo pagado, el premio y el avance del Club.
class PantallaSemanaAlDia extends StatelessWidget {
  const PantallaSemanaAlDia({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final r = store.resumenPago;
    final puntos = r.puntosAntes + r.puntosGanados;
    final faltan = (Perfil.puntosSiguienteNivel - puntos).clamp(0, Perfil.puntosSiguienteNivel);
    final n = r.pagos.length;
    final superior = MediaQuery.paddingOf(context).top;
    final inferior = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: PdColor.fondoClaro,
      body: Padding(
        padding: EdgeInsets.fromLTRB(18, superior + 40, 18, inferior + 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PdColor.exito,
                        shape: BoxShape.circle,
                        boxShadow: sombraCss(8, 18, const Color.fromRGBO(47, 158, 68, 0.3)),
                      ),
                      child: const IconoPd(Ico.check, tamano: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Semantics(
                      header: true,
                      child: Text(
                        'Tu semana está al día',
                        textAlign: TextAlign.center,
                        style: letra(24, FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pagaste $n ${n == 1 ? 'servicio' : 'servicios'} en un toque',
                      textAlign: TextAlign.center,
                      style: letra(15, FontWeight.w400, PdColor.textoSecundario),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: PdColor.superficie,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: sombraCss(4, 16, const Color.fromRGBO(28, 27, 46, 0.05)),
                      ),
                      child: Column(
                        children: [
                          for (final (i, p) in r.pagos.indexed)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              decoration: BoxDecoration(
                                border: i < n - 1 ? const Border(bottom: BorderSide(color: PdColor.divisor)) : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFE3A34E), width: 2),
                                    ),
                                    child: IconoPd(p.icono, tamano: 18, color: const Color(0xFFC77E1E)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(p.empresa, style: letra(14))),
                                  Text(bs(p.centimos), style: letra(14, FontWeight.w600)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (r.premio) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(color: PdColor.acentoPalido, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: PdColor.rosaMarca,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: const IconoPd(Ico.regalo, tamano: 18, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text.rich(
                                const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Ganaste:',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text:
                                          ' tu próximo estacionamiento no paga el servicio PagoDirecto. Se aplica solo.',
                                    ),
                                  ],
                                ),
                                style: letra(14, FontWeight.w400, PdColor.acentoOscuro, 1.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: PdColor.tinta, borderRadius: BorderRadius.circular(22)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('Club PagoDirecto', style: letra(16, FontWeight.w700, Colors.white)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: PdColor.lima,
                                  borderRadius: BorderRadius.circular(PdRadio.pildora),
                                ),
                                child: Text(pts(r.puntosGanados), style: letra(13, FontWeight.w700)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          BarraProgresoPd(
                            valor: puntos / Perfil.puntosSiguienteNivel,
                            desde: r.puntosAntes / Perfil.puntosSiguienteNivel,
                            pista: const Color(0xFF2A2940),
                            relleno: PdColor.lima,
                            alto: 10,
                            etiqueta: 'Progreso del nivel',
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${miles(puntos)} pts · te faltan ${miles(faltan)} para el siguiente nivel.'
                            '${r.premio ? ' Tu racha suma una semana al día.' : ''}',
                            style: letra(13, FontWeight.w400, PdColor.grisClaro),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Presionable(
              onTap: () => context.go('/inicio'),
              radio: PdRadio.pildora,
              child: Container(
                constraints: const BoxConstraints(minHeight: 56),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PdColor.exito,
                  borderRadius: BorderRadius.circular(PdRadio.pildora),
                  boxShadow: sombraCss(8, 18, const Color.fromRGBO(47, 158, 68, 0.3)),
                ),
                child: Text('Volver al inicio', style: letra(19, FontWeight.w700, Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
