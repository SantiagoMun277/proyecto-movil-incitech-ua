// import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   static const Color _backgroundColor = AppColors.backgroundGreen;
//   static const Color _cardColor = AppColors.softWhite;
//   static const Color _primaryGreen = AppColors.primaryGreenAlt;
//   static const Color _shadowGreen = AppColors.shadowGreen;
//   static const Color _textColor = AppColors.textDark;
//   static const Color _inputBorderColor = AppColors.borderDark;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _goToLogin() {
//     Navigator.pushReplacementNamed(context, '/login');
//   }

//   Future<void> _submitRegister() async {
//     FocusScope.of(context).unfocus();

//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       await Future.delayed(const Duration(milliseconds: 700));

//       if (!mounted) return;

//       Navigator.pushReplacementNamed(context, '/incidents');
//     } catch (_) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No se pudo completar el registro. Intenta nuevamente.'),
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   String? _validateFullName(String? value) {
//     final text = value?.trim() ?? '';

//     if (text.isEmpty) {
//       return 'Ingresa tu nombre completo.';
//     }

//     if (text.length < 6) {
//       return 'Debe tener al menos 6 caracteres.';
//     }

//     return null;
//   }

//   String? _validateEmail(String? value) {
//     final text = value?.trim() ?? '';

//     if (text.isEmpty) {
//       return 'Ingresa tu correo.';
//     }

//     final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
//     if (!emailRegex.hasMatch(text)) {
//       return 'Correo inválido.';
//     }

//     return null;
//   }

//   String? _validatePassword(String? value) {
//     final text = value ?? '';

//     if (text.isEmpty) {
//       return 'Ingresa tu contraseña.';
//     }

//     if (text.length < 6) {
//       return 'Mínimo 6 caracteres.';
//     }

//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     final text = value ?? '';

//     if (text.isEmpty) {
//       return 'Confirma tu contraseña.';
//     }

//     if (text != _passwordController.text) {
//       return 'Las contraseñas no coinciden.';
//     }

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
//             final double unifiedFontSize = w * 0.040;

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

//                       SizedBox(height: h * 0.072),

//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.fromLTRB(
//                           w * 0.04,
//                           h * 0.032,
//                           w * 0.04,
//                           h * 0.03,
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
//                               _buildRegisterIcon(w),
//                               SizedBox(height: h * 0.012),

//                               Text(
//                                 'REGISTRARSE',
//                                 style: TextStyle(
//                                   fontSize: unifiedFontSize,
//                                   fontWeight: FontWeight.w500,
//                                   fontFamily: AppTextStyles.fontFamily,
//                                   color: _textColor,
//                                 ),
//                               ),

//                               SizedBox(height: h * 0.038),

//                               _buildLabel('NOMBRE COMPLETO', unifiedFontSize, w),
//                               SizedBox(height: h * 0.004),
//                               _buildInput(
//                                 controller: _fullNameController,
//                                 hint: 'Alejandro Velasquez Hurtatis',
//                                 obscureText: false,
//                                 keyboardType: TextInputType.name,
//                                 validator: _validateFullName,
//                                 fontSize: unifiedFontSize,
//                                 w: w,
//                               ),

//                               SizedBox(height: h * 0.025),

//                               _buildLabel('CORREO ELECTRONICO', unifiedFontSize, w),
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

//                               SizedBox(height: h * 0.025),

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
//                                   onPressed: () {
//                                     setState(() {
//                                       _obscurePassword = !_obscurePassword;
//                                     });
//                                   },
//                                 ),
//                               ),

//                               SizedBox(height: h * 0.025),

//                               _buildLabel(
//                                 'CONFIRMAR CONTRASEÑA',
//                                 unifiedFontSize,
//                                 w,
//                               ),
//                               SizedBox(height: h * 0.004),
//                               _buildInput(
//                                 controller: _confirmPasswordController,
//                                 hint: '**********',
//                                 obscureText: _obscureConfirmPassword,
//                                 keyboardType: TextInputType.visiblePassword,
//                                 validator: _validateConfirmPassword,
//                                 fontSize: unifiedFontSize,
//                                 w: w,
//                                 suffixIcon: IconButton(
//                                   splashRadius: 18,
//                                   icon: Icon(
//                                     _obscureConfirmPassword
//                                         ? Icons.visibility_off_outlined
//                                         : Icons.visibility_outlined,
//                                     size: 20,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _obscureConfirmPassword =
//                                           !_obscureConfirmPassword;
//                                     });
//                                   },
//                                 ),
//                               ),

//                               SizedBox(height: h * 0.018),

//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   SizedBox(
//                                     width: w * 0.20,
//                                     height: h * 0.043,
//                                     child: ElevatedButton(
//                                       onPressed: _goToLogin,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: _primaryGreen,
//                                         foregroundColor: Colors.white,
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(28),
//                                         ),
//                                         padding: EdgeInsets.zero,
//                                       ),
//                                       child: Text(
//                                         'INICIO',
//                                         style: TextStyle(
//                                           fontSize: unifiedFontSize,
//                                           fontWeight: FontWeight.w500,
//                                           fontFamily: AppTextStyles.fontFamily,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: w * 0.29,
//                                     height: h * 0.043,
//                                     child: ElevatedButton(
//                                       onPressed: _isLoading ? null : _submitRegister,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: _primaryGreen,
//                                         foregroundColor: Colors.white,
//                                         disabledBackgroundColor: _primaryGreen,
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(28),
//                                         ),
//                                         padding: EdgeInsets.zero,
//                                       ),
//                                       child: _isLoading
//                                           ? const SizedBox(
//                                               width: 20,
//                                               height: 20,
//                                               child: CircularProgressIndicator(
//                                                 strokeWidth: 2.2,
//                                                 valueColor:
//                                                     AlwaysStoppedAnimation<Color>(
//                                                   Colors.white,
//                                                 ),
//                                               ),
//                                             )
//                                           : Text(
//                                               'GUARDAR',
//                                               style: TextStyle(
//                                                 fontSize: unifiedFontSize,
//                                                 fontWeight: FontWeight.w500,
//                                                 fontFamily: AppTextStyles.fontFamily,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: h * 0.055),

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

//   Widget _buildRegisterIcon(double w) {
//     return SizedBox(
//       width: w * 0.19,
//       height: w * 0.19,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Center(
//             child: Icon(
//               Icons.account_circle_outlined,
//               size: w * 0.19,
//               color: AppColors.borderDark,
//             ),
//           ),
//           Positioned(
//             right: -2,
//             top: 6,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: _cardColor,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.add_circle_outline,
//                 size: w * 0.075,
//                 color: AppColors.borderDark,
//               ),
//             ),
//           ),
//         ],
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
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//           errorStyle: const TextStyle(
//             fontSize: 11,
//             height: 0.9,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(
//               color: _inputBorderColor,
//               width: 1.0,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(
//               color: _primaryGreen,
//               width: 1.2,
//             ),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(
//               color: Colors.red,
//               width: 1.0,
//             ),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//             borderSide: const BorderSide(
//               color: Colors.red,
//               width: 1.2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/services/auth_service.dart';
import 'package:my_app_incitech_ua/services/user_service.dart';

// import '../../../../services/auth_service.dart';
// import '../../../../services/user_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _backgroundColor = AppColors.backgroundGreen;
  static const Color _cardColor = AppColors.softWhite;
  static const Color _primaryGreen = AppColors.primaryGreenAlt;
  static const Color _shadowGreen = AppColors.shadowGreen;
  static const Color _textColor = AppColors.textDark;
  static const Color _inputBorderColor = AppColors.borderDark;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _submitRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final credencial = await _authService.registrarUsuario(
        correo: _emailController.text.trim(),
        contrasena: _passwordController.text.trim(),
      );

      final uid = credencial.user?.uid;

      if (uid == null) {
        throw Exception('No se pudo obtener el uid del usuario.');
      }

      await _userService.guardarUsuario(
        uid: uid,
        nombreCompleto: _fullNameController.text.trim(),
        correo: _emailController.text.trim(),
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
        const SnackBar(
          content: Text('No se pudo completar el registro. Intenta nuevamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateFullName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Ingresa tu nombre completo.';
    }

    if (text.length < 6) {
      return 'Debe tener al menos 6 caracteres.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Ingresa tu correo.';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) {
      return 'Correo inválido.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';

    if (text.isEmpty) {
      return 'Ingresa tu contraseña.';
    }

    if (text.length < 6) {
      return 'Mínimo 6 caracteres.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final text = value ?? '';

    if (text.isEmpty) {
      return 'Confirma tu contraseña.';
    }

    if (text != _passwordController.text) {
      return 'Las contraseñas no coinciden.';
    }

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
                      SizedBox(height: h * 0.072),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          w * 0.04,
                          h * 0.032,
                          w * 0.04,
                          h * 0.03,
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
                              _buildRegisterIcon(w),
                              SizedBox(height: h * 0.012),
                              Text(
                                'REGISTRARSE',
                                style: TextStyle(
                                  fontSize: unifiedFontSize,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: _textColor,
                                ),
                              ),
                              SizedBox(height: h * 0.038),
                              _buildLabel('NOMBRE COMPLETO', unifiedFontSize, w),
                              SizedBox(height: h * 0.004),
                              _buildInput(
                                controller: _fullNameController,
                                hint: 'Alejandro Velasquez Hurtatis',
                                obscureText: false,
                                keyboardType: TextInputType.name,
                                validator: _validateFullName,
                                fontSize: unifiedFontSize,
                                w: w,
                              ),
                              SizedBox(height: h * 0.025),
                              _buildLabel('CORREO ELECTRONICO', unifiedFontSize, w),
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
                              SizedBox(height: h * 0.025),
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
                              SizedBox(height: h * 0.025),
                              _buildLabel(
                                'CONFIRMAR CONTRASEÑA',
                                unifiedFontSize,
                                w,
                              ),
                              SizedBox(height: h * 0.004),
                              _buildInput(
                                controller: _confirmPasswordController,
                                hint: '**********',
                                obscureText: _obscureConfirmPassword,
                                keyboardType: TextInputType.visiblePassword,
                                validator: _validateConfirmPassword,
                                fontSize: unifiedFontSize,
                                w: w,
                                suffixIcon: IconButton(
                                  splashRadius: 18,
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: h * 0.018),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: w * 0.20,
                                    height: h * 0.043,
                                    child: ElevatedButton(
                                      onPressed: _goToLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryGreen,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(28),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(
                                        'INICIO',
                                        style: TextStyle(
                                          fontSize: unifiedFontSize,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppTextStyles.fontFamily,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: w * 0.29,
                                    height: h * 0.043,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _submitRegister,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryGreen,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: _primaryGreen,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(28),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              'GUARDAR',
                                              style: TextStyle(
                                                fontSize: unifiedFontSize,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: AppTextStyles.fontFamily,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.055),
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

  Widget _buildRegisterIcon(double w) {
    return SizedBox(
      width: w * 0.19,
      height: w * 0.19,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Icon(
              Icons.account_circle_outlined,
              size: w * 0.19,
              color: AppColors.borderDark,
            ),
          ),
          Positioned(
            right: -2,
            top: 6,
            child: Container(
              decoration: const BoxDecoration(
                color: _cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_circle_outline,
                size: w * 0.075,
                color: AppColors.borderDark,
              ),
            ),
          ),
        ],
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          errorStyle: const TextStyle(
            fontSize: 11,
            height: 0.9,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: _inputBorderColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: _primaryGreen,
              width: 1.2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}


