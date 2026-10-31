import 'package:flutter/material.dart';

import '../tema/tokens.dart';

/// Respuesta al toque común a todos los controles: escala breve al presionar,
/// anillo de foco con teclado y semántica de botón. Sin ondas de tinta.
class Presionable extends StatefulWidget {
  const Presionable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.etiqueta,
    this.radio = PdRadio.tarjeta,
    this.escala = 0.97,
    this.seleccionado,
    this.alternado,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Nombre accesible para controles sin texto visible (iconos).
  final String? etiqueta;
  final double radio;
  final double escala;
  final bool? seleccionado;
  final bool? alternado;

  @override
  State<Presionable> createState() => _PresionableState();
}

class _PresionableState extends State<Presionable> {
  bool _abajo = false;
  bool _foco = false;

  bool get _activo => widget.onTap != null || widget.onLongPress != null;

  void _presionar(bool abajo) {
    if (_abajo != abajo) setState(() => _abajo = abajo);
  }

  @override
  Widget build(BuildContext context) {
    Widget hijo = AnimatedScale(
      scale: _abajo ? widget.escala : 1,
      duration: PdDuracion.de(context, PdDuracion.presion),
      curve: Curves.easeOut,
      child: widget.child,
    );
    if (_foco) {
      hijo = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radio),
          border: Border.all(color: PdColor.acento, width: 2),
        ),
        child: hijo,
      );
    }

    return MergeSemantics(
      child: Semantics(
        button: widget.alternado == null,
        enabled: _activo,
        label: widget.etiqueta,
        selected: widget.seleccionado,
        toggled: widget.alternado,
        child: FocusableActionDetector(
          enabled: _activo,
          mouseCursor: _activo ? SystemMouseCursors.click : MouseCursor.defer,
          onShowFocusHighlight: (v) => setState(() => _foco = v),
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap?.call();
                return null;
              },
            ),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _activo ? (_) => _presionar(true) : null,
            onTapUp: _activo ? (_) => _presionar(false) : null,
            onTapCancel: _activo ? () => _presionar(false) : null,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: hijo,
          ),
        ),
      ),
    );
  }
}
