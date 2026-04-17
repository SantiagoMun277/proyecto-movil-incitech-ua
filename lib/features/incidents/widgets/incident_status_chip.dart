import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';


class IncidentStatusChip extends StatelessWidget {
  const IncidentStatusChip({
    super.key,
    required this.status,
  });

  final IncidentStatus status;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = switch (status) {
      IncidentStatus.reportado => const Color(0xFFF47E7E),
      IncidentStatus.enProceso => const Color(0xFFECC766),
      IncidentStatus.resuelto => const Color(0xFF84E5A0),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black54, width: 0.8),
      ),
      child: Text(
        status.label,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Times New Roman',
          color: Colors.black,
        ),
      ),
    );
  }
}