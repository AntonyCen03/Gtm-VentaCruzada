import 'package:flutter/material.dart';

import '../tema/tokens.dart';
import 'hoja_inferior.dart';
import 'icono.dart';
import 'presionable.dart';

enum EstiloSelector {
  /// Caja gris (Día y Hora en Tus avisos).
  relleno,

  /// Línea inferior, como los campos de Añadir directorio.
  subrayado,
}

/// Selector con la etiqueta encima. Abre las opciones en una hoja inferior,
/// más cómoda con el pulgar que un menú desplegable.
class SelectorPd<T> extends StatelessWidget {
  const SelectorPd({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.opciones,
    required this.texto,
    required this.onCambio,
    this.estilo = EstiloSelector.relleno,
  });

  final String etiqueta;
  final T valor;
  final List<T> opciones;
  final String Function(T) texto;
  final ValueChanged<T>? onCambio;
  final EstiloSelector estilo;

  Future<void> _abrir(BuildContext context) async {
    final elegido = await mostrarHojaPd<T>(
      context,
      (context) => HojaPd(
        titulo: etiqueta,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final o in opciones)
              Presionable(
                onTap: () => Navigator.of(context).pop(o),
                seleccionado: o == valor,
                radio: PdRadio.campo,
                escala: 0.99,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 52),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          texto(o),
                          style: PdTexto.cuerpoFuerte.copyWith(
                            fontWeight: o == valor ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
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
    final relleno = estilo == EstiloSelector.relleno;
    final valorTexto = Text(
      texto(valor),
      style: relleno
          ? PdTexto.cuerpoFuerte.copyWith(fontSize: 15)
          : PdTexto.cuerpoFuerte.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return Presionable(
      onTap: onCambio == null ? null : () => _abrir(context),
      radio: PdRadio.campo,
      escala: 0.99,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            etiqueta,
            style: relleno
                ? PdTexto.meta.copyWith(fontSize: 13)
                : PdTexto.cuerpo.copyWith(color: PdColor.textoSecundario),
          ),
          const SizedBox(height: 6),
          if (relleno)
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: PdColor.neutroPalido,
                borderRadius: BorderRadius.circular(PdRadio.campo),
              ),
              child: Row(
                children: [
                  Expanded(child: valorTexto),
                  const IconoPd(Ico.desplegar, tamano: 18, color: PdColor.textoNeutro),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: PdColor.linea, width: 1.5)),
              ),
              child: Row(
                children: [
                  Expanded(child: valorTexto),
                  const IconoPd(Ico.desplegar, tamano: 20, color: PdColor.textoNeutro),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
