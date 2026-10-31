import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/avisos_demo.dart';
import '../../componentes/hoja_inferior.dart';
import '../../componentes/icono.dart';
import '../../componentes/presionable.dart';
import '../../datos/datos_demo.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

const _etiqueta = Color(0xFFB5B5BE);
const _linea = Color(0xFFE2E2E6);

/// P3 · Añadir directorio. Llega con los datos del mockup ya escritos y la
/// factura encontrada; si se cambia el contrato, la búsqueda simulada se repite.
class HojaAfiliar extends StatefulWidget {
  const HojaAfiliar({super.key});

  @override
  State<HojaAfiliar> createState() => _HojaAfiliarState();
}

enum _Busqueda { buscando, encontrada, error }

class _HojaAfiliarState extends State<HojaAfiliar> {
  String _servicio = serviciosAfiliables.first;
  final _contrato = TextEditingController(text: '3001 4582 77');
  final _alias = TextEditingController(text: 'Luz de la casa');
  _Busqueda _estado = _Busqueda.encontrada;
  late Pago? _factura = facturaDe(_servicio, _contrato.text);
  String? _error;
  Timer? _espera;
  int _consulta = 0;

  @override
  void dispose() {
    _espera?.cancel();
    _contrato.dispose();
    _alias.dispose();
    super.dispose();
  }

  void _buscar({bool ya = false}) {
    _espera?.cancel();
    final contrato = _contrato.text.trim();
    if (contrato.length < 6) {
      setState(() {
        _factura = null;
        _estado = _Busqueda.error;
        _error = null;
      });
      return;
    }
    setState(() => _estado = _Busqueda.buscando);
    _espera = Timer(ya ? Duration.zero : const Duration(milliseconds: 500), () async {
      final consulta = ++_consulta;
      try {
        final f = await Demo.leer(context).buscarFactura(_servicio, contrato);
        if (!mounted || consulta != _consulta) return;
        setState(() {
          _factura = f;
          _estado = _Busqueda.encontrada;
        });
      } on StateError catch (e) {
        if (!mounted || consulta != _consulta) return;
        setState(() {
          _factura = null;
          _estado = _Busqueda.error;
          _error = e.message;
        });
      }
    });
  }

  Future<void> _elegirServicio() async {
    final elegido = await mostrarHojaPd<String>(
      context,
      (hoja) => HojaPd(
        titulo: 'Servicio',
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final s in serviciosAfiliables)
              Presionable(
                onTap: () => Navigator.of(hoja).pop(s),
                seleccionado: s == _servicio,
                radio: PdRadio.campo,
                escala: 0.99,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 52),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(child: Text(s, style: letra(18, FontWeight.w600))),
                      if (s == _servicio) const IconoPd(Ico.check, tamano: 20, color: PdColor.exito),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (elegido == null || elegido == _servicio) return;
    setState(() => _servicio = elegido);
    _buscar(ya: true);
  }

  void _listo() {
    final factura = _factura;
    if (factura == null) return;
    final alias = _alias.text.trim();
    final ganados = Demo.leer(context).afiliar(factura, alias: alias.isEmpty ? null : alias);
    context.go('/mis-pagos');
    if (ganados > 0) avisoBreve(context, '${pts(ganados)} del Club por tu primer servicio.');
  }

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final teclado = MediaQuery.viewInsetsOf(context).bottom;
    final inferior = MediaQuery.paddingOf(context).bottom;
    final listo = _estado == _Busqueda.encontrada;

    return Padding(
      padding: EdgeInsets.only(bottom: teclado),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFAFAFA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(top: 14, bottom: 34 + inferior),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 76,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6EA),
                    borderRadius: BorderRadius.circular(PdRadio.pildora),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(34, 22, 34, 0),
                child: Semantics(
                  header: true,
                  child: Text('Añadir directorio', style: letra(24, FontWeight.w700, const Color(0xFFC4C4CC))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(44, 18, 44, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Presionable(
                      onTap: _elegirServicio,
                      escala: 0.99,
                      radio: 8,
                      child: _Campo(
                        etiqueta: 'Servicio',
                        child: Row(
                          children: [
                            Expanded(child: Text(_servicio, style: letra(18, FontWeight.w600))),
                            const IconoPd(Ico.desplegar, tamano: 14, color: PdColor.textoNeutro),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _Campo(
                      etiqueta: 'Número de contrato',
                      child: _Entrada(
                        controlador: _contrato,
                        teclado: TextInputType.number,
                        onCambio: (_) => _buscar(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Resultado(
                      estado: _estado,
                      factura: _factura,
                      hoy: store.hoy,
                      error: _error,
                      onReintentar: () => _buscar(ya: true),
                    ),
                    const SizedBox(height: 20),
                    _Campo(
                      etiqueta: 'Alias de contacto',
                      child: _Entrada(controlador: _alias, accion: TextInputAction.done),
                    ),
                  ],
                ),
              ),
              if (store.primerServicio) ...[
                const SizedBox(height: 22),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Tu primer servicio aquí: '),
                      TextSpan(
                        text: pts(DemoStore.puntosPrimerServicio),
                        style: const TextStyle(color: PdColor.acentoOscuro, fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ' del Club'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: letra(13, FontWeight.w400, PdColor.textoSecundario),
                ),
                const SizedBox(height: 10),
              ] else
                const SizedBox(height: 26),
              Center(
                child: Presionable(
                  onTap: listo ? _listo : null,
                  radio: PdRadio.pildora,
                  child: AnimatedContainer(
                    duration: PdDuracion.de(context, PdDuracion.cambio),
                    width: 190,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: listo ? const Color(0xFFF5105C) : PdColor.superficieHundida,
                      borderRadius: BorderRadius.circular(PdRadio.pildora),
                      boxShadow: listo ? sombraCss(8, 18, const Color.fromRGBO(245, 16, 92, 0.28)) : null,
                    ),
                    child: Text(
                      'Listo',
                      style: letra(20, FontWeight.w600, listo ? Colors.white : PdColor.textoSecundario),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  const _Campo({required this.etiqueta, required this.child});

  final String etiqueta;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _linea, width: 1.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(etiqueta, style: letra(15, FontWeight.w400, _etiqueta)),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _Entrada extends StatelessWidget {
  const _Entrada({required this.controlador, this.teclado, this.onCambio, this.accion = TextInputAction.next});

  final TextEditingController controlador;
  final TextInputType? teclado;
  final ValueChanged<String>? onCambio;
  final TextInputAction accion;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controlador,
      keyboardType: teclado,
      textInputAction: accion,
      onChanged: onCambio,
      style: letra(18, FontWeight.w600),
      cursorColor: PdColor.acento,
      decoration: const InputDecoration.collapsed(hintText: null),
    );
  }
}

class _Resultado extends StatelessWidget {
  const _Resultado({
    required this.estado,
    required this.factura,
    required this.hoy,
    required this.error,
    required this.onReintentar,
  });

  final _Busqueda estado;
  final Pago? factura;
  final DateTime hoy;
  final String? error;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    final (fondo, circulo, texto) = switch (estado) {
      _Busqueda.encontrada => (const Color(0xFFE9F6EC), PdColor.exito, const Color(0xFF1E6B30)),
      _Busqueda.buscando => (PdColor.neutroPalido, PdColor.iconoApagado, PdColor.textoNeutro),
      _Busqueda.error => (PdColor.acentoPalido, PdColor.acentoOscuro, PdColor.acentoOscuro),
    };
    final f = factura;

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: circulo, shape: BoxShape.circle),
              child: estado == _Busqueda.buscando
                  ? const SizedBox.square(
                      dimension: 12,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : IconoPd(estado == _Busqueda.error ? Ico.cerrar : Ico.check, tamano: 13, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: switch (estado) {
                _Busqueda.encontrada when f != null => Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Encontramos tu factura:',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text:
                            ' ${bsPunto(f.centimos)}, ${venceLargo(f.vence, hoy).toLowerCase()}. '
                            'Te avisamos antes de que venza.',
                      ),
                    ],
                  ),
                  style: letra(13, FontWeight.w400, texto, 1.3),
                ),
                _Busqueda.buscando => Text('Buscando tu factura…', style: letra(13, FontWeight.w400, texto, 1.3)),
                _ => Row(
                  children: [
                    Expanded(
                      child: Text(
                        error ?? 'Escribe el número de contrato completo.',
                        style: letra(13, FontWeight.w400, texto, 1.3),
                      ),
                    ),
                    if (error != null)
                      Presionable(
                        onTap: onReintentar,
                        radio: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text('Reintentar', style: letra(13, FontWeight.w700, texto)),
                        ),
                      ),
                  ],
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
