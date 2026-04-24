import 'package:flutter/material.dart';

class ReportResultDialog extends StatelessWidget {
  const ReportResultDialog({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.buttonText,
    this.onButtonPressed,
  });

  final bool isSuccess;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  static const Color _green = Color(0xFF0C7A27);
  static const Color _textColor = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final titleSize = w * 0.075;
    final textSize = w * 0.048;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -4,
              right: -6,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      color: isSuccess
                          ? const Color(0xFFD9F3E3)
                          : const Color(0xFFFFD9D9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSuccess ? Icons.check : Icons.close,
                      size: 74,
                      color: isSuccess
                          ? const Color(0xFF0B5E2A)
                          : const Color(0xFFD91F1F),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w700,
                      color: isSuccess
                          ? const Color(0xFF10301B)
                          : const Color(0xFF5A1111),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textSize,
                      fontFamily: 'Times New Roman',
                      color: _textColor,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onButtonPressed ??
                          () {
                            Navigator.pop(context);
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: textSize * 1.05,
                          fontFamily: 'Times New Roman',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}