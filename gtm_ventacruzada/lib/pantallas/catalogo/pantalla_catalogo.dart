import 'package:flutter/material.dart';

import '../../componentes/avatar_racha.dart';
import '../../componentes/barra_inferior.dart';
import '../../componentes/barra_progreso.dart';
import '../../componentes/boton.dart';
import '../../componentes/burbuja_chat.dart';
import '../../componentes/campo.dart';
import '../../componentes/encabezado.dart';
import '../../componentes/fila_pago.dart';
import '../../componentes/hoja_inferior.dart';
import '../../componentes/icono.dart';
import '../../componentes/interruptor.dart';
import '../../componentes/pastilla.dart';
import '../../componentes/segmentado.dart';
import '../../componentes/selector.dart';
import '../../componentes/tarjeta.dart';
import '../../datos/datos_demo.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

/// Catálogo de componentes (Fase 1): todas las piezas y sus estados juntos
/// para revisarlos antes de montar las pantallas.
class PantallaCatalogo extends StatefulWidget {
  const PantallaCatalogo({super.key});

  @override
  State<PantallaCatalogo> createState() => _PantallaCatalogoState();
}

class _PantallaCatalogoState extends State<PantallaCatalogo> {
  int _inicio = 0;
  int _estado = 0;
  bool _resumen = true;
  bool _whatsapp = false;
  int _dia = DateTime.sunday;
  TimeOfDay _hora = AjustesAvisos.horas.first;
  String _servicio = serviciosAfiliables.first;
  final _contrato = TextEditingController(text: '3001 4582 77');

  @override
  void dispose() {
    _contrato.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final pagos = perfilMaria().pagos;

    return Scaffold(
      backgroundColor: PdColor.fondo,
      body: Column(
        children: [
          const EncabezadoPd(titulo: 'Catálogo'),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                PdEspacio.margen,
                PdEspacio.s,
                PdEspacio.margen,
                MediaQuery.paddingOf(context).bottom + PdEspacio.xxl,
              ),
              children: [
                _Seccion('Color', [
                  Wrap(
                    spacing: PdEspacio.s,
                    runSpacing: PdEspacio.s,
                    children: const [
                      _Muestra('fondo', PdColor.fondo),
                      _Muestra('superficie', PdColor.superficie),
                      _Muestra('tinta', PdColor.tinta),
                      _Muestra('texto 2.º', PdColor.textoSecundario),
                      _Muestra('acento', PdColor.acento),
                      _Muestra('acento osc.', PdColor.acentoOscuro),
                      _Muestra('acento pál.', PdColor.acentoPalido),
                      _Muestra('éxito', PdColor.exito),
                      _Muestra('éxito texto', PdColor.exitoTexto),
                      _Muestra('lima', PdColor.lima),
                    ],
                  ),
                ]),
                _Seccion('Tipografía · Outfit', [
                  Text(bs(187040), style: PdTexto.montoHeroe),
                  Text(bs(2543000), style: PdTexto.monto),
                  const Text('Mis pagos', style: PdTexto.titulo),
                  const Text('Corpoelec', style: PdTexto.cuerpoFuerte),
                  const Text('Ningún aviso al entrar o salir de un estacionamiento.', style: PdTexto.cuerpo),
                  const Text('Contrato 3001 4582 77', style: PdTexto.meta),
                  const Text('+300 pts', style: PdTexto.pastilla),
                ]),
                _Seccion('Botones', [
                  BotonPd(texto: 'Listo', onPressed: () {}),
                  BotonPd(texto: 'Confirmar', tipo: TipoBoton.confirmar, onPressed: () {}),
                  BotonPd(
                    texto: '+ Afiliar Directorio',
                    tipo: TipoBoton.secundario,
                    tamano: TamanoBoton.mediano,
                    onPressed: () {},
                  ),
                  const BotonPd(texto: 'Listo · deshabilitado', onPressed: null),
                  BotonPd(texto: 'Buscando', cargando: true, onPressed: () {}),
                  Row(
                    children: [
                      BotonPd(texto: 'Completar', tamano: TamanoBoton.compacto, anchoCompleto: false, onPressed: () {}),
                      const SizedBox(width: PdEspacio.s),
                      BotonPd(
                        texto: 'Completar',
                        tipo: TipoBoton.tonal,
                        tamano: TamanoBoton.compacto,
                        anchoCompleto: false,
                        onPressed: () {},
                      ),
                      const Spacer(),
                      BotonIconoPd(icono: Ico.campana, etiqueta: 'Notificaciones', onPressed: () {}),
                      const SizedBox(width: PdEspacio.s),
                      BotonIconoPd(icono: Ico.soporte, etiqueta: 'Soporte', onPressed: () {}),
                    ],
                  ),
                ]),
                _Seccion('Pastillas', [
                  Wrap(
                    spacing: PdEspacio.s,
                    runSpacing: PdEspacio.s,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PastillaPd(venceCorto(pagos[0].vence, store.hoy)),
                      PastillaPd(venceCorto(pagos[1].vence, store.hoy), tipo: TipoPastilla.neutra),
                      PastillaPd(pts(DemoStore.puntosPrimerServicio)),
                      PastillaPd(pts(600), tipo: TipoPastilla.lima),
                      const PastillaPd('Siempre activo', tipo: TipoPastilla.lima),
                      const InsigniaPd('+100'),
                    ],
                  ),
                ]),
                _Seccion('Segmentado', [
                  SegmentadoPd(
                    etiqueta: 'Secciones del inicio',
                    opciones: const ['Inicio', 'Club PagoDirecto'],
                    seleccion: _inicio,
                    onCambio: (i) => setState(() => _inicio = i),
                  ),
                  SegmentadoPd(
                    etiqueta: 'Estado de los pagos',
                    estilo: EstiloSegmentado.acento,
                    opciones: const ['Pendientes', 'Programados', 'Pagados'],
                    seleccion: _estado,
                    onCambio: (i) => setState(() => _estado = i),
                  ),
                ]),
                _Seccion('Ajustes', [
                  TarjetaPd(
                    child: Column(
                      children: [
                        FilaInterruptor(
                          titulo: 'Resumen semanal',
                          subtitulo: 'Tus vencimientos en un solo aviso',
                          tituloFuerte: true,
                          valor: _resumen,
                          onCambio: (v) => setState(() => _resumen = v),
                        ),
                        const SizedBox(height: PdEspacio.m),
                        Row(
                          children: [
                            Expanded(
                              child: SelectorPd<int>(
                                etiqueta: 'Día',
                                valor: _dia,
                                opciones: AjustesAvisos.dias,
                                texto: nombreDia,
                                onCambio: _resumen ? (v) => setState(() => _dia = v) : null,
                              ),
                            ),
                            const SizedBox(width: PdEspacio.m),
                            Expanded(
                              child: SelectorPd<TimeOfDay>(
                                etiqueta: 'Hora',
                                valor: _hora,
                                opciones: AjustesAvisos.horas,
                                texto: hora,
                                onCambio: _resumen ? (v) => setState(() => _hora = v) : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: PdEspacio.s),
                        FilaInterruptor(
                          titulo: 'WhatsApp con Wisi',
                          subtitulo: '0414 ••• 4521 · el mismo resumen',
                          valor: _whatsapp,
                          onCambio: (v) => setState(() => _whatsapp = v),
                        ),
                      ],
                    ),
                  ),
                ]),
                _Seccion('Campos', [
                  TarjetaPd(
                    padding: const EdgeInsets.all(PdEspacio.xl),
                    child: Column(
                      children: [
                        SelectorPd<String>(
                          etiqueta: 'Servicio',
                          estilo: EstiloSelector.subrayado,
                          valor: _servicio,
                          opciones: serviciosAfiliables,
                          texto: (s) => s,
                          onCambio: (v) => setState(() => _servicio = v),
                        ),
                        const SizedBox(height: PdEspacio.l),
                        CampoPd(
                          etiqueta: 'Número de contrato',
                          controlador: _contrato,
                          teclado: TextInputType.number,
                          debajo: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: PdColor.exitoPalido,
                              borderRadius: BorderRadius.circular(PdRadio.campo),
                            ),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Encontramos tu factura: ',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: '${bs(pagos[0].centimos)}, vence el jueves.'),
                                ],
                              ),
                              style: PdTexto.cuerpo.copyWith(color: PdColor.exitoTexto),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
                _Seccion('Filas de pago', [
                  for (final p in pagos) FilaPago(pago: p, hoy: store.hoy, onTap: () {}),
                  FilaPago(
                    pago: pagos[1].copyWith(estado: EstadoPago.pagado),
                    hoy: store.hoy,
                  ),
                ]),
                _Seccion('Tarjeta oscura y progreso', [
                  TarjetaPd.oscura(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total por pagar', style: PdTexto.cuerpo.copyWith(color: PdColor.sobreOscuroSecundario)),
                        Text(
                          bs(pagos.fold(0, (s, p) => s + p.centimos)),
                          style: PdTexto.montoHeroe.copyWith(color: PdColor.superficie),
                        ),
                        const SizedBox(height: PdEspacio.s),
                        PastillaPd.rica(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Págalos aquí y ganas '),
                              TextSpan(
                                text: pts(pagos.fold(0, (s, p) => s + p.puntos)),
                                style: const TextStyle(color: PdColor.sobreOscuroAcento, fontWeight: FontWeight.w700),
                              ),
                              const TextSpan(text: ' del Club'),
                            ],
                          ),
                        ),
                        const SizedBox(height: PdEspacio.l),
                        const BarraProgresoPd(
                          valor: 1850 / 2000,
                          desde: 1250 / 2000,
                          pista: PdColor.sobreOscuroPista,
                          relleno: PdColor.lima,
                          etiqueta: 'Progreso del nivel',
                        ),
                      ],
                    ),
                  ),
                ]),
                _Seccion('Avatar con racha', [
                  const Row(
                    children: [
                      AvatarRacha(racha: 3),
                      SizedBox(width: PdEspacio.xl),
                      AvatarRacha(racha: 1),
                    ],
                  ),
                ]),
                _Seccion('Chat con Wisi', [
                  Container(
                    padding: const EdgeInsets.all(PdEspacio.m),
                    decoration: BoxDecoration(
                      color: colorFondoChat,
                      borderRadius: BorderRadius.circular(PdRadio.tarjeta),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const BurbujaChat(
                          hora: '6:00 p. m.',
                          child: Text('Hola, María. Esta semana vencen Corpoelec y Movistar.'),
                        ),
                        const SizedBox(height: 6),
                        RespuestaRapida(texto: 'Pagar en la app', icono: Ico.abrirExterno, onTap: () {}),
                        const SizedBox(height: 6),
                        RespuestaRapida(texto: 'Recuérdamelo el jueves', onTap: () {}),
                        const SizedBox(height: PdEspacio.m),
                        const BurbujaChat(propia: true, hora: '6:02 p. m.', child: Text('Recuérdamelo el jueves')),
                      ],
                    ),
                  ),
                ]),
                _Seccion('Iconos', [
                  Wrap(
                    spacing: PdEspacio.m,
                    runSpacing: PdEspacio.m,
                    children: [
                      for (final i in Ico.values)
                        Tooltip(
                          message: i.name,
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: PdColor.superficie,
                              borderRadius: BorderRadius.circular(PdRadio.campo),
                            ),
                            child: IconoPd(i),
                          ),
                        ),
                    ],
                  ),
                ]),
                _Seccion('Hoja inferior', [
                  BotonPd(
                    texto: 'Abrir hoja de ejemplo',
                    tipo: TipoBoton.secundario,
                    tamano: TamanoBoton.mediano,
                    onPressed: () => mostrarHojaPd<void>(
                      context,
                      (hoja) => HojaPd(
                        titulo: 'Añadir directorio',
                        child: BotonPd(texto: 'Listo', onPressed: () => Navigator.of(hoja).pop()),
                      ),
                    ),
                  ),
                ]),
                _Seccion('Barra inferior', [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(PdRadio.tarjeta),
                    child: ColoredBox(
                      color: PdColor.fondo,
                      child: BarraInferiorPd(actual: DestinoBarra.inicio, onSeleccion: (_) {}),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion(this.titulo, this.hijos);

  final String titulo;
  final List<Widget> hijos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: PdEspacio.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TituloSeccion(titulo),
          const SizedBox(height: PdEspacio.m),
          for (var i = 0; i < hijos.length; i++) ...[if (i > 0) const SizedBox(height: PdEspacio.s), hijos[i]],
        ],
      ),
    );
  }
}

class _Muestra extends StatelessWidget {
  const _Muestra(this.nombre, this.color);

  final String nombre;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final hex = '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    return SizedBox(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(PdRadio.campo),
              border: color == PdColor.superficie || color == PdColor.fondo
                  ? Border.all(color: PdColor.superficieHundida)
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            nombre,
            style: PdTexto.meta.copyWith(fontSize: 11, color: PdColor.tinta),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(hex, style: PdTexto.meta.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}
