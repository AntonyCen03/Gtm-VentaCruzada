import 'package:flutter/services.dart';

/// flutter_test dibuja el texto con «Ahem» (glifos cuadrados) si no se cargan
/// las fuentes reales; con Ahem los textos miden de más y los desbordes no son reales.
Future<void> cargarOutfit() async {
  final outfit = FontLoader('Outfit');
  for (final peso in ['Light', 'Regular', 'Medium', 'SemiBold', 'Bold']) {
    outfit.addFont(rootBundle.load('assets/fonts/Outfit-$peso.ttf'));
  }
  await outfit.load();
}
