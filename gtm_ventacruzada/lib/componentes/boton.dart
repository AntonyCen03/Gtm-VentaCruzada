import 'package:flutter/material.dart';

import '../tema/tokens.dart';
import 'icono.dart';
import 'presionable.dart';

enum TipoBoton {
  /// La acción principal de la pantalla, en el rosa de marca. Una por pantalla.
  primario,

  /// Cerrar una transacción (Confirmar, Volver al inicio): verde semántico.
  confirmar,

  /// Acción secundaria con peso: fondo rosa pálido.
  tonal,

  /// Acción secundaria sobre el fondo gris: blanco, sin borde.
  secundario,
}

enum TamanoBoton {
  grande(56, PdTexto.cuerpoFuerte, 20),
  mediano(50, PdTexto.cuerpoFuerte, 16),
  compacto(34, TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600), 14);

  const TamanoBoton(this.alto, this.texto, this.relleno);
  final double alto;
  final TextStyle texto;
  final double relleno;
}

/// Botón en píldora con un solo relleno. Sin sombras ni brillos.
class BotonPd extends StatelessWidget {
  const BotonPd({
    super.key,
    required this.texto,
    required this.onPressed,
    this.tipo = TipoBoton.primario,
    this.tamano = TamanoBoton.grande,
    this.icono,
    this.anchoCompleto = true,
    this.cargando = false,
  });

  final String texto;
  final VoidCallback? onPressed;
  final TipoBoton tipo;
  final TamanoBoton tamano;
  final Ico? icono;
  final bool anchoCompleto;
  final bool cargando;

  bool get _activo => onPressed != null && !cargando;

  @override
  Widget build(BuildContext context) {
    // Mientras carga conserva su color: no está deshabilitado, está trabajando.
    final (fondo, frente) = onPressed != null
        ? switch (tipo) {
            TipoBoton.primario => (PdColor.acento, PdColor.superficie),
            TipoBoton.confirmar => (PdColor.exito, PdColor.superficie),
            TipoBoton.tonal => (PdColor.acentoPalido, PdColor.acentoOscuro),
            TipoBoton.secundario => (PdColor.superficie, PdColor.tinta),
          }
        : (PdColor.superficieHundida, PdColor.textoSecundario);

    final estilo = tamano.texto.copyWith(
      color: frente,
      fontSize: tamano == TamanoBoton.grande ? 18 : null,
      fontWeight: tamano == TamanoBoton.grande ? FontWeight.w700 : null,
    );

    Widget contenido = cargando
        ? SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2.4, color: frente))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icono != null) ...[IconoPd(icono!, tamano: 18, color: frente), const SizedBox(width: 6)],
              Flexible(
                child: Text(texto, style: estilo, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          );

    final pildora = AnimatedContainer(
      duration: PdDuracion.de(context, PdDuracion.cambio),
      height: tamano.alto,
      width: anchoCompleto ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: tamano.relleno),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(PdRadio.pildora)),
      child: contenido,
    );

    return Presionable(
      onTap: _activo ? onPressed : null,
      radio: PdRadio.pildora,
      // El área táctil mínima es de 44 px aunque el botón compacto mida 34.
      child: tamano.alto < 44
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: (44 - tamano.alto) / 2),
              child: pildora,
            )
          : pildora,
    );
  }
}

/// Botón redondo solo con icono (atrás, soporte, campana).
class BotonIconoPd extends StatelessWidget {
  const BotonIconoPd({
    super.key,
    required this.icono,
    required this.etiqueta,
    required this.onPressed,
    this.conFondo = true,
    this.tamano = 46,
  });

  final Ico icono;
  final String etiqueta;
  final VoidCallback? onPressed;
  final bool conFondo;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: onPressed,
      etiqueta: etiqueta,
      radio: PdRadio.pildora,
      child: Container(
        width: tamano < 44 ? 44 : tamano,
        height: tamano < 44 ? 44 : tamano,
        alignment: Alignment.center,
        decoration: conFondo ? const BoxDecoration(color: PdColor.superficie, shape: BoxShape.circle) : null,
        child: IconoPd(icono, tamano: 22),
      ),
    );
  }
}
