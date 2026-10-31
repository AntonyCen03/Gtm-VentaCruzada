import '../componentes/icono.dart';
import 'modelos.dart';

/// Datos de demo (docs/PLAN_UI.md §10). Fecha simulada: domingo 1 nov 2026, 6:00 p. m.
final hoyDemo = DateTime(2026, 11, 1, 18);

const ticketDemo = TicketEstacionamiento(
  lugar: 'CCCT',
  centimos: 124160,
  servicioCentimos: 41387,
  comprobante: 'PD-48213',
);

const canjesDemo = [
  Canje(titulo: 'Estacionamiento sin servicio PagoDirecto', puntos: 600),
  Canje(titulo: '1 ticket extra de Credirecto', puntos: 1500, credirecto: true),
];

/// Premio que Wisi usa de gancho en WhatsApp (P5).
const premioWisi = (texto: 'un boleto para el concierto de Karol G', puntos: 1000);

/// Servicios que se pueden afiliar en P3 y la factura que «encuentra» la búsqueda.
const serviciosAfiliables = ['Corpoelec', 'Movistar', 'CANTV', 'Hidrocapital'];

Pago facturaDe(String servicio, String contrato) {
  final referencia = 'Contrato $contrato';
  return switch (servicio) {
    'Movistar' => Pago(
      id: 'movistar',
      empresa: 'Movistar',
      referencia: referencia,
      centimos: 62990,
      vence: DateTime(2026, 11, 3),
      puntos: 300,
      icono: Ico.telefono,
    ),
    'CANTV' => Pago(
      id: 'cantv',
      empresa: 'CANTV',
      referencia: referencia,
      centimos: 38500,
      vence: DateTime(2026, 11, 6),
      puntos: 200,
      icono: Ico.telefono,
    ),
    'Hidrocapital' => Pago(
      id: 'hidrocapital',
      empresa: 'Hidrocapital',
      referencia: referencia,
      centimos: 21075,
      vence: DateTime(2026, 11, 10),
      puntos: 200,
      icono: Ico.servicios,
    ),
    _ => Pago(
      id: 'corpoelec',
      empresa: 'Corpoelec',
      referencia: referencia,
      centimos: 124050,
      vence: DateTime(2026, 11, 5),
      puntos: 300,
      icono: Ico.rayo,
      prioritario: true,
    ),
  };
}

const _misionRcv = Mision(
  id: 'rcv',
  titulo: 'Renueva tu RCV aquí',
  detalle: 'Vence el 15 de noviembre',
  puntos: 500,
  icono: Ico.escudo,
  accion: AccionMision.renovarRcv,
);

Perfil perfilMaria() => Perfil(
  id: 'maria',
  usuario: 'maria',
  nombre: 'María',
  saldoCentimos: 2543000,
  ticketsCredirecto: 2,
  racha: 3,
  puntos: 1250,
  vehiculo: 'AB123CD',
  telefono: '0414 ••• 4521',
  pagos: [
    facturaDe('Corpoelec', '3001 4582 77'),
    Pago(
      id: 'movistar',
      empresa: 'Movistar',
      referencia: 'Línea 0414 ••• 4521',
      centimos: 62990,
      vence: DateTime(2026, 11, 3),
      puntos: 300,
      icono: Ico.telefono,
    ),
  ],
  operadoras: const ['Digitel', 'Movilnet'],
  funcionesNuevas: {Funcion.parquimetros, Funcion.boleteria},
  sugerencia: Sugerencia(titulo: 'Seguro RCV · AB123CD', vence: DateTime(2026, 11, 15), puntos: 500),
  misiones: const [
    Mision(
      id: 'corpoelec',
      titulo: 'Paga tu Corpoelec aquí',
      detalle: 'Vence el jueves',
      puntos: 300,
      icono: Ico.rayo,
      accion: AccionMision.pagarServicio,
    ),
    _misionRcv,
    Mision(
      id: 'vehiculo',
      titulo: 'Verifica tu vehículo',
      detalle: 'Misión actual del Club',
      puntos: 250,
      icono: Ico.vehiculo,
      accion: AccionMision.verificarVehiculo,
    ),
  ],
);

Perfil perfilCarlos() => Perfil(
  id: 'carlos',
  usuario: 'carlos',
  nombre: 'Carlos',
  saldoCentimos: 312000,
  ticketsCredirecto: 2,
  racha: 1,
  puntos: 250,
  vehiculo: 'AB123CD',
  telefono: '0412 ••• 7310',
  pagos: [],
  operadoras: const ['Digitel', 'Movilnet', 'Movistar'],
  funcionesNuevas: {Funcion.servicios, Funcion.parquimetros, Funcion.seguros, Funcion.boleteria},
  misiones: const [
    Mision(
      id: 'vehiculo',
      titulo: 'Verifica tu vehículo',
      detalle: 'AB123CD, con la que estacionas',
      puntos: 250,
      icono: Ico.vehiculo,
      accion: AccionMision.verificarVehiculo,
    ),
    _misionRcv,
  ],
);
