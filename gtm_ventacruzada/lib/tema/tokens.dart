import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Colores de PagoDirecto asignados a roles (docs/PLAN_UI.md §8).
abstract final class PdColor {
  static const fondo = Color(0xFFF4F4F7);
  static const superficie = Color(0xFFFFFFFF);
  static const superficieHundida = Color(0xFFE8E8EE);
  static const tinta = Color(0xFF1C1B2E);
  static const textoSecundario = Color(0xFF6B6A7B);
  static const textoNeutro = Color(0xFF55546A);
  static const iconoApagado = Color(0xFF9A99A8);
  static const linea = Color(0xFFE2E2E6);
  static const acento = Color(0xFFD6305B);
  static const acentoOscuro = Color(0xFFA2203F);
  static const acentoPalido = Color(0xFFFDE9EF);
  static const neutroPalido = Color(0xFFF0F0F4);
  static const exito = Color(0xFF2F9E44);
  static const exitoTexto = Color(0xFF1F7A35);
  static const exitoPalido = Color(0xFFE9F6EC);
  static const lima = Color(0xFFC7E86A);
  static const interruptorApagado = Color(0xFFDCDBE4);
  static const fondoClaro = Color(0xFFF5F5F7);
  static const divisor = Color(0xFFECECF1);
  static const acentoVivo = Color(0xFFE8195C);
  static const rosaMarca = Color(0xFFC82E57);
  static const totalOscuro = Color(0xFF0B0F2A);
  static const grisClaro = Color(0xFFD9D8E3);

  /// Texto secundario y acentos sobre las tarjetas oscuras (`tinta`).
  static const sobreOscuroSecundario = Color(0xFFB9BACB);
  static const sobreOscuroAcento = Color(0xFFFF8FB0);
  static const sobreOscuroPista = Color(0xFF3A394E);

  /// Degradados del mockup, con el ángulo CSS convertido a Flutter.
  static final degradadoSaldo = degradadoCss(140, const [Color(0xFFE8335F), Color(0xFFC2265A), Color(0xFF4A1E6A)]);
  static final degradadoCredirecto = degradadoCss(160, const [Color(0xFF1C1B2E), Color(0xFF2A2D1E), Color(0xFF8DB12A)]);
}

/// `linear-gradient(<grados>deg, ...)` de CSS. Sin [paradas], reparto uniforme.
LinearGradient degradadoCss(double grados, List<Color> colores, [List<double>? paradas]) {
  final r = grados * math.pi / 180;
  final x = math.sin(r);
  final y = -math.cos(r);
  return LinearGradient(begin: Alignment(-x, -y), end: Alignment(x, y), colors: colores, stops: paradas);
}

/// `box-shadow: 0 <y>px <desenfoque>px <color>` de CSS. CSS usa sigma = desenfoque / 2;
/// Flutter convierte su radio con sigma = r · 0,57735 + 0,5.
List<BoxShadow> sombraCss(double y, double desenfoque, Color color) => [
  BoxShadow(color: color, offset: Offset(0, y), blurRadius: math.max(0, (desenfoque / 2 - 0.5) / 0.57735)),
];

/// Alto de línea «normal» de Outfit en el navegador (ascendente 1000 +
/// descendente 260 sobre 1000). Hay que fijarlo, igual que el espaciado entre
/// letras: el texto de cuerpo de Material 3 hereda alto 1,43 y espaciado 0,25,
/// que estirarían y ensancharían todo el mockup.
const altoNormal = 1.26;

/// Estilo de texto con los valores exactos del mockup.
TextStyle letra(
  double tamano, [
  FontWeight peso = FontWeight.w400,
  Color color = PdColor.tinta,
  double? alto,
  double? espaciado,
]) => TextStyle(
  fontFamily: 'Outfit',
  fontSize: tamano,
  fontWeight: peso,
  color: color,
  height: alto ?? altoNormal,
  letterSpacing: espaciado ?? 0,
);

/// Escala tipográfica: 7 estilos en total, como máximo 5 por pantalla.
abstract final class PdTexto {
  static const _cifras = [FontFeature.tabularFigures()];

  static const montoHeroe = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.6,
    color: PdColor.tinta,
    fontFeatures: _cifras,
  );
  static const monto = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.4,
    color: PdColor.tinta,
    fontFeatures: _cifras,
  );
  static const titulo = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
    color: PdColor.tinta,
  );
  static const cuerpoFuerte = TextStyle(
    fontFamily: 'Outfit',
    letterSpacing: 0,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: PdColor.tinta,
  );
  static const cuerpo = TextStyle(
    fontFamily: 'Outfit',
    letterSpacing: 0,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: PdColor.tinta,
  );
  static const meta = TextStyle(
    fontFamily: 'Outfit',
    letterSpacing: 0,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: PdColor.textoSecundario,
  );
  static const pastilla = TextStyle(
    fontFamily: 'Outfit',
    letterSpacing: 0,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: PdColor.acentoOscuro,
  );

  /// Para montos y puntos que no usan [montoHeroe] ni [monto].
  static const cifras = TextStyle(fontFeatures: _cifras);
}

abstract final class PdEspacio {
  static const margen = 18.0;
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class PdRadio {
  static const campo = 12.0;
  static const tarjeta = 20.0;
  static const grande = 24.0;
  static const pildora = 999.0;
}

abstract final class PdDuracion {
  static const presion = Duration(milliseconds: 120);
  static const cambio = Duration(milliseconds: 200);
  static const hoja = Duration(milliseconds: 280);
  static const progreso = Duration(milliseconds: 600);

  /// Sin desplazamientos cuando el sistema pide reducir movimiento.
  static Duration de(BuildContext context, Duration d) => MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;
}

/// Sombras solo para lo que flota de verdad (§7.3): nada en reposo.
abstract final class PdSombra {
  static const flotante = [BoxShadow(color: Color(0x291C1B2E), blurRadius: 14, offset: Offset(0, 4))];
  static const barraInferior = [BoxShadow(color: Color(0x121C1B2E), blurRadius: 20, offset: Offset(0, -6))];
  static const estacionar = [BoxShadow(color: Color(0x47D6305B), blurRadius: 16, offset: Offset(0, 6))];
}
