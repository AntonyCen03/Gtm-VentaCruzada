import 'package:flutter/material.dart';

import '../componentes/icono.dart';

enum EstadoPago { pendiente, programado, pagado }

/// Factura de un servicio afiliado. Montos en céntimos.
class Pago {
  const Pago({
    required this.id,
    required this.empresa,
    required this.referencia,
    required this.centimos,
    required this.vence,
    required this.puntos,
    required this.icono,
    this.prioritario = false,
    this.estado = EstadoPago.pendiente,
    this.alias,
  });

  final String id;
  final String empresa;

  /// «Contrato 3001 4582 77», «Línea 0414 ••• 4521».
  final String referencia;
  final int centimos;
  final DateTime vence;

  /// Puntos del Club por pagarlo en PagoDirecto.
  final int puntos;
  final Ico icono;

  /// Riesgo de corte del servicio: su vencimiento se marca en rosa.
  final bool prioritario;
  final EstadoPago estado;
  final String? alias;

  Pago copyWith({EstadoPago? estado, String? alias}) => Pago(
    id: id,
    empresa: empresa,
    referencia: referencia,
    centimos: centimos,
    vence: vence,
    puntos: puntos,
    icono: icono,
    prioritario: prioritario,
    estado: estado ?? this.estado,
    alias: alias ?? this.alias,
  );
}

/// Algo que vence pronto y que PagoDirecto también puede pagar (RCV).
class Sugerencia {
  const Sugerencia({required this.titulo, required this.vence, required this.puntos});

  final String titulo;
  final DateTime vence;
  final int puntos;
}

enum AccionMision { pagarServicio, renovarRcv, verificarVehiculo }

class Mision {
  const Mision({
    required this.id,
    required this.titulo,
    required this.detalle,
    required this.puntos,
    required this.icono,
    required this.accion,
  });

  final String id;
  final String titulo;
  final String detalle;
  final int puntos;
  final Ico icono;
  final AccionMision accion;
}

class Canje {
  const Canje({required this.titulo, required this.puntos, this.credirecto = false});

  final String titulo;
  final int puntos;
  final bool credirecto;
}

/// Ajustes de P8. «Nunca mientras manejo» no es un ajuste: siempre está activo.
class AjustesAvisos {
  AjustesAvisos({
    this.resumenSemanal = true,
    this.dia = DateTime.sunday,
    this.hora = const TimeOfDay(hour: 18, minute: 0),
    this.enApp = true,
    this.whatsapp = true,
    this.servicios = true,
    this.seguros = true,
    this.parquimetros = false,
  });

  bool resumenSemanal;
  int dia;
  TimeOfDay hora;
  bool enApp;
  bool whatsapp;
  bool servicios;
  bool seguros;
  bool parquimetros;

  static const dias = [DateTime.sunday, DateTime.monday, DateTime.friday];
  static const horas = [TimeOfDay(hour: 18, minute: 0), TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 12, minute: 0)];
}

enum TipoMensaje {
  /// Mensaje del domingo: el premio del Club como gancho, sin hablar de deudas.
  premio,
  texto,
}

class MensajeChat {
  const MensajeChat({required this.deWisi, required this.texto, required this.hora, this.tipo = TipoMensaje.texto});

  final bool deWisi;
  final String texto;
  final String hora;
  final TipoMensaje tipo;
}

class TicketEstacionamiento {
  const TicketEstacionamiento({
    required this.lugar,
    required this.centimos,
    required this.servicioCentimos,
    required this.comprobante,
  });

  final String lugar;
  final int centimos;

  /// Comisión del servicio PagoDirecto.
  final int servicioCentimos;
  final String comprobante;
}

enum MetodoPago { pagoDirecto, credirecto }

/// Accesos de «Funciones» en el Inicio, con los colores del mockup.
enum Funcion {
  servicios('Servicios', Ico.servicios, Color(0xFFEE8A3A), Color(0xFFE07A26)),
  parquimetros('Parquímetros', Ico.parquimetro, Color(0xFF6E83DA), Color(0xFF4A60C4)),
  seguros('Seguros', Ico.seguros, Color(0xFF7B5CC8), Color(0xFF6343B5)),
  boleteria('Boletería', Ico.boleteria, Color(0xFFE8607A), Color(0xFFD6305B)),
  donaciones('Donaciones', Ico.donaciones, Color(0xFF2FA57A), Color(0xFF23805E));

  const Funcion(this.nombre, this.icono, this.borde, this.color);
  final String nombre;
  final Ico icono;
  final Color borde;
  final Color color;
}

/// Resumen que P7 muestra después de pagar.
class ResultadoPago {
  const ResultadoPago({
    required this.pagos,
    required this.puntosAntes,
    required this.puntosGanados,
    required this.rachaNueva,
    required this.premio,
  });

  final List<Pago> pagos;
  final int puntosAntes;
  final int puntosGanados;
  final int rachaNueva;

  /// Pagó todo lo de la semana: la racha sube y gana un estacionamiento sin servicio.
  final bool premio;

  int get totalCentimos => pagos.fold(0, (s, p) => s + p.centimos);
}

/// Estado mutable de una persona de la demo. Se recrea al reiniciar.
class Perfil {
  Perfil({
    required this.id,
    required this.usuario,
    required this.nombre,
    required this.saldoCentimos,
    required this.ticketsCredirecto,
    required this.racha,
    required this.puntos,
    required this.vehiculo,
    required this.telefono,
    required this.pagos,
    required this.operadoras,
    required this.misiones,
    required this.funcionesNuevas,
    this.sugerencia,
    AjustesAvisos? ajustes,
  }) : ajustes = ajustes ?? AjustesAvisos();

  final String id;
  final String usuario;
  final String nombre;
  int saldoCentimos;
  int ticketsCredirecto;
  int racha;
  int puntos;
  final String vehiculo;
  final String telefono;
  List<Pago> pagos;

  /// Accesos de recarga sin deuda (Digitel, Movilnet…).
  final List<String> operadoras;
  List<Mision> misiones;

  /// Funciones que la persona aún no ha usado: muestran «+100».
  final Set<Funcion> funcionesNuevas;
  Sugerencia? sugerencia;
  final AjustesAvisos ajustes;
  final List<MensajeChat> chat = [];

  /// Premio de P7: el próximo estacionamiento no paga el servicio PagoDirecto.
  bool estacionamientoSinServicio = false;
  ResultadoPago? ultimoPago;
  int? ultimoEstacionamientoCentimos;

  final String nivel = 'Nivel Turista';
  static const puntosSiguienteNivel = 2000;
}
