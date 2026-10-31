import 'package:flutter/material.dart';

import '../../componentes/encabezado.dart';
import '../../componentes/hoja_inferior.dart';
import '../../componentes/icono.dart';
import '../../componentes/interruptor.dart';
import '../../componentes/presionable.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

/// P8 · Tus avisos: la persona decide dónde y cuándo. Todo se guarda en el
/// DemoStore, así que el resumen semanal (P4) y Wisi (P5) lo reflejan.
class PantallaAvisos extends StatelessWidget {
  const PantallaAvisos({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final a = store.perfil.ajustes;
    final superior = MediaQuery.paddingOf(context).top;
    final inferior = MediaQuery.paddingOf(context).bottom;

    void cambiar(void Function(AjustesAvisos a) cambio) => store.cambiarAjustes(cambio);

    return Scaffold(
      backgroundColor: PdColor.fondoClaro,
      body: Column(
        children: [
          EncabezadoSimple(titulo: 'Tus avisos', tamano: 18, arriba: superior + 14, abajo: 4),
          Expanded(
            child: ListView(
              clipBehavior: Clip.none,
              padding: EdgeInsets.fromLTRB(18, 8, 18, inferior + 20),
              children: [
                const _NuncaManejando(),
                const SizedBox(height: 14),
                _Grupo(
                  filas: [
                    FilaInterruptor(
                      titulo: 'Resumen semanal',
                      subtitulo: 'Tus vencimientos en un solo aviso',
                      tamanoSubtitulo: 13,
                      tituloFuerte: true,
                      valor: a.resumenSemanal,
                      onCambio: (v) => cambiar((a) => a.resumenSemanal = v),
                    ),
                  ],
                  pie: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _Selector<int>(
                            etiqueta: 'Día',
                            valor: a.dia,
                            opciones: AjustesAvisos.dias,
                            texto: nombreDia,
                            onCambio: a.resumenSemanal ? (v) => cambiar((a) => a.dia = v) : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _Selector<TimeOfDay>(
                            etiqueta: 'Hora',
                            valor: a.hora,
                            opciones: AjustesAvisos.horas,
                            texto: hora,
                            onCambio: a.resumenSemanal ? (v) => cambiar((a) => a.hora = v) : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Dónde te avisamos', style: letra(15, FontWeight.w700)),
                const SizedBox(height: 14),
                _Grupo(
                  filas: [
                    FilaInterruptor(
                      titulo: 'Notificación en la app',
                      valor: a.enApp,
                      onCambio: (v) => cambiar((a) => a.enApp = v),
                    ),
                    FilaInterruptor(
                      titulo: 'WhatsApp con Wisi',
                      subtitulo: '${store.perfil.telefono} · el mismo resumen',
                      valor: a.whatsapp,
                      onCambio: (v) => cambiar((a) => a.whatsapp = v),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Sugerencias por categoría', style: letra(15, FontWeight.w700)),
                const SizedBox(height: 14),
                _Grupo(
                  filas: [
                    FilaInterruptor(
                      titulo: 'Servicios',
                      valor: a.servicios,
                      onCambio: (v) => cambiar((a) => a.servicios = v),
                    ),
                    FilaInterruptor(
                      titulo: 'Seguros',
                      valor: a.seguros,
                      onCambio: (v) => cambiar((a) => a.seguros = v),
                    ),
                    FilaInterruptor(
                      titulo: 'Parquímetros',
                      valor: a.parquimetros,
                      onCambio: (v) => cambiar((a) => a.parquimetros = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NuncaManejando extends StatelessWidget {
  const _NuncaManejando();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: PdColor.tinta, borderRadius: BorderRadius.circular(22)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFF2A2940), borderRadius: BorderRadius.circular(13)),
              child: const IconoPd(Ico.volante, tamano: 22, color: PdColor.lima),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Nunca mientras manejo', style: letra(16, FontWeight.w700, Colors.white))),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: PdColor.lima,
                          borderRadius: BorderRadius.circular(PdRadio.pildora),
                        ),
                        child: Text('Siempre activo', style: letra(12, FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ningún aviso al entrar o salir de un estacionamiento, ni en los 30 minutos siguientes.',
                    style: letra(13, FontWeight.w400, PdColor.grisClaro, 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta blanca con filas separadas por una línea fina.
class _Grupo extends StatelessWidget {
  const _Grupo({required this.filas, this.pie});

  final List<Widget> filas;
  final Widget? pie;

  @override
  Widget build(BuildContext context) {
    final total = filas.length + (pie == null ? 0 : 1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: PdColor.superficie,
        borderRadius: BorderRadius.circular(20),
        boxShadow: sombraCss(4, 16, const Color.fromRGBO(28, 27, 46, 0.05)),
      ),
      child: Column(
        children: [
          for (final (i, f) in filas.indexed)
            DecoratedBox(
              decoration: BoxDecoration(
                border: i < total - 1 ? const Border(bottom: BorderSide(color: PdColor.divisor)) : null,
              ),
              child: f,
            ),
          ?pie,
        ],
      ),
    );
  }
}

/// Desplegable con el aspecto del `<select>` del mockup.
class _Selector<T> extends StatelessWidget {
  const _Selector({
    required this.etiqueta,
    required this.valor,
    required this.opciones,
    required this.texto,
    required this.onCambio,
  });

  final String etiqueta;
  final T valor;
  final List<T> opciones;
  final String Function(T) texto;
  final ValueChanged<T>? onCambio;

  Future<void> _abrir(BuildContext context) async {
    final elegido = await mostrarHojaPd<T>(
      context,
      (hoja) => HojaPd(
        titulo: etiqueta,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final o in opciones)
              Presionable(
                onTap: () => Navigator.of(hoja).pop(o),
                seleccionado: o == valor,
                radio: PdRadio.campo,
                escala: 0.99,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 52),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(child: Text(texto(o), style: letra(16, o == valor ? FontWeight.w700 : FontWeight.w500))),
                      if (o == valor) const IconoPd(Ico.check, tamano: 20, color: PdColor.exito),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (elegido != null && elegido != valor) onCambio?.call(elegido);
  }

  @override
  Widget build(BuildContext context) {
    final activo = onCambio != null;
    return Opacity(
      opacity: activo ? 1 : 0.45,
      child: Presionable(
        onTap: activo ? () => _abrir(context) : null,
        radio: 12,
        escala: 0.99,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(etiqueta, style: letra(13, FontWeight.w400, PdColor.textoSecundario)),
            const SizedBox(height: 6),
            Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: PdColor.fondoClaro, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(child: Text(texto(valor), style: letra(15, FontWeight.w600))),
                  const IconoPd(Ico.abajo, tamano: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
