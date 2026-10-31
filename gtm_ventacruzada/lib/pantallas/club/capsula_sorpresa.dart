import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/avisos_demo.dart';
import '../../componentes/presionable.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

const _limaClaro = Color(0xFFE4F5A8);

/// Cápsula sorpresa del Club: se abre ahí mismo, sin cambiar de pantalla. La
/// cápsula tiembla, la tapa rosada salta y el premio sale con un rebote.
class TarjetaCapsula extends StatefulWidget {
  const TarjetaCapsula({super.key});

  @override
  State<TarjetaCapsula> createState() => _TarjetaCapsulaState();
}

class _TarjetaCapsulaState extends State<TarjetaCapsula> with SingleTickerProviderStateMixin {
  late final _apertura = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  PremioCapsula? _premio;

  bool get _abriendo => _apertura.isAnimating;
  bool get _listo => _premio != null && !_abriendo;

  @override
  void dispose() {
    _apertura.dispose();
    super.dispose();
  }

  void _alTocar() {
    if (_abriendo) return;
    // Con un premio a la vista, el primer toque cierra la cápsula para abrir otra.
    if (_premio != null) {
      setState(() => _premio = null);
      _apertura.value = 0;
      return;
    }
    final store = Demo.leer(context);
    final faltan = DemoStore.precioCapsula - store.perfil.puntos;
    if (faltan > 0) {
      avisoBreve(context, 'Te faltan ${miles(faltan)} pts para abrir una cápsula.');
      return;
    }
    setState(() => _premio = store.abrirCapsula());
    _apertura.duration = MediaQuery.disableAnimationsOf(context)
        ? const Duration(milliseconds: 1)
        : const Duration(milliseconds: 1400);
    _apertura.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final premio = _premio;
    final boton = _listo
        ? premio!.anuncio
        : _abriendo
        ? 'Abriendo…'
        : 'Abrir cápsula · ${DemoStore.precioCapsula} pts';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      decoration: BoxDecoration(
        color: PdColor.superficie,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: PdColor.lima, width: 3),
        boxShadow: sombraCss(4, 14, const Color.fromRGBO(28, 27, 46, 0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: _limaClaro, borderRadius: BorderRadius.circular(PdRadio.pildora)),
                  child: Text('Cápsula sorpresa', style: letra(12, FontWeight.w700)),
                ),
                const SizedBox(height: 10),
                Text('Ábrela y gana al instante', style: letra(18, FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  '${miles(DemoStore.precioCapsula)} pts por cápsula',
                  style: letra(15, FontWeight.w700, PdColor.acentoOscuro),
                ),
                const SizedBox(height: 8),
                for (final p in PremioCapsula.values)
                  Text('• ${p.nombre}', style: letra(12.5, FontWeight.w400, PdColor.textoSecundario, 1.4)),
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: _listo,
                  child: Presionable(
                    onTap: _abriendo ? null : _alTocar,
                    etiqueta: _listo ? '$boton Toca para abrir otra cápsula.' : null,
                    radio: PdRadio.pildora,
                    child: AnimatedContainer(
                      duration: PdDuracion.de(context, PdDuracion.cambio),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                      decoration: BoxDecoration(
                        color: _listo ? PdColor.lima : _limaClaro,
                        borderRadius: BorderRadius.circular(PdRadio.pildora),
                      ),
                      child: Text(
                        boton,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: letra(13.5, FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Presionable(
            onTap: _abriendo ? null : _alTocar,
            etiqueta: 'Cápsula sorpresa',
            radio: 60,
            child: SizedBox(
              width: 116,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _apertura,
                    builder: (_, _) => CustomPaint(
                      size: const Size(116, 124),
                      painter: _PintorCapsula(t: _apertura.value, simbolo: premio?.simbolo),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 34,
                    child: AnimatedOpacity(
                      opacity: _listo ? 1 : 0,
                      duration: PdDuracion.de(context, PdDuracion.cambio),
                      child: Text(
                        premio?.nombre ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: letra(12.5, FontWeight.w700, PdColor.tinta, 1.25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dibuja la cápsula. [t] va de 0 (cerrada) a 1 (abierta, premio fuera).
class _PintorCapsula extends CustomPainter {
  const _PintorCapsula({required this.t, required this.simbolo});

  final double t;
  final String? simbolo;

  static double _tramo(double t, double desde, double hasta) => ((t - desde) / (hasta - desde)).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final radio = size.width * 0.38;
    final base = Offset(size.width / 2, size.height * 0.62);

    // 1. Tiembla; 2. salta la tapa; 3. sale el premio con rebote.
    final temblor = t < 0.3 ? math.sin(_tramo(t, 0, 0.3) * 4 * math.pi) * 0.09 * (1 - _tramo(t, 0, 0.3)) : 0.0;
    final tapa = Curves.easeOutBack.transform(_tramo(t, 0.28, 0.6));
    final bola = simbolo == null ? 0.0 : Curves.elasticOut.transform(_tramo(t, 0.42, 1));

    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate(temblor);

    // Sombra en el suelo.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, radio + 6), width: radio * 1.6, height: 8),
      Paint()..color = const Color(0x141C1B2E),
    );

    final centroBola = Offset(0, -radio * 0.32 * bola);
    if (bola > 0) {
      canvas.drawCircle(
        centroBola,
        radio * 1.25,
        Paint()
          ..shader = RadialGradient(
            colors: [
              PdColor.lima.withValues(alpha: 0.55 * bola.clamp(0, 1)),
              PdColor.lima.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: centroBola, radius: radio * 1.25)),
      );
    }

    // Mitad de abajo: blanca con borde.
    final abajo = Path()
      ..addArc(Rect.fromCircle(center: Offset.zero, radius: radio), 0, math.pi)
      ..close();
    canvas.drawPath(abajo, Paint()..color = Colors.white);
    canvas.drawPath(
      abajo,
      Paint()
        ..color = const Color(0xFF3A394E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // El premio.
    if (bola > 0) {
      canvas.save();
      canvas.translate(centroBola.dx, centroBola.dy);
      canvas.scale(bola);
      final r = radio * 0.58;
      canvas.drawCircle(Offset.zero, r, Paint()..color = PdColor.lima);
      canvas.drawCircle(
        Offset.zero,
        r,
        Paint()
          ..color = PdColor.tinta
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
      final texto = TextPainter(
        text: TextSpan(
          text: simbolo,
          style: letra(simbolo!.length > 2 ? r * 0.55 : r * 0.9, FontWeight.w700, PdColor.tinta, 1),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      texto.paint(canvas, Offset(-texto.width / 2, -texto.height / 2));
      texto.dispose();
      canvas.restore();
    }

    // Tapa rosada: cerrada encima de la base; abierta, arriba y a la izquierda.
    canvas.save();
    canvas.translate(-radio * 0.42 * tapa, -radio * 0.95 * tapa);
    canvas.rotate(-0.55 * tapa);
    final arriba = Path()
      ..addArc(Rect.fromCircle(center: Offset.zero, radius: radio), math.pi, math.pi)
      ..close();
    canvas.drawPath(
      arriba,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF58FAA), PdColor.acento],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radio)),
    );
    canvas.drawPath(
      arriba,
      Paint()
        ..color = PdColor.acentoOscuro
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Brillo.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(-radio * 0.38, -radio * 0.55), width: radio * 0.42, height: radio * 0.22),
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(_PintorCapsula old) => old.t != t || old.simbolo != simbolo;
}
