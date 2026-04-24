import 'package:flutter/material.dart';

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

  static const Color _textColor = Color(0xFF222222);
  static const Color _borderColor = Color(0xFF4E4E4E);

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
                fontFamily: 'Times New Roman',
                color: _textColor,
              ),
            ),
          ),
          InkWell(
            onTap: isLoading ? null : onTap,
            child: Container(
              width: 56,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFDADADA),
                border: Border.all(color: _borderColor, width: 1),
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