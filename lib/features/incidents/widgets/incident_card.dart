import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';

import 'package:my_app_incitech_ua/features/incidents/widgets/incident_image.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/incident_status_chip.dart';

class IncidentCard extends StatelessWidget {
  const IncidentCard({
    super.key,
    required this.incident,
    required this.onTap,
  });

  final IncidentItem incident;
  final VoidCallback onTap;

  static const Color _cardColor = Color(0xFFF2F2F2);
  static const Color _shadowGreen = Color(0x664FA96A);
  static const Color _textColor = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double unifiedFontSize = screenWidth * 0.040;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: _shadowGreen,
                offset: Offset(4, 5),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: unifiedFontSize * 1.03,
                            fontFamily: 'Times New Roman',
                            color: _textColor,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Titulo: ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: incident.title),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: unifiedFontSize * 1.03,
                            fontFamily: 'Times New Roman',
                            color: _textColor,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Fecha: ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: incident.date.split(' ').first),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: unifiedFontSize * 1.03,
                            fontFamily: 'Times New Roman',
                            color: _textColor,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Ubicación: ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: incident.location),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      IncidentStatusChip(status: incident.status),
                    ],
                  ),
                ),
              ),
              IncidentImage(imagePath: incident.imagePath),
            ],
          ),
        ),
      ),
    );
  }
}