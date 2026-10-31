import 'package:flutter/material.dart';

import '../tema/tokens.dart';
import 'icono.dart';

/// Avatar con la insignia de racha (semanas al día) en la esquina.
class AvatarRacha extends StatelessWidget {
  const AvatarRacha({super.key, required this.racha});

  final int racha;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Racha de $racha ${racha == 1 ? 'semana' : 'semanas'} al día',
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9EE),
                shape: BoxShape.circle,
                border: Border.all(color: PdColor.superficie, width: 3),
                boxShadow: sombraCss(2, 8, const Color.fromRGBO(28, 27, 46, 0.10)),
              ),
              child: const IconoPd(Ico.persona, tamano: 22, color: PdColor.iconoApagado),
            ),
            if (racha > 0)
              Positioned(
                right: -10,
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(4, 1, 6, 1),
                  decoration: BoxDecoration(
                    color: PdColor.acento,
                    borderRadius: BorderRadius.circular(PdRadio.pildora),
                    border: Border.all(color: PdColor.fondo, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const IconoPd(Ico.racha, tamano: 11, color: PdColor.superficie),
                      const SizedBox(width: 1),
                      Text('$racha', style: PdTexto.pastilla.copyWith(color: PdColor.superficie)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
