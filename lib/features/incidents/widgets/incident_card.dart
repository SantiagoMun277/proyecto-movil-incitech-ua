import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
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

  String get _fechaCorta {
    final value = incident.date.trim();
    if (value.isEmpty) return '';
    return value.split(' ').first;
  }

  bool get _tieneUbicacion {
    return incident.location.trim().isNotEmpty;
  }

  String get _imageKeyValue {
    final path = incident.imagePath ?? '';
    final updateDate = incident.rawData['fechaActualizacion']?.toString() ??
        incident.rawData['updatedAt']?.toString() ??
        '';

    return '${incident.id}_${path}_$updateDate';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth * 0.036;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 96,
          ),
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          decoration: BoxDecoration(
            color: AppColors.softWhite,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowGreen,
                offset: Offset(3, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextLine(
                        label: 'Titulo:',
                        value: incident.title,
                        fontSize: fontSize,
                        maxLines: 2,
                      ),
                      if (_fechaCorta.isNotEmpty)
                        _buildTextLine(
                          label: 'Fecha:',
                          value: _fechaCorta,
                          fontSize: fontSize,
                          maxLines: 1,
                        ),
                      if (_tieneUbicacion)
                        _buildTextLine(
                          label: 'Ubicación:',
                          value: incident.location,
                          fontSize: fontSize,
                          maxLines: 1,
                        ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 25,
                        child: IncidentStatusChip(
                          status: incident.status,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IncidentImage(
                key: ValueKey(_imageKeyValue),
                imagePath: incident.imagePath,
                width: 99,
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextLine({
    required String label,
    required String value,
    required double fontSize,
    required int maxLines,
  }) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: AppTextStyles.extraBold(fontSize),
            ),
            TextSpan(
              text: cleanValue,
              style: AppTextStyles.regular(fontSize),
            ),
          ],
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
