import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

class GpsLocationRow extends StatelessWidget {
  const GpsLocationRow({
    super.key,
    required this.fontSize,
    required this.onTap,
    this.isLoading = false,
  });

  final double fontSize;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Usar mi ubicación GPS',
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textDark,
              ),
            ),
          ),
          InkWell(
            onTap: isLoading ? null : onTap,
            child: Container(
              width: 56,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.mediumGray,
                border: Border.all(color: AppColors.borderStrong, width: 1),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 34,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
