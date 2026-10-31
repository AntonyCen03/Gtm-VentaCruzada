import 'package:flutter/material.dart';

import '../datos/demo_store.dart';

/// Aviso breve para las secciones que el mockup no diseña.
/// Mientras la persona maneja no se muestra nada (promesa de A3).
void avisoFueraDeDemo(BuildContext context, String seccion) {
  avisoBreve(context, '«$seccion» no forma parte de la demo.');
}

void avisoBreve(BuildContext context, String texto) {
  if (Demo.leer(context).manejando) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(texto), duration: const Duration(seconds: 2)));
}
