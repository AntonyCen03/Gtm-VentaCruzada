import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tema/tokens.dart';

/// Campo de texto con la etiqueta encima y línea inferior (P3).
class CampoPd extends StatelessWidget {
  const CampoPd({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.teclado,
    this.formato,
    this.onCambio,
    this.onEnviar,
    this.pista,
    this.accion = TextInputAction.next,
    this.debajo,
  });

  final String etiqueta;
  final TextEditingController controlador;
  final TextInputType? teclado;
  final List<TextInputFormatter>? formato;
  final ValueChanged<String>? onCambio;
  final ValueChanged<String>? onEnviar;
  final String? pista;
  final TextInputAction accion;

  /// Mensaje de estado bajo el campo (p. ej. «Encontramos tu factura»).
  final Widget? debajo;

  @override
  Widget build(BuildContext context) {
    const borde = UnderlineInputBorder(borderSide: BorderSide(color: PdColor.linea, width: 1.5));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(etiqueta, style: PdTexto.cuerpo.copyWith(color: PdColor.textoSecundario)),
        TextField(
          controller: controlador,
          keyboardType: teclado,
          inputFormatters: formato,
          onChanged: onCambio,
          onSubmitted: onEnviar,
          textInputAction: accion,
          style: PdTexto.cuerpoFuerte.copyWith(fontSize: 18, fontFeatures: PdTexto.cifras.fontFeatures),
          decoration: InputDecoration(
            isDense: true,
            hintText: pista,
            hintStyle: PdTexto.cuerpoFuerte.copyWith(fontSize: 18, color: PdColor.iconoApagado),
            contentPadding: const EdgeInsets.only(top: 6, bottom: 10),
            border: borde,
            enabledBorder: borde,
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: PdColor.tinta, width: 1.5)),
          ),
        ),
        if (debajo != null) ...[const SizedBox(height: PdEspacio.s), debajo!],
      ],
    );
  }
}
