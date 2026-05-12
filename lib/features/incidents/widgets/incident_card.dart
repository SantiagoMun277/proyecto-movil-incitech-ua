

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

  bool get _tieneFecha => _fechaCorta.isNotEmpty;

  bool get _tieneUbicacion => incident.location.trim().isNotEmpty;

  bool get _tieneTipo => incident.type.trim().isNotEmpty;

  String get _tituloLimpio {
    final value = incident.title.trim();
    return value.isEmpty ? 'Sin título' : value;
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

    final double titleSize = screenWidth < 360 ? 15.5 : 17.5;
    final double bodySize = screenWidth < 360 ? 12.5 : 13.5;
    final double imageHeight = screenWidth < 360 ? 170 : 190;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: AppColors.primaryGreen.withOpacity(0.08),
        highlightColor: AppColors.primaryGreen.withOpacity(0.04),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.softWhite,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.borderColor.withOpacity(0.40),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowGreen.withOpacity(0.22),
                offset: const Offset(0, 8),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(
                  imageHeight: imageHeight,
                  titleSize: titleSize,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoPanel(bodySize),
                      const SizedBox(height: 12),
                      _buildActionHint(bodySize),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection({
    required double imageHeight,
    required double titleSize,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            IncidentImage(
              key: ValueKey(_imageKeyValue),
              imagePath: incident.imagePath,
              width: constraints.maxWidth,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.02),
                      Colors.black.withOpacity(0.10),
                      Colors.black.withOpacity(0.60),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              top: 12,
              child: Center(
                child: IncidentStatusChip(
                  status: incident.status,
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Text(
                _tituloLimpio,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.extraBold(
                  titleSize,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoPanel(double fontSize) {
    final rows = <Widget>[];

    if (_tieneFecha) {
      rows.add(
        _buildInfoRow(
          icon: Icons.calendar_today_rounded,
          label: 'Fecha:',
          value: _fechaCorta,
          fontSize: fontSize,
        ),
      );
    }

    if (_tieneUbicacion) {
      rows.add(
        _buildInfoRow(
          icon: Icons.location_on_outlined,
          label: 'Ubicación:',
          value: incident.location,
          fontSize: fontSize,
        ),
      );
    }

    if (_tieneTipo) {
      rows.add(
        _buildInfoRow(
          icon: Icons.account_tree_outlined,
          label: 'Tipo:',
          value: incident.type,
          fontSize: fontSize,
        ),
      );
    }

    if (rows.isEmpty) {
      rows.add(
        _buildInfoRow(
          icon: Icons.info_outline_rounded,
          label: 'Información:',
          value: 'Sin datos adicionales',
          fontSize: fontSize,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.panelLight.withOpacity(0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.30),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.borderColor.withOpacity(0.22),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required double fontSize,
  }) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: AppTextStyles.extraBold(
                    fontSize,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: cleanValue,
                  style: AppTextStyles.regular(
                    fontSize,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionHint(double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.visibility_outlined,
            size: 19,
            color: AppColors.white,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Ver detalle del incidente',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.button(
                fontSize,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 18,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}