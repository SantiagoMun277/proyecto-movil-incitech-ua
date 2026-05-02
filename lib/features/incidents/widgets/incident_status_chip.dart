// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';


// class IncidentStatusChip extends StatelessWidget {
//   const IncidentStatusChip({
//     super.key,
//     required this.status,
//   });

//   final IncidentStatus status;

//   @override
//   Widget build(BuildContext context) {
//     final Color backgroundColor = switch (status) {
//       IncidentStatus.reportado => const Color(0xFFF47E7E),
//       IncidentStatus.enProceso => const Color(0xFFECC766),
//       IncidentStatus.resuelto => const Color(0xFF84E5A0),
//     };

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.black54, width: 0.8),
//       ),
//       child: Text(
//         status.label,
//         style: const TextStyle(
//           fontSize: 14,
//           fontFamily: 'Times New Roman',
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';

class IncidentStatusChip extends StatelessWidget {
  const IncidentStatusChip({
    super.key,
    required this.status,
  });

  final IncidentStatus status;

  static const Color _borderColor = Color(0xFF3D3D3D);
  static const Color _textColor = Color(0xFF222222);

  Color get _backgroundColor {
    switch (status) {
      case IncidentStatus.reportado:
        return const Color(0xFFF47E7E);
      case IncidentStatus.enProceso:
        return const Color(0xFFE5C469);
      case IncidentStatus.resuelto:
        return const Color(0xFF84E09E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 95,
        minHeight: 24,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        status.label,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Times New Roman',
          color: _textColor,
        ),
      ),
    );
  }
}