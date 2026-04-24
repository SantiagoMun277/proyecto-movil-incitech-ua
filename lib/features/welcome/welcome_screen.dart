
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color backgroundColor = Color(0xFFB3DFBE);
  static const Color buttonColor = Color(0xFF0C7928);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Stack(
              children: [
                // Logo superior
                Positioned(
                  top: h * 0.01,
                  left: w * 0.10,
                  child: Image.asset(
                    'assets/images/logo_incitech.png',
                    width: w * 0.80,
                    fit: BoxFit.contain,
                  ),
                ),

                // Imagen de fondo UA
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

                // Texto
                Positioned(
                  top: h * 0.34,
                  left: w * 0.18,
                  right: w * 0.16,
                  child: const Text(
                    'InciTech UA es una app que\n'
                    'sirve para reportar\n'
                    'incidencias dentro de la\n'
                    'universidad de forma\n'
                    'rápida y organizada.\n'
                    'Permite a los usuarios\n'
                    'informar problemas,\n'
                    'ubicarlos y hacer\n'
                    'seguimiento hasta que sean\n'
                    'solucionados, ayudando a\n'
                    'mejorar el entorno\n'
                    'universitario.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),

                // Botón
                Positioned(
                  left: w * 0.22,
                  right: w * 0.22,
                  bottom: h * 0.04,
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'CONTINUAR',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.40,
                          fontFamily: 'Times New Roman',
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
}