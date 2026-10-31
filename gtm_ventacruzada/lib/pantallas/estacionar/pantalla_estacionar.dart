import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../componentes/encabezado.dart';
import '../../componentes/icono.dart';
import '../../componentes/presionable.dart';
import '../../datos/datos_demo.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

/// A2 · Pago del estacionamiento. Aquí solo se paga el estacionamiento:
/// ninguna sugerencia ni venta cruzada.
class PantallaEstacionar extends StatefulWidget {
  const PantallaEstacionar({super.key});

  @override
  State<PantallaEstacionar> createState() => _PantallaEstacionarState();
}

class _PantallaEstacionarState extends State<PantallaEstacionar> {
  MetodoPago _metodo = MetodoPago.pagoDirecto;

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final perfil = store.perfil;
    final superior = MediaQuery.paddingOf(context).top;
    final inferior = MediaQuery.paddingOf(context).bottom;
    final gris = letra(14, FontWeight.w400, PdColor.textoSecundario);
    final valor = letra(14, FontWeight.w600);

    Widget detalle(String etiqueta, String monto) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(etiqueta, style: gris)),
          Text(monto, style: valor),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: PdColor.fondoClaro,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EncabezadoSimple(titulo: 'Estacionamiento', tamano: 18, arriba: superior + 14, abajo: 2),
          const Padding(padding: EdgeInsets.fromLTRB(22, 4, 22, 10), child: _Pasos()),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(18, 20, 18, 22 + inferior),
              decoration: BoxDecoration(
                color: PdColor.superficie,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: sombraCss(-6, 20, const Color.fromRGBO(28, 27, 46, 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.zero,
                      children: [
                        Text('Detalles', style: letra(15, FontWeight.w700, PdColor.textoSecundario)),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(color: PdColor.fondoClaro, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              detalle('Usuario', '@${perfil.usuario}'),
                              detalle('Pago de estacionamiento · ${ticketDemo.lugar}', bs(ticketDemo.centimos)),
                              detalle(
                                perfil.estacionamientoSinServicio
                                    ? 'Servicio PagoDirecto · premio de tu racha'
                                    : 'Servicio PagoDirecto',
                                bs(store.servicioEstacionamiento),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            children: [
                              Text('Pagas hoy', style: letra(13, FontWeight.w400, PdColor.textoSecundario)),
                              const SizedBox(height: 2),
                              Text(
                                bs(store.totalEstacionamiento),
                                style: letra(34, FontWeight.w700, PdColor.tinta, null, 34 * -0.01),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: PdColor.fondoClaro,
                                  borderRadius: BorderRadius.circular(PdRadio.pildora),
                                ),
                                child: Text(
                                  'Tasa BCV del día',
                                  style: letra(11.5, FontWeight.w500, PdColor.textoSecundario),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _Metodo(
                                seleccionado: _metodo == MetodoPago.pagoDirecto,
                                onTap: () => setState(() => _metodo = MetodoPago.pagoDirecto),
                                degradado: degradadoCss(135, const [PdColor.rosaMarca, Color(0xFF7A1E45)]),
                                titulo: 'PagoDirecto',
                                colorTitulo: Colors.white,
                                etiqueta: 'Saldo disponible',
                                valor: bs(perfil.saldoCentimos),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _Metodo(
                                seleccionado: _metodo == MetodoPago.credirecto,
                                onTap: () => setState(() => _metodo = MetodoPago.credirecto),
                                degradado: degradadoCss(
                                  160,
                                  const [Color(0xFF1C1B2E), Color(0xFF2A2D1E), Color(0xFF9DBB2E)],
                                  const [0, 0.55, 1],
                                ),
                                titulo: 'Credirecto',
                                colorTitulo: PdColor.lima,
                                etiqueta: 'Tickets disponibles',
                                valor: '${perfil.ticketsCredirecto}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(color: PdColor.fondoClaro, borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            children: [
                              const IconoPd(Ico.info, tamano: 18, color: PdColor.textoSecundario),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Aquí solo pagas tu estacionamiento. Nada más se agrega.',
                                  style: letra(12.5, FontWeight.w400, PdColor.textoSecundario),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Presionable(
                    onTap: () {
                      store.pagarEstacionamiento(_metodo);
                      context.pushReplacement('/estacionar/listo');
                    },
                    radio: PdRadio.pildora,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 56),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PdColor.exito,
                        borderRadius: BorderRadius.circular(PdRadio.pildora),
                        boxShadow: sombraCss(8, 18, const Color.fromRGBO(47, 158, 68, 0.3)),
                      ),
                      child: Text('Confirmar', style: letra(19, FontWeight.w700, Colors.white)),
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

/// Entrada · En curso · Pago · Salida, con «Pago» activo.
class _Pasos extends StatelessWidget {
  const _Pasos();

  static const _pasos = ['Entrada', 'En curso', 'Pago', 'Salida'];
  static const _actual = 2;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Paso 3 de 4: Pago',
      excludeSemantics: true,
      child: Row(
        children: [
          for (final (i, p) in _pasos.indexed) ...[
            if (i > 0) const SizedBox(width: 6),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= _actual ? PdColor.rosaMarca : PdColor.interruptorApagado,
                      borderRadius: BorderRadius.circular(PdRadio.pildora),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p,
                    style: i == _actual
                        ? letra(11, FontWeight.w700, PdColor.acentoOscuro)
                        : letra(11, FontWeight.w400, PdColor.textoSecundario),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Metodo extends StatelessWidget {
  const _Metodo({
    required this.seleccionado,
    required this.onTap,
    required this.degradado,
    required this.titulo,
    required this.colorTitulo,
    required this.etiqueta,
    required this.valor,
  });

  final bool seleccionado;
  final VoidCallback onTap;
  final Gradient degradado;
  final String titulo;
  final Color colorTitulo;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: onTap,
      seleccionado: seleccionado,
      radio: 18,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 108,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(gradient: degradado, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(titulo, style: letra(14, FontWeight.w700, colorTitulo)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(etiqueta, style: letra(11, FontWeight.w400, Colors.white)),
                    Text(valor, style: letra(16, FontWeight.w700, Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          // `outline: 3px solid; outline-offset: 2px`: no ocupa espacio.
          if (seleccionado)
            Positioned(
              left: -5,
              top: -5,
              right: -5,
              bottom: -5,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: PdColor.tinta, width: 3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
