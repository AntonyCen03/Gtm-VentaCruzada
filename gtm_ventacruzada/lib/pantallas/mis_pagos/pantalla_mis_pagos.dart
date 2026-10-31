import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/avisos_demo.dart';
import '../../componentes/icono.dart';
import '../../componentes/presionable.dart';
import '../../componentes/segmentado.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

/// P6 · Mis pagos. Con Carlos (sin servicios) es el fondo vacío de P3.
class PantallaMisPagos extends StatefulWidget {
  const PantallaMisPagos({super.key});

  @override
  State<PantallaMisPagos> createState() => _PantallaMisPagosState();
}

class _PantallaMisPagosState extends State<PantallaMisPagos> {
  int _pestana = 0;

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final superior = MediaQuery.paddingOf(context).top;
    final inferior = MediaQuery.paddingOf(context).bottom;

    final contenido = switch (store.estadoMisPagos) {
      EstadoDatos.cargando => const _Cargando(),
      EstadoDatos.error => _Error(onReintentar: () => store.forzarEstadoMisPagos(EstadoDatos.listo)),
      EstadoDatos.listo => switch (_pestana) {
        0 => const _Pendientes(),
        1 => const _Vacio('No tienes pagos programados.'),
        _ => const _Pagados(),
      },
    };

    return ColoredBox(
      color: PdColor.fondo,
      child: ListView(
        padding: EdgeInsets.only(top: superior, bottom: inferior + 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 10),
            child: Row(
              children: [
                _BotonRedondo(icono: Ico.atras, etiqueta: 'Volver', onTap: () => context.go('/inicio')),
                Expanded(
                  child: Text(
                    'Mis pagos',
                    textAlign: TextAlign.center,
                    style: letra(20, FontWeight.w700, PdColor.textoNeutro),
                  ),
                ),
                _BotonRedondo(
                  icono: Ico.soporte,
                  etiqueta: 'Soporte',
                  onTap: () => avisoFueraDeDemo(context, 'Soporte'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: SegmentadoPd(
              etiqueta: 'Estado de los pagos',
              estilo: EstiloSegmentado.acento,
              opciones: const ['Pendientes', 'Programados', 'Pagados'],
              seleccion: _pestana,
              onCambio: (i) => setState(() => _pestana = i),
            ),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(18, 16, 18, 0), child: contenido),
        ],
      ),
    );
  }
}

class _BotonRedondo extends StatelessWidget {
  const _BotonRedondo({required this.icono, required this.etiqueta, required this.onTap});

  final Ico icono;
  final String etiqueta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: onTap,
      etiqueta: etiqueta,
      radio: 23,
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: PdColor.superficie, shape: BoxShape.circle),
        child: IconoPd(icono, tamano: 20),
      ),
    );
  }
}

/// Tarjeta oscura «Total por pagar». Vacía, es la de P3.
class TarjetaTotal extends StatelessWidget {
  const TarjetaTotal({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final hay = store.pendientes.isNotEmpty;
    final n = store.pendientesEstaSemana;
    final gris = letra(14, FontWeight.w400, PdColor.sobreOscuroSecundario);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: PdColor.totalOscuro,
        borderRadius: BorderRadius.circular(22),
        boxShadow: hay ? sombraCss(6, 18, const Color.fromRGBO(11, 15, 42, 0.18)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total por pagar', style: gris),
          const SizedBox(height: 2),
          Text(bsPunto(store.totalPendiente), style: letra(28, FontWeight.w700, Colors.white)),
          const SizedBox(height: 2),
          Text(
            !hay
                ? 'No tienes pagos pendientes'
                : n == 1
                ? '1 pago vence esta semana'
                : '$n pagos vencen esta semana',
            style: gris.copyWith(fontSize: 13),
          ),
          if (hay) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(PdRadio.pildora),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Págalos aquí y ganas '),
                    TextSpan(
                      text: pts(store.puntosPendientes),
                      style: const TextStyle(color: PdColor.sobreOscuroAcento, fontWeight: FontWeight.w700),
                    ),
                    const TextSpan(text: ' del Club'),
                  ],
                ),
                style: letra(12.5, FontWeight.w600, Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pendientes extends StatelessWidget {
  const _Pendientes();

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final pendientes = store.pendientes;
    final sugerencia = store.perfil.sugerencia;

    void pagarTodo() {
      store.pagar(pendientes.map((p) => p.id), MetodoPago.pagoDirecto);
      context.push('/mis-pagos/listo');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TarjetaTotal(),
        for (final p in pendientes) ...[
          const SizedBox(height: 10),
          FilaPagoMisPagos(pago: p, hoy: store.hoy, onTap: pagarTodo),
        ],
        if (sugerencia != null && pendientes.isNotEmpty) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text('También vence pronto', style: letra(13, FontWeight.w600, PdColor.textoSecundario)),
          ),
          const SizedBox(height: 6),
          _Sugerencia(sugerencia: sugerencia),
        ],
        SizedBox(height: pendientes.isEmpty ? 12 : 14),
        Presionable(
          onTap: () => context.go('/mis-pagos/afiliar'),
          radio: PdRadio.pildora,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PdColor.superficie,
              borderRadius: BorderRadius.circular(PdRadio.pildora),
              border: Border.all(color: const Color(0xFFDCDBE4)),
            ),
            child: Text('+ Afiliar Directorio', style: letra(16, FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

/// Fila de pago de P6: monto con «Bs.» y vencimiento largo.
class FilaPagoMisPagos extends StatelessWidget {
  const FilaPagoMisPagos({super.key, required this.pago, required this.hoy, this.onTap});

  final Pago pago;
  final DateTime hoy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pagado = pago.estado == EstadoPago.pagado;
    final urgente = pago.prioritario && !pagado;
    final vence = pagado ? 'Pagado' : venceLargo(pago.vence, hoy);

    final fila = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: PdColor.superficie, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pago.alias ?? pago.empresa, style: letra(16, FontWeight.w700)),
                const SizedBox(height: 3),
                Text(
                  pago.alias == null ? pago.referencia : '${pago.empresa} · ${pago.referencia}',
                  style: letra(12.5, FontWeight.w400, PdColor.textoSecundario),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: urgente ? PdColor.acentoPalido : PdColor.neutroPalido,
                    borderRadius: BorderRadius.circular(PdRadio.pildora),
                  ),
                  child: Text(
                    vence,
                    style: letra(11.5, FontWeight.w700, urgente ? PdColor.acentoOscuro : PdColor.textoNeutro),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(bsPunto(pago.centimos), style: letra(16, FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                pagado ? 'Ganaste ${pts(pago.puntos, signo: false)}' : pts(pago.puntos),
                style: letra(12, FontWeight.w600, PdColor.acentoOscuro),
              ),
            ],
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
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
      child: onTap == null ? fila : Presionable(onTap: onTap, escala: 0.98, child: fila),
    );
  }
}

class _Sugerencia extends StatelessWidget {
  const _Sugerencia({required this.sugerencia});

  final Sugerencia sugerencia;

  @override
  Widget build(BuildContext context) {
    final store = Demo.leer(context);
    return CustomPaint(
      painter: const _BordePunteado(color: Color(0xFFC9C8D4), radio: 20, grosor: 1.5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
        child: Row(
          children: [
            Expanded(
              child: Presionable(
                onTap: () => avisoFueraDeDemo(context, 'Renovación de RCV'),
                escala: 0.99,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sugerencia.titulo, style: letra(15, FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '${venceLargo(sugerencia.vence, store.hoy)}. Renuévalo aquí: '),
                          TextSpan(
                            text: pts(sugerencia.puntos),
                            style: const TextStyle(color: PdColor.acentoOscuro, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      style: letra(12.5, FontWeight.w400, PdColor.textoSecundario),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Presionable(
              onTap: store.descartarSugerencia,
              etiqueta: 'No me interesa',
              radio: 16,
              child: const SizedBox(
                width: 32,
                height: 32,
                child: Center(child: IconoPd(Ico.cerrar, tamano: 18, color: PdColor.iconoApagado)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `border: 1.5px dashed` de CSS sobre un rectángulo redondeado.
class _BordePunteado extends CustomPainter {
  const _BordePunteado({required this.color, required this.radio, required this.grosor});

  final Color color;
  final double radio;
  final double grosor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius((Offset.zero & size).deflate(grosor / 2), Radius.circular(radio - grosor / 2));
    final pintura = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = grosor;
    final trazo = grosor * 3;
    for (final m in (Path()..addRRect(rect)).computeMetrics()) {
      for (var d = 0.0; d < m.length; d += trazo * 2) {
        canvas.drawPath(m.extractPath(d, d + trazo), pintura);
      }
    }
  }

  @override
  bool shouldRepaint(_BordePunteado old) => old.color != color || old.radio != radio || old.grosor != grosor;
}

class _Pagados extends StatelessWidget {
  const _Pagados();

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final pagados = store.pagados;
    if (pagados.isEmpty) return const _Vacio('Aún no has pagado servicios este mes.');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final p in pagados) ...[FilaPagoMisPagos(pago: p, hoy: store.hoy), const SizedBox(height: 10)],
      ],
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(color: PdColor.superficie, borderRadius: BorderRadius.circular(22)),
      child: Text(texto, style: letra(14, FontWeight.w400, PdColor.textoSecundario)),
    );
  }
}

/// Barras grises planas del tamaño real, sin brillo animado.
class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) {
    Widget bloque(double alto, Color color, double radio) => Container(
      height: alto,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radio)),
    );
    return Semantics(
      label: 'Cargando tus pagos',
      child: Column(
        children: [
          bloque(118, PdColor.superficieHundida, 22),
          const SizedBox(height: 10),
          bloque(84, PdColor.superficie, 20),
          const SizedBox(height: 10),
          bloque(84, PdColor.superficie, 20),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.onReintentar});

  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: PdColor.superficie, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No pudimos cargar tus pagos', style: letra(16, FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            'Revisa tu conexión. Tus datos de las 6:00 p. m. siguen guardados.',
            style: letra(13, FontWeight.w400, PdColor.textoSecundario),
          ),
          const SizedBox(height: 12),
          Presionable(
            onTap: onReintentar,
            radio: PdRadio.pildora,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: PdColor.acento, borderRadius: BorderRadius.circular(PdRadio.pildora)),
              child: Text('Reintentar', style: letra(14, FontWeight.w700, Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
