import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../componentes/icono.dart';
import '../../componentes/presionable.dart';
import '../../datos/datos_demo.dart';
import '../../datos/demo_store.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

/// A3 · Salida del estacionamiento: confirmación limpia y ningún aviso
/// mientras la persona maneja (`DemoStore.manejando` silencia los avisos).
class PantallaSalida extends StatelessWidget {
  const PantallaSalida({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final perfil = store.perfil;
    final total = perfil.ultimoEstacionamientoCentimos ?? store.totalEstacionamiento;
    final superior = MediaQuery.paddingOf(context).top;
    final inferior = MediaQuery.paddingOf(context).bottom;
    final gris = letra(15, FontWeight.w400, PdColor.textoSecundario);

    return Scaffold(
      backgroundColor: PdColor.fondoClaro,
      body: Padding(
        padding: EdgeInsets.fromLTRB(22, superior + 80, 22, inferior + 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: PdColor.exito,
                          shape: BoxShape.circle,
                          boxShadow: sombraCss(10, 22, const Color.fromRGBO(47, 158, 68, 0.3)),
                        ),
                        child: const IconoPd(Ico.check, tamano: 42, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Semantics(
                      header: true,
                      child: Text(
                        '¡Listo, ${perfil.nombre}!',
                        textAlign: TextAlign.center,
                        style: letra(28, FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Estacionamiento ${ticketDemo.lugar} pagado',
                      textAlign: TextAlign.center,
                      style: letra(16, FontWeight.w400, PdColor.textoSecundario),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: PdColor.superficie,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: sombraCss(4, 16, const Color.fromRGBO(28, 27, 46, 0.05)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: PdColor.divisor)),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text('Total', style: gris)),
                                Text(bs(total), style: letra(15, FontWeight.w700)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(child: Text('Comprobante', style: gris)),
                                Text(ticketDemo.comprobante, style: letra(15, FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const IconoPd(Ico.volante, tamano: 30, color: PdColor.textoSecundario),
            const SizedBox(height: 8),
            Text(
              'Buen viaje. Mientras manejas no te enviaremos ningún aviso.',
              textAlign: TextAlign.center,
              style: letra(14, FontWeight.w400, PdColor.textoSecundario, 1.4),
            ),
            const SizedBox(height: 18),
            Presionable(
              onTap: () => context.go('/inicio'),
              radio: PdRadio.pildora,
              child: Container(
                constraints: const BoxConstraints(minHeight: 60),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PdColor.exito,
                  borderRadius: BorderRadius.circular(PdRadio.pildora),
                  boxShadow: sombraCss(8, 18, const Color.fromRGBO(47, 158, 68, 0.3)),
                ),
                child: Text('Salir del estacionamiento', style: letra(20, FontWeight.w700, Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
