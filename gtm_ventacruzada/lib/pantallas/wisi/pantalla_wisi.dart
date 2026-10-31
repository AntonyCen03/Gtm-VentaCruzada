import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../componentes/icono.dart';
import '../../componentes/presionable.dart';
import '../../datos/datos_demo.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

const _fondoChat = PdColor.superficie;
const _verdePropio = Color(0xFFDDF3E2);
const _horaGris = Color(0xFF8E8D9C);
final _sombraBurbuja = sombraCss(1, 2, const Color.fromRGBO(28, 27, 46, 0.08));

/// P5 · Wisi por WhatsApp (simulado). El domingo Wisi no habla de deudas: usa
/// un premio del Club como gancho y «Más información» lleva al Club.
class PantallaWisi extends StatefulWidget {
  const PantallaWisi({super.key});

  @override
  State<PantallaWisi> createState() => _PantallaWisiState();
}

class _PantallaWisiState extends State<PantallaWisi> {
  final _desplazamiento = ScrollController();
  final _texto = TextEditingController();
  int _mensajes = 0;

  @override
  void initState() {
    super.initState();
    Demo.leer(context).abrirChat();
  }

  @override
  void dispose() {
    _desplazamiento.dispose();
    _texto.dispose();
    super.dispose();
  }

  void _alFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_desplazamiento.hasClients) return;
      _desplazamiento.animateTo(
        _desplazamiento.position.maxScrollExtent,
        duration: PdDuracion.de(context, PdDuracion.hoja),
        curve: Curves.easeOut,
      );
    });
  }

  void _enviar() {
    Demo.leer(context).escribirAWisi(_texto.text);
    _texto.clear();
  }

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final chat = store.perfil.chat;
    final cantidad = chat.length + (store.wisiEscribiendo ? 1 : 0);
    if (cantidad != _mensajes) {
      _mensajes = cantidad;
      _alFinal();
    }
    final superior = MediaQuery.paddingOf(context).top;
    final inferior = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: _fondoChat,
      body: Column(
        children: [
          _Encabezado(superior: superior),
          Expanded(
            child: ListView(
              controller: _desplazamiento,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: PdColor.superficie, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      nombreDia(store.perfil.ajustes.dia),
                      style: letra(12, FontWeight.w600, PdColor.textoNeutro),
                    ),
                  ),
                ),
                for (final m in chat) ...[
                  const SizedBox(height: 8),
                  if (m.tipo == TipoMensaje.premio)
                    _Premio(mensaje: m)
                  else if (m.deWisi)
                    _BurbujaWisi(texto: m.texto, hora: m.hora)
                  else
                    _BurbujaPropia(texto: m.texto, hora: m.hora),
                ],
                if (store.wisiEscribiendo) ...[
                  const SizedBox(height: 8),
                  const _BurbujaWisi(texto: 'escribiendo…', hora: null),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 10, 22 + inferior),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 46),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: PdColor.superficie,
                      borderRadius: BorderRadius.circular(PdRadio.pildora),
                    ),
                    child: TextField(
                      controller: _texto,
                      onSubmitted: (_) => _enviar(),
                      textInputAction: TextInputAction.send,
                      style: letra(15),
                      cursorColor: PdColor.exito,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Escríbele a Wisi',
                        hintStyle: letra(15, FontWeight.w400, PdColor.iconoApagado),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Presionable(
                  onTap: _enviar,
                  etiqueta: 'Enviar',
                  radio: 23,
                  child: Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: PdColor.exito, shape: BoxShape.circle),
                    child: const IconoPd(Ico.enviarMensaje, tamano: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.superior});

  final double superior;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14, superior + 18, 14, 12),
      decoration: BoxDecoration(
        color: PdColor.superficie,
        boxShadow: sombraCss(2, 10, const Color.fromRGBO(28, 27, 46, 0.06)),
      ),
      child: Row(
        children: [
          Presionable(
            onTap: () => context.canPop() ? context.pop() : context.go('/inicio'),
            etiqueta: 'Volver',
            radio: 18,
            child: const SizedBox(width: 36, height: 44, child: Center(child: IconoPd(Ico.atras, tamano: 22))),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: PdColor.exito, shape: BoxShape.circle),
            child: const IconoPd(Ico.chat, tamano: 20, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text('Wisi · PagoDirecto', style: letra(17, FontWeight.w700))),
                    const SizedBox(width: 5),
                    const IconoPd(Ico.verificado, tamano: 14, color: PdColor.exito),
                  ],
                ),
                Text('Cuenta oficial verificada', style: letra(12.5, FontWeight.w400, PdColor.textoSecundario)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mensaje del domingo: el premio del Club como gancho, sin montos ni
/// vencimientos, y un solo botón que lleva al Club.
class _Premio extends StatelessWidget {
  const _Premio({required this.mensaje});

  final MensajeChat mensaje;

  @override
  Widget build(BuildContext context) {
    const rosa = TextStyle(color: PdColor.acentoOscuro, fontWeight: FontWeight.w700);
    const fuerte = TextStyle(fontWeight: FontWeight.w700);
    final cuerpo = letra(15, FontWeight.w400, PdColor.tinta, 1.4);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              decoration: BoxDecoration(
                color: PdColor.superficie,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                boxShadow: _sombraBurbuja,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${mensaje.texto} ¿Sabías que con '),
                        TextSpan(text: '${miles(premioWisi.puntos)} pts', style: rosa),
                        const TextSpan(text: ' puedes canjear '),
                        TextSpan(text: premioWisi.texto, style: fuerte),
                        const TextSpan(text: '?'),
                      ],
                    ),
                    style: cuerpo,
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    const TextSpan(
                      children: [
                        TextSpan(text: 'Si pagas tus servicios con PagoDirecto, cada pago te suma '),
                        TextSpan(text: 'puntos en el Club.', style: rosa),
                      ],
                    ),
                    style: cuerpo,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(mensaje.hora, style: letra(11, FontWeight.w400, _horaGris)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            _Respuesta(texto: 'Más información', icono: Ico.abrirExterno, onTap: () => context.push('/club')),
          ],
        ),
      ),
    );
  }
}

class _Respuesta extends StatelessWidget {
  const _Respuesta({required this.texto, required this.onTap, this.icono});

  final String texto;
  final VoidCallback onTap;
  final Ico? icono;

  static const _color = PdColor.exitoTexto;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: onTap,
      radio: 14,
      escala: 0.98,
      child: Container(
        constraints: const BoxConstraints(minHeight: 42),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: PdColor.superficie,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _sombraBurbuja,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icono != null) ...[IconoPd(icono!, tamano: 16, color: _color), const SizedBox(width: 6)],
            Text(texto, style: letra(15, FontWeight.w600, _color)),
          ],
        ),
      ),
    );
  }
}

class _BurbujaWisi extends StatelessWidget {
  const _BurbujaWisi({required this.texto, required this.hora});

  final String texto;

  /// Sin hora: indicador «escribiendo…».
  final String? hora;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
          decoration: BoxDecoration(
            color: PdColor.superficie,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: _sombraBurbuja,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                widthFactor: 1,
                child: Text(
                  texto,
                  style: hora == null
                      ? letra(14, FontWeight.w400, _horaGris).copyWith(fontStyle: FontStyle.italic)
                      : letra(15, FontWeight.w400, PdColor.tinta, 1.4),
                ),
              ),
              if (hora != null) ...[
                const SizedBox(height: 2),
                Text(hora!, style: letra(11, FontWeight.w400, _horaGris)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BurbujaPropia extends StatelessWidget {
  const _BurbujaPropia({required this.texto, required this.hora});

  final String texto;
  final String hora;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
          decoration: BoxDecoration(
            color: _verdePropio,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: _sombraBurbuja,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                widthFactor: 1,
                child: Text(texto, style: letra(15)),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(hora, style: letra(11, FontWeight.w400, PdColor.textoSecundario)),
                  const SizedBox(width: 3),
                  // El SVG mide 28×16: a 16 px de ancho, 9 px de alto.
                  const IconoPd(Ico.dobleCheck, tamano: 16 * 16 / 28, color: Color(0xFF3B82F6)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
