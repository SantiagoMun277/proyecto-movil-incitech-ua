
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';


import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';

class IncidentStatusChip extends StatelessWidget {
  const IncidentStatusChip({
    super.key,
    required this.status,
  });

  final IncidentStatus status;

  static const Color _borderColor = AppColors.borderDark;
  static const Color _textColor = AppColors.textDark;

  Color get _backgroundColor {
    switch (status) {
      case IncidentStatus.reportado:
        return AppColors.chipRed;
      case IncidentStatus.enProceso:
        return AppColors.chipYellow;
      case IncidentStatus.resuelto:
        return AppColors.chipGreen;
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
          fontFamily: AppTextStyles.fontFamily,
          color: _textColor,
        ),
      ),
    );
  }
}


