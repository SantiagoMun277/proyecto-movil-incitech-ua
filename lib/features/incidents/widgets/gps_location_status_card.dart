import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

class GpsLocationStatusCard extends StatelessWidget {
  const GpsLocationStatusCard({
    super.key,
    required this.fontSize,
    required this.isRegistered,
    this.latitude,
    this.longitude,
    this.onOpenMap,
  });

  final double fontSize;
  final bool isRegistered;
  final double? latitude;
  final double? longitude;
  final VoidCallback? onOpenMap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isRegistered
        ? const Color(0xFFDDF3E2)
        : const Color(0xFFF6E4E4);

    final borderColor = isRegistered
        ? Colors.green
        : Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRegistered
                ? 'Ubicación GPS registrada'
                : 'Ubicación GPS no registrada',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          if (isRegistered && latitude != null && longitude != null) ...[
            const SizedBox(height: 6),
            Text(
              'Lat: ${latitude!.toStringAsFixed(6)}',
              style: TextStyle(
                fontSize: fontSize * 0.95,
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textDark,
              ),
            ),
            Text(
              'Lng: ${longitude!.toStringAsFixed(6)}',
              style: TextStyle(
                fontSize: fontSize * 0.95,
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textDark,
              ),
            ),
          ],
          if (onOpenMap != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: onOpenMap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreenAlt,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  isRegistered ? 'Ver / ajustar en mapa' : 'Abrir mapa',
                  style: TextStyle(
                    fontSize: fontSize * 0.90,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


