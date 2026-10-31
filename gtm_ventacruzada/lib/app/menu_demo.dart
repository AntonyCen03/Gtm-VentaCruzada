import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../componentes/boton.dart';
import '../componentes/hoja_inferior.dart';
import '../componentes/icono.dart';
import '../componentes/interruptor.dart';
import '../componentes/presionable.dart';
import '../componentes/segmentado.dart';
import '../datos/demo_store.dart';
import '../tema/tokens.dart';

/// Pantallas a las que el presentador puede saltar (H8).
const _atajos = [
  ('Inicio', '/inicio', false),
  ('Mis pagos', '/mis-pagos', false),
  ('Añadir directorio', '/mis-pagos/afiliar', false),
  ('Resumen semanal', '/resumen', true),
  ('Wisi por WhatsApp', '/wisi', true),
  ('Tus avisos', '/avisos', true),
  ('Club PagoDirecto', '/club', true),
  ('Estacionar', '/estacionar', true),
  ('Catálogo de componentes', '/catalogo', true),
];

/// Menú de la barra inferior. Además de «Tus avisos» y el Club, incluye los
/// controles de la demo: perfil, reinicio, atajos y estados forzados.
Future<void> mostrarMenuDemo(BuildContext context) {
  final router = GoRouter.of(context);
  return mostrarHojaPd<void>(context, (hoja) {
    void ir(String ruta, bool apilar) {
      Navigator.of(hoja).pop();
      apilar ? router.push(ruta) : router.go(ruta);
    }

    return HojaPd(
      titulo: 'Menú',
      child: ListenableBuilder(
        listenable: Demo.leer(context),
        builder: (hoja, _) {
          final store = Demo.leer(context);
          return ListView(
            shrinkWrap: true,
            children: [
              _Opcion(texto: 'Tus avisos', icono: Ico.campana, onTap: () => ir('/avisos', true)),
              _Opcion(texto: 'Club PagoDirecto', icono: Ico.racha, onTap: () => ir('/club', true)),
              const SizedBox(height: PdEspacio.xl),
              Text('Demo', style: PdTexto.titulo.copyWith(fontSize: 18)),
              const SizedBox(height: PdEspacio.m),
              SegmentadoPd(
                etiqueta: 'Perfil de la demo',
                opciones: const ['María', 'Carlos'],
                seleccion: store.perfilId == 'maria' ? 0 : 1,
                onCambio: (i) => store.cambiarPerfil(i == 0 ? 'maria' : 'carlos'),
              ),
              const SizedBox(height: PdEspacio.m),
              Text('Estado de Mis pagos', style: PdTexto.meta.copyWith(fontSize: 13)),
              const SizedBox(height: 6),
              SegmentadoPd(
                etiqueta: 'Estado de Mis pagos',
                opciones: const ['Normal', 'Cargando', 'Error'],
                seleccion: store.estadoMisPagos.index,
                onCambio: (i) => store.forzarEstadoMisPagos(EstadoDatos.values[i]),
              ),
              FilaInterruptor(
                titulo: 'La búsqueda de factura falla',
                valor: store.fallarBusqueda,
                onCambio: store.forzarFalloBusqueda,
              ),
              const SizedBox(height: PdEspacio.s),
              Text('Ir a', style: PdTexto.meta.copyWith(fontSize: 13)),
              for (final (texto, ruta, apilar) in _atajos) _Opcion(texto: texto, onTap: () => ir(ruta, apilar)),
              const SizedBox(height: PdEspacio.l),
              BotonPd(
                texto: 'Reiniciar demo',
                tipo: TipoBoton.tonal,
                tamano: TamanoBoton.mediano,
                onPressed: () {
                  store.reiniciar();
                  ir('/inicio', false);
                },
              ),
            ],
          );
        },
      ),
    );
  });
}

class _Opcion extends StatelessWidget {
  const _Opcion({required this.texto, required this.onTap, this.icono});

  final String texto;
  final VoidCallback onTap;
  final Ico? icono;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: onTap,
      radio: PdRadio.campo,
      escala: 0.99,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            if (icono != null) ...[IconoPd(icono!, tamano: 20), const SizedBox(width: PdEspacio.m)],
            Expanded(
              child: Text(texto, style: PdTexto.cuerpoFuerte.copyWith(fontWeight: FontWeight.w500)),
            ),
            const IconoPd(Ico.adelante, tamano: 18, color: PdColor.iconoApagado),
          ],
        ),
      ),
    );
  }
}
