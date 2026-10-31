import 'dart:async';

import 'package:flutter/material.dart';

import '../tema/formato.dart';
import 'datos_demo.dart';
import 'modelos.dart';

enum EstadoDatos { listo, cargando, error }

/// Única fuente de verdad de la demo. Hace de «backend» simulado: todo total,
/// punto y racha que aparece en pantalla se calcula aquí.
class DemoStore extends ChangeNotifier {
  DemoStore() {
    _perfiles = _crearPerfiles();
  }

  late Map<String, Perfil> _perfiles;
  String _perfilId = 'maria';

  DateTime get hoy => hoyDemo;
  Perfil get perfil => _perfiles[_perfilId]!;
  String get perfilId => _perfilId;

  /// Estados forzados desde el menú de demo para enseñar carga y error.
  EstadoDatos estadoMisPagos = EstadoDatos.listo;
  bool fallarBusqueda = false;

  /// Después de pagar el estacionamiento no se muestra ningún aviso (A3).
  bool manejando = false;
  bool wisiEscribiendo = false;

  static Map<String, Perfil> _crearPerfiles() => {'maria': perfilMaria(), 'carlos': perfilCarlos()};

  // ── Lecturas ──

  /// Como en el mockup: primero lo que tiene riesgo de corte, luego por fecha.
  List<Pago> _conEstado(EstadoPago e) => perfil.pagos.where((p) => p.estado == e).toList()
    ..sort((a, b) {
      if (a.prioritario != b.prioritario) return a.prioritario ? -1 : 1;
      return a.vence.compareTo(b.vence);
    });

  List<Pago> get pendientes => _conEstado(EstadoPago.pendiente);
  List<Pago> get programados => _conEstado(EstadoPago.programado);
  List<Pago> get pagados => _conEstado(EstadoPago.pagado);

  int get totalPendiente => pendientes.fold(0, (s, p) => s + p.centimos);
  int get puntosPendientes => pendientes.fold(0, (s, p) => s + p.puntos);
  int get pendientesEstaSemana =>
      pendientes.where((p) => p.vence.difference(DateUtils.dateOnly(hoy)).inDays < 7).length;

  /// Sin ningún servicio afiliado todavía: el primero da +200 pts.
  bool get primerServicio => perfil.pagos.isEmpty;
  static const puntosPrimerServicio = 200;
  static const puntosPrimeraVez = 100;

  /// Las misiones de pagar un servicio desaparecen cuando ya está pagado.
  List<Mision> get misiones => perfil.misiones
      .where((m) => m.accion != AccionMision.pagarServicio || pendientes.any((p) => p.id == m.id))
      .toList();

  /// La del Inicio: la primera que no repite lo que ya está en Mis pagos.
  Mision? get misionDestacada {
    final m = misiones.where((m) => m.accion != AccionMision.pagarServicio);
    return m.isEmpty ? null : m.first;
  }

  int get puntosFaltantes => (Perfil.puntosSiguienteNivel - perfil.puntos).clamp(0, 1 << 30);
  double get progresoNivel => (perfil.puntos / Perfil.puntosSiguienteNivel).clamp(0, 1);

  int get servicioEstacionamiento => perfil.estacionamientoSinServicio ? 0 : ticketDemo.servicioCentimos;
  int get totalEstacionamiento => ticketDemo.centimos + servicioEstacionamiento;

  // ── Acciones ──

  void cambiarPerfil(String id, {bool notificar = true}) {
    if (id == _perfilId || !_perfiles.containsKey(id)) return;
    _perfilId = id;
    manejando = false;
    if (notificar) notifyListeners();
  }

  void reiniciar() {
    _perfiles = _crearPerfiles();
    estadoMisPagos = EstadoDatos.listo;
    fallarBusqueda = false;
    manejando = false;
    wisiEscribiendo = false;
    notifyListeners();
  }

  void forzarEstadoMisPagos(EstadoDatos e) {
    estadoMisPagos = e;
    notifyListeners();
  }

  void forzarFalloBusqueda(bool v) {
    fallarBusqueda = v;
    notifyListeners();
  }

  /// Lo que muestra P7: el último pago o, si se llega directo, lo pendiente.
  ResultadoPago get resumenPago =>
      perfil.ultimoPago ??
      ResultadoPago(
        pagos: pendientes,
        puntosAntes: perfil.puntos,
        puntosGanados: puntosPendientes,
        rachaNueva: perfil.racha + 1,
        premio: true,
      );

  /// Devuelve los puntos ganados.
  int completarMision(Mision m) {
    perfil.misiones = perfil.misiones.where((x) => x.id != m.id).toList();
    perfil.puntos += m.puntos;
    notifyListeners();
    return m.puntos;
  }

  /// Devuelve false si no alcanzan los puntos.
  bool canjear(Canje c) {
    if (perfil.puntos < c.puntos) return false;
    perfil.puntos -= c.puntos;
    if (c.credirecto) {
      perfil.ticketsCredirecto += 1;
    } else {
      perfil.estacionamientoSinServicio = true;
    }
    notifyListeners();
    return true;
  }

  void usarFuncion(Funcion f) {
    if (!perfil.funcionesNuevas.remove(f)) return;
    perfil.puntos += puntosPrimeraVez;
    notifyListeners();
  }

  void descartarSugerencia() {
    perfil.sugerencia = null;
    notifyListeners();
  }

  /// Búsqueda simulada de la factura por número de contrato (P3).
  Future<Pago> buscarFactura(String servicio, String contrato) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (fallarBusqueda) throw StateError('No pudimos consultar $servicio en este momento.');
    return facturaDe(servicio, contrato);
  }

  /// Devuelve los puntos ganados por afiliar.
  int afiliar(Pago factura, {String? alias}) {
    final ganados = primerServicio ? puntosPrimerServicio : 0;
    perfil.pagos = [...perfil.pagos.where((p) => p.id != factura.id), factura.copyWith(alias: alias)];
    perfil.puntos += ganados;
    manejando = false;
    notifyListeners();
    return ganados;
  }

  ResultadoPago pagar(Iterable<String> ids, MetodoPago metodo) {
    final aPagar = pendientes.where((p) => ids.contains(p.id)).toList();
    final total = aPagar.fold(0, (s, p) => s + p.centimos);
    final ganados = aPagar.fold(0, (s, p) => s + p.puntos);
    final resultado = ResultadoPago(
      pagos: aPagar,
      puntosAntes: perfil.puntos,
      puntosGanados: ganados,
      rachaNueva: aPagar.length == pendientes.length ? perfil.racha + 1 : perfil.racha,
      premio: aPagar.length == pendientes.length,
    );

    perfil.pagos = [
      for (final p in perfil.pagos) aPagar.any((x) => x.id == p.id) ? p.copyWith(estado: EstadoPago.pagado) : p,
    ];
    perfil.puntos += ganados;
    if (metodo == MetodoPago.pagoDirecto) {
      perfil.saldoCentimos -= total;
    } else {
      perfil.ticketsCredirecto -= 1;
    }
    if (resultado.premio) {
      perfil.racha = resultado.rachaNueva;
      perfil.estacionamientoSinServicio = true;
    }
    perfil.ultimoPago = resultado;
    notifyListeners();
    return resultado;
  }

  void cambiarAjustes(void Function(AjustesAvisos a) cambio) {
    cambio(perfil.ajustes);
    notifyListeners();
  }

  /// El mensaje del domingo llega a la hora elegida en Tus avisos.
  void abrirChat() {
    if (perfil.chat.isNotEmpty) return;
    perfil.chat.add(
      MensajeChat(
        deWisi: true,
        texto: '¡Hola, ${perfil.nombre}!',
        hora: hora(perfil.ajustes.hora),
        tipo: TipoMensaje.premio,
      ),
    );
  }

  String get _horaRespuesta {
    final h = perfil.ajustes.hora;
    final minutos = h.hour * 60 + h.minute + 2;
    return hora(TimeOfDay(hour: minutos ~/ 60 % 24, minute: minutos % 60));
  }

  /// Texto libre: en la demo Wisi responde siempre lo mismo.
  Future<void> escribirAWisi(String texto) async {
    if (texto.trim().isEmpty || wisiEscribiendo) return;
    perfil.chat.add(MensajeChat(deWisi: false, texto: texto.trim(), hora: _horaRespuesta));
    wisiEscribiendo = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    perfil.chat.add(
      MensajeChat(
        deWisi: true,
        texto: 'Toca «Más información» y te cuento cómo sumar puntos en el Club con tus pagos.',
        hora: _horaRespuesta,
      ),
    );
    wisiEscribiendo = false;
    notifyListeners();
  }

  void pagarEstacionamiento(MetodoPago metodo) {
    perfil.ultimoEstacionamientoCentimos = totalEstacionamiento;
    if (metodo == MetodoPago.pagoDirecto) {
      perfil.saldoCentimos -= totalEstacionamiento;
    } else {
      perfil.ticketsCredirecto -= 1;
    }
    perfil.estacionamientoSinServicio = false;
    manejando = true;
    notifyListeners();
  }
}

/// Expone el [DemoStore] al árbol de widgets.
class Demo extends InheritedNotifier<DemoStore> {
  const Demo({super.key, required DemoStore store, required super.child}) : super(notifier: store);

  /// Lee y se suscribe: el widget se reconstruye con cada cambio.
  static DemoStore of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Demo>()!.notifier!;

  /// Solo lee, para acciones dentro de callbacks.
  static DemoStore leer(BuildContext context) => context.getInheritedWidgetOfExactType<Demo>()!.notifier!;
}
