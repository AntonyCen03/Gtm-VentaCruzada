import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/avisos_demo.dart';
import '../../app/menu_demo.dart';
import '../../componentes/avatar_racha.dart';
import '../../componentes/icono.dart';
import '../../componentes/presionable.dart';
import '../../componentes/segmentado.dart';
import '../../datos/demo_store.dart';
import '../../datos/modelos.dart';
import '../../tema/formato.dart';
import '../../tema/tokens.dart';

final _sombraTarjeta = sombraCss(4, 14, const Color.fromRGBO(28, 27, 46, 0.06));

/// P1 / P2 · Inicio ordenado. Una sola pantalla: lo que cambia entre María y
/// Carlos sale de los datos (pagos, primera vez, misión destacada).
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final superior = MediaQuery.paddingOf(context).top;
    // Con extendBody el Scaffold suma la barra inferior al padding; el borde
    // físico del teléfono sigue en viewPadding.
    final inferior = MediaQuery.paddingOf(context).bottom;
    final borde = MediaQuery.viewPaddingOf(context).bottom;

    return ColoredBox(
      color: PdColor.fondo,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: superior, bottom: inferior + 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Encabezado(perfil: store.perfil),
                const _Carrusel(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                  child: SegmentadoPd(
                    etiqueta: 'Secciones del inicio',
                    opciones: const ['Inicio', 'Club PagoDirecto'],
                    seleccion: 0,
                    onCambio: (_) => context.push('/club'),
                  ),
                ),
                const _MisPagos(),
                const _Club(),
                const _Funciones(),
              ],
            ),
          ),
          Positioned(right: 14, bottom: 86 + borde, child: const _BotonWisi()),
        ],
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.perfil});

  final Perfil perfil;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
      child: Row(
        children: [
          // Pulsación larga: menú de la demo (cambiar de perfil, reiniciar…).
          Presionable(
            onTap: () {},
            onLongPress: () => mostrarMenuDemo(context),
            etiqueta: 'Perfil de @${perfil.usuario}',
            radio: 24,
            child: AvatarRacha(racha: perfil.racha),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('@${perfil.usuario}', style: letra(18, FontWeight.w700)),
                    const SizedBox(width: 5),
                    const IconoPd(Ico.verificado, tamano: 15, color: Color(0xFF8E8D9C)),
                  ],
                ),
                Text(perfil.nivel, style: letra(13, FontWeight.w400, PdColor.textoSecundario)),
              ],
            ),
          ),
          Presionable(
            onTap: () => context.push('/resumen'),
            etiqueta: 'Notificaciones',
            radio: 23,
            child: Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PdColor.superficie,
                shape: BoxShape.circle,
                boxShadow: sombraCss(2, 10, const Color.fromRGBO(28, 27, 46, 0.08)),
              ),
              child: const IconoPd(Ico.campana, tamano: 20),
            ),
          ),
        ],
      ),
    );
  }
}

/// Afilia tu cuenta · Saldo · Credirecto. Arranca desplazado 26 px a la
/// izquierda, como en el mockup, y se puede deslizar.
class _Carrusel extends StatefulWidget {
  const _Carrusel();

  @override
  State<_Carrusel> createState() => _CarruselState();
}

class _CarruselState extends State<_Carrusel> {
  final _control = ScrollController(initialScrollOffset: 26);

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final perfil = Demo.of(context).perfil;
    const blanco = Colors.white;

    Widget accion(Ico icono, String texto) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: blanco.withValues(alpha: 0.22), shape: BoxShape.circle),
          child: IconoPd(icono, tamano: 19, color: blanco),
        ),
        const SizedBox(height: 4),
        Text(texto, style: letra(12, FontWeight.w400, blanco)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      // Todas las tarjetas toman el alto de la de saldo (align-items: stretch);
      // las sombras desbordan como en CSS.
      child: SingleChildScrollView(
        controller: _control,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.only(right: 18),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Presionable(
                onTap: () => avisoFueraDeDemo(context, 'Afilia tu cuenta bancaria'),
                radio: 22,
                child: Container(
                  width: 96,
                  padding: const EdgeInsets.fromLTRB(30, 12, 8, 12),
                  decoration: BoxDecoration(
                    color: PdColor.superficie,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: _sombraTarjeta,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: PdColor.acento, shape: BoxShape.circle),
                        child: const IconoPd(Ico.mas, tamano: 18, color: blanco),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Afilia tu cuenta bancaria',
                        textAlign: TextAlign.center,
                        style: letra(12.5, FontWeight.w600, PdColor.tinta, 1.25),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 270,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  gradient: PdColor.degradadoSaldo,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: sombraCss(8, 20, const Color.fromRGBO(194, 38, 90, 0.22)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Saldo disponible', style: letra(14, FontWeight.w500, blanco.withValues(alpha: 0.95))),
                    Text(bs(perfil.saldoCentimos), style: letra(26, FontWeight.w700, blanco)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (final (icono, texto) in const [
                          (Ico.enviarWallet, 'Enviar Wallet'),
                          (Ico.depositar, 'Depositar'),
                          (Ico.masOpciones, 'Más'),
                        ])
                          Presionable(
                            onTap: () => avisoFueraDeDemo(context, texto),
                            radio: 12,
                            child: accion(icono, texto),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Presionable(
                onTap: () => avisoFueraDeDemo(context, 'Credirecto'),
                radio: 22,
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: PdColor.degradadoCredirecto,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Credirecto', style: letra(14, FontWeight.w700, PdColor.lima)),
                      const SizedBox(height: 6),
                      Text('Tickets disponibles', style: letra(11, FontWeight.w400, blanco)),
                      const SizedBox(height: 6),
                      Text('${perfil.ticketsCredirecto}', style: letra(20, FontWeight.w700, blanco)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MisPagos extends StatelessWidget {
  const _MisPagos();

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final primero = store.primerServicio;

    final registrar = _TarjetaPago(
      onTap: () => context.go('/mis-pagos/afiliar'),
      centrada: true,
      children: [
        const IconoPd(Ico.mas, tamano: 22),
        const SizedBox(height: 4),
        Text(
          'Registra tu servicio',
          textAlign: TextAlign.center,
          style: letra(12.5, FontWeight.w600, PdColor.tinta, 1.2),
        ),
        if (primero) ...[const SizedBox(height: 4), _pastilla(pts(DemoStore.puntosPrimerServicio), true)],
      ],
    );

    final tarjetas = <Widget>[
      if (primero) registrar,
      for (final p in store.pendientes)
        _TarjetaPago(
          onTap: () => context.go('/mis-pagos'),
          children: [
            Text(p.empresa, style: letra(15, FontWeight.w700)),
            const Spacer(),
            Text(bs(p.centimos), style: letra(13, FontWeight.w600)),
            const SizedBox(height: 4),
            _pastilla(venceCorto(p.vence, store.hoy), p.prioritario),
          ],
        ),
      for (final o in store.perfil.operadoras)
        _TarjetaPago(
          onTap: () => avisoFueraDeDemo(context, 'Recargas $o'),
          centrada: true,
          children: [Text(o, style: letra(15, FontWeight.w700))],
        ),
      if (!primero) registrar,
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(child: Text('Mis pagos', style: letra(19, FontWeight.w700))),
                Presionable(
                  onTap: () => context.go('/mis-pagos'),
                  radio: 8,
                  child: Text('Ver todos', style: letra(14, FontWeight.w600, PdColor.acento)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 106,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
              itemCount: tarjetas.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => tarjetas[i],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _pastilla(String texto, bool urgente) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(
    color: urgente ? PdColor.acentoPalido : PdColor.neutroPalido,
    borderRadius: BorderRadius.circular(PdRadio.pildora),
  ),
  child: Text(texto, style: letra(11, FontWeight.w700, urgente ? PdColor.acentoOscuro : PdColor.textoNeutro)),
);

class _TarjetaPago extends StatelessWidget {
  const _TarjetaPago({required this.children, required this.onTap, this.centrada = false});

  final List<Widget> children;
  final VoidCallback onTap;
  final bool centrada;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: onTap,
      child: Container(
        width: 108,
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: PdColor.superficie,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _sombraTarjeta,
        ),
        // En el mockup «Registra tu servicio» +200 pts desborda ~2 px sin que se note;
        // aquí se reduce lo justo para caber.
        child: centrada
            ? Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: 84,
                    child: Column(mainAxisSize: MainAxisSize.min, children: children),
                  ),
                ),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      ),
    );
  }
}

class _Club extends StatelessWidget {
  const _Club();

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final mision = store.misionDestacada;
    if (mision == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Club PagoDirecto', style: letra(19, FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
            decoration: BoxDecoration(
              color: PdColor.superficie,
              borderRadius: BorderRadius.circular(20),
              boxShadow: _sombraTarjeta,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mision.titulo, style: letra(15, FontWeight.w700)),
                      Text(mision.detalle, style: letra(12.5, FontWeight.w400, PdColor.textoSecundario)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(pts(mision.puntos), style: letra(14, FontWeight.w700)),
                    const SizedBox(height: 4),
                    BotonCompletar(
                      mision: mision,
                      tamano: 13.5,
                      relleno: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// «Completar» de una misión del Club. Pagar un servicio lleva a Mis pagos; el
/// resto se completa en el momento y suma los puntos.
class BotonCompletar extends StatelessWidget {
  const BotonCompletar({super.key, required this.mision, required this.tamano, required this.relleno});

  final Mision mision;
  final double tamano;
  final EdgeInsets relleno;

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: () {
        if (mision.accion == AccionMision.pagarServicio) {
          context.go('/mis-pagos');
          return;
        }
        final ganados = Demo.leer(context).completarMision(mision);
        avisoBreve(context, '¡Misión completada! ${pts(ganados)} del Club.');
      },
      radio: PdRadio.pildora,
      child: Container(
        padding: relleno,
        decoration: BoxDecoration(color: PdColor.acento, borderRadius: BorderRadius.circular(PdRadio.pildora)),
        child: Text('Completar', style: letra(tamano, FontWeight.w700, Colors.white)),
      ),
    );
  }
}

class _Funciones extends StatelessWidget {
  const _Funciones();

  @override
  Widget build(BuildContext context) {
    final store = Demo.of(context);
    final nuevas = store.perfil.funcionesNuevas;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: Text('Funciones', style: letra(19, FontWeight.w700))),
              if (nuevas.isNotEmpty)
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: '1.ª vez: '),
                      TextSpan(
                        text: pts(DemoStore.puntosPrimeraVez),
                        style: const TextStyle(color: PdColor.acentoOscuro, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  style: letra(12.5, FontWeight.w400, PdColor.textoSecundario),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, f) in Funcion.values.indexed) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: Presionable(
                    onTap: () {
                      if (nuevas.contains(f)) {
                        store.usarFuncion(f);
                        avisoBreve(context, '${pts(DemoStore.puntosPrimeraVez)} por usar ${f.nombre} por 1.ª vez.');
                      } else {
                        avisoFueraDeDemo(context, f.nombre);
                      }
                    },
                    radio: 16,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: PdColor.superficie,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: f.borde, width: 2),
                                ),
                                child: IconoPd(f.icono, tamano: 24, color: f.color),
                              ),
                              if (nuevas.contains(f))
                                Positioned(
                                  top: -6,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: PdColor.acentoPalido,
                                      borderRadius: BorderRadius.circular(PdRadio.pildora),
                                      border: Border.all(color: PdColor.fondo, width: 2),
                                    ),
                                    child: Text('+100', style: letra(10, FontWeight.w700, PdColor.acentoOscuro)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Como en CSS (min-width: 0): «Parquímetros» puede pasar un poco del
                        // ancho de su columna sin cortarse.
                        Text(
                          f.nombre,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: letra(11.5, FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BotonWisi extends StatelessWidget {
  const _BotonWisi();

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: () => context.push('/wisi'),
      etiqueta: 'Hablar con Wisi por WhatsApp',
      radio: PdRadio.pildora,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
        decoration: BoxDecoration(
          color: PdColor.superficie,
          borderRadius: BorderRadius.circular(PdRadio.pildora),
          boxShadow: sombraCss(4, 14, const Color.fromRGBO(28, 27, 46, 0.16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: PdColor.exito, shape: BoxShape.circle),
              child: const IconoPd(Ico.chat, tamano: 16, color: Colors.white),
            ),
            const SizedBox(width: 5),
            Text('Wisi', style: letra(13, FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
