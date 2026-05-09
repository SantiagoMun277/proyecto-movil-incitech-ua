
// import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   static const Color _backgroundColor = AppColors.backgroundGreen;
//   static const Color _cardColor = AppColors.softWhite;
//   static const Color _primaryGreen = AppColors.primaryGreenAlt;
//   static const Color _shadowGreen = AppColors.shadowGreen;
//   static const Color _textColor = AppColors.textDark;
//   static const Color _inputBorderColor = AppColors.borderDark;
//   static const Color _linkColor = AppColors.linkGreen;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _goToRegister() {
//     Navigator.pushNamed(context, '/register');
//   }

//   Future<void> _submitLogin() async {
//     FocusScope.of(context).unfocus();
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     try {
//       await Future.delayed(const Duration(milliseconds: 600));
//       if (!mounted) return;
//       Navigator.pushReplacementNamed(context, '/incidents');
//     } catch (_) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No se pudo iniciar sesión. Intenta nuevamente.')),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   String? _validateEmail(String? value) {
//     final text = value?.trim() ?? '';
//     if (text.isEmpty) return 'Ingresa tu correo.';
//     final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
//     if (!emailRegex.hasMatch(text)) return 'Correo inválido.';
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     final text = value ?? '';
//     if (text.isEmpty) return 'Ingresa tu contraseña.';
//     if (text.length < 6) return 'Mínimo 6 caracteres.';
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final w = constraints.maxWidth;
//             final h = constraints.maxHeight;
//             final double unifiedFontSize = w * 0.040; // Tamaño unificado

//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: h),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: w * 0.03),
//                   child: Column(
//                     children: [
//                       SizedBox(height: h * 0.012),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Image.asset(
//                                 'assets/images/logo_incitech.png',
//                                 width: w * 0.80,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: w * 0.01),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.asset(
//                               'assets/images/logo_ua.png',
//                               width: w * 0.15,
//                               height: w * 0.15,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: h * 0.075),
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.fromLTRB(
//                           w * 0.04, h * 0.035, w * 0.04, h * 0.04,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _cardColor,
//                           borderRadius: BorderRadius.circular(22),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: _shadowGreen,
//                               offset: Offset(5, 6),
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               Icon(
//                                 Icons.account_circle_outlined,
//                                 size: w * 0.19,
//                                 color: AppColors.borderDark,
//                               ),
//                               SizedBox(height: h * 0.008),
//                               Text(
//                                 'INICIAR SESIÓN',
//                                 style: TextStyle(
//                                   fontSize: unifiedFontSize,
//                                   fontWeight: FontWeight.w500,
//                                   fontFamily: AppTextStyles.fontFamily,
//                                   color: _textColor,
//                                 ),
//                               ),
//                               SizedBox(height: h * 0.04),
//                               _buildLabel('USUARIO', unifiedFontSize, w),
//                               SizedBox(height: h * 0.004),
//                               _buildInput(
//                                 controller: _emailController,
//                                 hint: 'ejemplo@porejemplo.com',
//                                 obscureText: false,
//                                 keyboardType: TextInputType.emailAddress,
//                                 validator: _validateEmail,
//                                 fontSize: unifiedFontSize,
//                                 w: w,
//                               ),
//                               SizedBox(height: h * 0.04),
//                               _buildLabel('CONTRASEÑA', unifiedFontSize, w),
//                               SizedBox(height: h * 0.004),
//                               _buildInput(
//                                 controller: _passwordController,
//                                 hint: '**********',
//                                 obscureText: _obscurePassword,
//                                 keyboardType: TextInputType.visiblePassword,
//                                 validator: _validatePassword,
//                                 fontSize: unifiedFontSize,
//                                 w: w,
//                                 suffixIcon: IconButton(
//                                   splashRadius: 18,
//                                   icon: Icon(
//                                     _obscurePassword
//                                         ? Icons.visibility_off_outlined
//                                         : Icons.visibility_outlined,
//                                     size: 20,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                   onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                                 ),
//                               ),
//                               SizedBox(height: h * 0.040),
//                               SizedBox(
//                                 width: w * 0.60,
//                                 height: h * 0.062,
//                                 child: ElevatedButton(
//                                   onPressed: _isLoading ? null : _submitLogin,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: _primaryGreen,
//                                     foregroundColor: Colors.white,
//                                     disabledBackgroundColor: _primaryGreen,
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(28),
//                                     ),
//                                   ),
//                                   child: _isLoading
//                                       ? const SizedBox(
//                                           width: 22, height: 22,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2.2,
//                                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                           ),
//                                         )
//                                       : Text(
//                                           'INICIAR SESIÓN',
//                                           style: TextStyle(
//                                             fontSize: unifiedFontSize,
//                                             fontWeight: FontWeight.w500,
//                                             fontFamily: AppTextStyles.fontFamily,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                               SizedBox(height: h * 0.045),
//                               Wrap(
//                                 alignment: WrapAlignment.center,
//                                 crossAxisAlignment: WrapCrossAlignment.center,
//                                 children: [
//                                   Text(
//                                     '¿NO TIENES CUENTA? ',
//                                     style: TextStyle(
//                                       fontSize: unifiedFontSize,
//                                       color: _textColor,
//                                       fontFamily: AppTextStyles.fontFamily,
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: _goToRegister,
//                                     child: Text(
//                                       'REGISTRATE',
//                                       style: TextStyle(
//                                         fontSize: unifiedFontSize,
//                                         color: _linkColor,
//                                         decoration: TextDecoration.underline,
//                                         fontFamily: AppTextStyles.fontFamily,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: h * 0.065),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                         child: Text(
//                           '¡UNIVERSIDAD DE LA AMAZONIA\nMAS CONECTADA QUE NUNCA!',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: unifiedFontSize,
//                             height: 1.05,
//                             fontWeight: FontWeight.w600,
//                             color: _textColor,
//                             fontFamily: AppTextStyles.fontFamily,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: h * 0.025),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String text, double fontSize, double w) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: EdgeInsets.only(left: w * 0.015),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: fontSize,
//             color: _textColor,
//             fontFamily: AppTextStyles.fontFamily,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInput({
//     required TextEditingController controller,
//     required String hint,
//     required bool obscureText,
//     required TextInputType keyboardType,
//     required String? Function(String?) validator,
//     required double fontSize,
//     required double w,
//     Widget? suffixIcon,
//   }) {
//     return SizedBox(
//       height: 56,
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         validator: validator,
//         style: TextStyle(
//           fontSize: fontSize,
//           fontFamily: AppTextStyles.fontFamily,
//           color: _textColor,
//         ),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(
//             fontSize: fontSize,
//             color: Colors.grey.shade500,
//             fontFamily: AppTextStyles.fontFamily,
//           ),
//           filled: true,
//           fillColor: _cardColor,
//           suffixIcon: suffixIcon,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           errorStyle: const TextStyle(fontSize: 11, height: 0.9),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: _inputBorderColor, width: 1.0),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: _primaryGreen, width: 1.2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: Colors.red, width: 1.0),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(color: Colors.red, width: 1.2),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/services/auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color _backgroundColor = AppColors.backgroundGreen;
  static const Color _cardColor = AppColors.softWhite;
  static const Color _primaryGreen = AppColors.primaryGreenAlt;
  static const Color _shadowGreen = AppColors.shadowGreen;
  static const Color _textColor = AppColors.textDark;
  static const Color _inputBorderColor = AppColors.borderDark;
  static const Color _linkColor = AppColors.linkGreen;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  Future<void> _submitLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.iniciarSesion(
        correo: _emailController.text,
        contrasena: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/incidents');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authService.obtenerMensajeError(e)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authService.obtenerMensajeError(e)),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa tu correo.';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) return 'Correo inválido.';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Ingresa tu contraseña.';
    if (text.length < 6) return 'Mínimo 6 caracteres.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final double unifiedFontSize = w * 0.040;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.012),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/logo_incitech.png',
                                width: w * 0.80,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: w * 0.01),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/logo_ua.png',
                              width: w * 0.15,
                              height: w * 0.15,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.075),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          w * 0.04, h * 0.035, w * 0.04, h * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: _shadowGreen,
                              offset: Offset(5, 6),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_circle_outlined,
                                size: w * 0.19,
                                color: AppColors.borderDark,
                              ),
                              SizedBox(height: h * 0.008),
                              Text(
                                'INICIAR SESIÓN',
                                style: TextStyle(
                                  fontSize: unifiedFontSize,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: _textColor,
                                ),
                              ),
                              SizedBox(height: h * 0.04),
                              _buildLabel('USUARIO', unifiedFontSize, w),
                              SizedBox(height: h * 0.004),
                              _buildInput(
                                controller: _emailController,
                                hint: 'ejemplo@porejemplo.com',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                                fontSize: unifiedFontSize,
                                w: w,
                              ),
                              SizedBox(height: h * 0.04),
                              _buildLabel('CONTRASEÑA', unifiedFontSize, w),
                              SizedBox(height: h * 0.004),
                              _buildInput(
                                controller: _passwordController,
                                hint: '**********',
                                obscureText: _obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                validator: _validatePassword,
                                fontSize: unifiedFontSize,
                                w: w,
                                suffixIcon: IconButton(
                                  splashRadius: 18,
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: h * 0.040),
                              SizedBox(
                                width: w * 0.60,
                                height: h * 0.062,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submitLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryGreen,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: _primaryGreen,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'INICIAR SESIÓN',
                                          style: TextStyle(
                                            fontSize: unifiedFontSize,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppTextStyles.fontFamily,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: h * 0.045),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '¿NO TIENES CUENTA? ',
                                    style: TextStyle(
                                      fontSize: unifiedFontSize,
                                      color: _textColor,
                                      fontFamily: AppTextStyles.fontFamily,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _goToRegister,
                                    child: Text(
                                      'REGÍSTRATE',
                                      style: TextStyle(
                                        fontSize: unifiedFontSize,
                                        color: _linkColor,
                                        decoration: TextDecoration.underline,
                                        fontFamily: AppTextStyles.fontFamily,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.065),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                        child: Text(
                          '¡UNIVERSIDAD DE LA AMAZONIA\nMAS CONECTADA QUE NUNCA!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: unifiedFontSize,
                            height: 1.05,
                            fontWeight: FontWeight.w600,
                            color: _textColor,
                            fontFamily: AppTextStyles.fontFamily,
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.025),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double fontSize, double w) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: w * 0.015),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: _textColor,
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    required double fontSize,
    required double w,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: AppTextStyles.fontFamily,
          color: _textColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: fontSize,
            color: Colors.grey.shade500,
            fontFamily: AppTextStyles.fontFamily,
          ),
          filled: true,
          fillColor: _cardColor,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          errorStyle: const TextStyle(fontSize: 11, height: 0.9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _inputBorderColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _primaryGreen, width: 1.2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),
        ),
      ),
    );
  }
}


