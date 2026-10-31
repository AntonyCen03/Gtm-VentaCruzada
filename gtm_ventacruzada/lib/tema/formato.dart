import 'package:flutter/material.dart';

/// Formato único de la demo (H6): «Bs 1.240,50», «Vence el jueves», «6:00 p. m.».
/// Los montos viajan siempre en céntimos para que los totales cuadren.

const _dias = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
const _diasCortos = ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'];
const _meses = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

/// 1240 → «1.240».
String miles(int n) {
  final s = n.abs().toString();
  final grupos = <String>[];
  for (var fin = s.length; fin > 0; fin -= 3) {
    grupos.insert(0, s.substring(fin - 3 < 0 ? 0 : fin - 3, fin));
  }
  return '${n < 0 ? '−' : ''}${grupos.join('.')}';
}

/// 124050 → «Bs 1.240,50».
String bs(int centimos) {
  final decimales = (centimos.abs() % 100).toString().padLeft(2, '0');
  final enteros = miles(centimos.abs() ~/ 100);
  return '${centimos < 0 ? '−' : ''}Bs $enteros,$decimales';
}

/// Variante con punto que usa el mockup en Mis pagos, Añadir directorio y Wisi: «Bs. 1.240,50».
String bsPunto(int centimos) => bs(centimos).replaceFirst('Bs ', 'Bs. ');

/// 300 → «+300 pts».
String pts(int puntos, {bool signo = true}) => '${signo && puntos > 0 ? '+' : ''}${miles(puntos)} pts';

String diaSemana(DateTime d) => _dias[d.weekday - 1];

String diaSemanaCapital(DateTime d) => mayuscula(diaSemana(d));

String nombreDia(int weekday) => mayuscula(_dias[weekday - 1]);

/// «15 de noviembre».
String fechaLarga(DateTime d) => '${d.day} de ${_meses[d.month - 1]}';

/// Dentro de la semana nombra el día; si no, la fecha.
String venceCorto(DateTime vence, DateTime hoy) => _enLaSemana(vence, hoy)
    ? 'Vence ${_diasCortos[vence.weekday - 1]}'
    : 'Vence ${vence.day} ${_meses[vence.month - 1].substring(0, 3)}';

String venceLargo(DateTime vence, DateTime hoy) =>
    _enLaSemana(vence, hoy) ? 'Vence el ${diaSemana(vence)}' : 'Vence el ${fechaLarga(vence)}';

bool _enLaSemana(DateTime vence, DateTime hoy) {
  final dias = DateUtils.dateOnly(vence).difference(DateUtils.dateOnly(hoy)).inDays;
  return dias >= 0 && dias < 7;
}

/// 18:00 → «6:00 p. m.»; 12:00 → «12:00 m.».
String hora(TimeOfDay t) {
  final minutos = t.minute.toString().padLeft(2, '0');
  // Espacios duros: «8:00 a. m.» nunca se parte entre dos líneas.
  if (t.hour == 12 && t.minute == 0) return '12:00\u00A0m.';
  final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  return '$h:$minutos\u00A0${t.period == DayPeriod.am ? 'a.\u00A0m.' : 'p.\u00A0m.'}';
}

/// Hora de la pantalla de bloqueo, sin a. m./p. m.: «6:00».
String horaReloj(TimeOfDay t) => '${t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod}:${t.minute.toString().padLeft(2, '0')}';

String mayuscula(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
