
// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
// import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   static const Color backgroundColor = AppColors.backgroundGreenAlt;
//   static const Color buttonColor = AppColors.primaryGreenAltDark;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final w = constraints.maxWidth;
//             final h = constraints.maxHeight;

//             return Stack(
//               children: [
//                 // Logo superior
//                 Positioned(
//                   top: h * 0.01,
//                   left: w * 0.10,
//                   child: Image.asset(
//                     'assets/images/logo_incitech.png',
//                     width: w * 0.80,
//                     fit: BoxFit.contain,
//                   ),
//                 ),

//                 // Imagen de fondo UA
//                 Positioned.fill(
//                   child: IgnorePointer(
//                     child: Align(
//                       alignment: const Alignment(0, 0.02),
//                       child: Opacity(
//                         opacity: 0.28,
//                         child: Image.asset(
//                           'assets/images/fondo_bienvenida.png',
//                           width: w * 1.50,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Texto
//                 Positioned(
//                   top: h * 0.34,
//                   left: w * 0.18,
//                   right: w * 0.16,
//                   child: const Text(
//                     'InciTech UA es una app que\n'
//                     'sirve para reportar\n'
//                     'incidencias dentro de la\n'
//                     'universidad de forma\n'
//                     'rápida y organizada.\n'
//                     'Permite a los usuarios\n'
//                     'informar problemas,\n'
//                     'ubicarlos y hacer\n'
//                     'seguimiento hasta que sean\n'
//                     'solucionados, ayudando a\n'
//                     'mejorar el entorno\n'
//                     'universitario.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 17,
//                       height: 1.12,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black,
//                       fontFamily: AppTextStyles.fontFamily,
//                     ),
//                   ),
//                 ),

//                 // Botón
//                 Positioned(
//                   left: w * 0.22,
//                   right: w * 0.22,
//                   bottom: h * 0.04,
//                   child: SizedBox(
//                     height: 45,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/login');
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: buttonColor,
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(28),
//                         ),
//                       ),
//                       child: const Text(
//                         'CONTINUAR',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.40,
//                           fontFamily: AppTextStyles.fontFamily,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color backgroundColor = AppColors.backgroundGreenAlt;
  static const Color buttonColor = AppColors.primaryGreenAltDark;
  static const Color textColor = AppColors.textDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            final logoWidth = (w * 0.74).clamp(230.0, 330.0).toDouble();
            final titleSize = (w * 0.048).clamp(18.0, 22.0).toDouble();
            final bodySize = (w * 0.040).clamp(14.5, 17.0).toDouble();

            return Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: Align(
                      alignment: const Alignment(0, 0.02),
                      child: Opacity(
                        opacity: 0.28,
                        child: Image.asset(
                          'assets/images/fondo_bienvenida.png',
                          width: w * 1.50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: h * 0.01,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo_incitech.png',
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                Positioned(
                  top: h * 0.31,
                  left: w * 0.12,
                  right: w * 0.12,
                  child: _buildWelcomeTextCard(
                    titleSize: titleSize,
                    bodySize: bodySize,
                  ),
                ),

                Positioned(
                  left: w * 0.18,
                  right: w * 0.18,
                  bottom: h * 0.045,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                      ),
                      label: Text(
                        'CONTINUAR',
                        style: AppTextStyles.button(
                          15,
                          color: AppColors.white,
                        ).copyWith(
                          letterSpacing: 0.45,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: AppColors.white,
                        elevation: 3,
                        shadowColor: AppColors.shadowGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeTextCard({
    required double titleSize,
    required double bodySize,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        color: AppColors.softWhite.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.45),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowGreen.withValues(alpha: 0.22),
            offset: const Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Bienvenido a InciTech UA',
            textAlign: TextAlign.center,
            style: AppTextStyles.extraBold(
              titleSize,
              color: AppColors.primaryGreenDark,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'InciTech UA es una app que sirve para reportar incidencias dentro de la universidad de forma rápida y organizada. Permite a los usuarios informar problemas, ubicarlos y hacer seguimiento hasta que sean solucionados, ayudando a mejorar el entorno universitario.',
            textAlign: TextAlign.center,
            style: AppTextStyles.extraBold(
              bodySize,
              color: textColor,
            ).copyWith(
              height: 1.27,
            ),
          ),
        ],
      ),
    );
  }
}