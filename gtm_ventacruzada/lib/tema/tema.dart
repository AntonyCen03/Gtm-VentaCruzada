import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tokens.dart';

/// Tema base: sin el morado por defecto de Material, sin ondas de tinta
/// (la respuesta al toque la da `Presionable`).
ThemeData temaPagoDirecto() {
  const esquema = ColorScheme.light(
    primary: PdColor.acento,
    onPrimary: PdColor.superficie,
    secondary: PdColor.tinta,
    onSecondary: PdColor.superficie,
    surface: PdColor.superficie,
    onSurface: PdColor.tinta,
    error: PdColor.acentoOscuro,
  );
  final base = ThemeData(useMaterial3: true, colorScheme: esquema, fontFamily: 'Outfit');

  return base.copyWith(
    scaffoldBackgroundColor: PdColor.fondo,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    textTheme: base.textTheme.apply(fontFamily: 'Outfit', bodyColor: PdColor.tinta, displayColor: PdColor.tinta),
    iconTheme: const IconThemeData(color: PdColor.tinta, size: 22),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: PdColor.acento,
      selectionColor: PdColor.acentoPalido,
      selectionHandleColor: PdColor.acento,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: PdColor.tinta,
      contentTextStyle: PdTexto.cuerpo.copyWith(color: PdColor.superficie),
      elevation: 0,
      insetPadding: const EdgeInsets.fromLTRB(PdEspacio.margen, 0, PdEspacio.margen, PdEspacio.l),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
