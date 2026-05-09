

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
// import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
// import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
// import 'package:my_app_incitech_ua/features/profile/screens/profile_expandable_dropdown.dart';
// import 'package:my_app_incitech_ua/services/auth_service.dart';
// import 'package:my_app_incitech_ua/services/user_service.dart';
// import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   static const Color _backgroundColor = AppColors.backgroundGreen;
//   static const Color _cardColor = AppColors.panelMutedAlt;
//   static const Color _primaryGreen = AppColors.primaryGreenAlt;
//   static const Color _shadowGreen = AppColors.shadowGreen;
//   static const Color _textColor = AppColors.textDark;
//   static const Color _fieldColor = AppColors.cardBackground;
//   static const Color _borderColor = AppColors.borderColor;

//   final AuthService _authService = AuthService();
//   final UserService _userService = UserService();

//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   final TextEditingController _currentPasswordController =
//       TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   bool _isGenderExpanded = false;
//   bool _isProgramExpanded = false;

//   bool _obscureCurrentPassword = true;
//   bool _obscureNewPassword = true;
//   bool _obscureConfirmPassword = true;

//   bool _isLoadingProfile = true;
//   bool _isSavingProfile = false;
//   bool _isSavingPassword = false;
//   bool _isLoggingOut = false;

//   String _selectedGender = 'No responde';
//   String _selectedProgram = 'Otros';
//   String _headerEmail = '';
//   String _rolUsuario = 'Usuario';

//   final List<String> _genderOptions = const [
//     'Otros',
//     'Masculino',
//     'Femenino',
//     'No responde',
//   ];

//   final List<String> _programOptions = const [
//     'Otros',
//     'Ing. sistemas',
//     'Ing. agrocológica',
//     'Ing. alimentos',
//     'MVZ',
//     'Biología',
//     'Química',
//     'Admin. empresas',
//     'Contaduría pública',
//     'Lic. español',
//     'Lic. sociales',
//     'Lic. ingles',
//     'Lic. artística',
//     'Lic. física, deportes y recreación',
//     'Lic. matematicas',
//     'Derecho',
//     'Enfermería',
//     'Psicología',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _cargarPerfil();
//   }

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _currentPasswordController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _cargarPerfil() async {
//     try {
//       final usuario = _authService.usuarioActual;

//       if (usuario == null) {
//         _irALogin();
//         return;
//       }

//       final data = await _userService.obtenerUsuario(usuario.uid);

//       final nombre = _stringValue(
//         data?['nombreCompleto'] ?? data?['nombre'] ?? data?['name'],
//       );
//       final correo = _stringValue(data?['correo'] ?? data?['email']).isNotEmpty
//           ? _stringValue(data?['correo'] ?? data?['email'])
//           : (usuario.email ?? '');

//       final genero = _opcionValida(
//         _stringValue(data?['genero'] ?? data?['sexo']),
//         _genderOptions,
//         'No responde',
//       );

//       final programa = _opcionValida(
//         _stringValue(data?['programa']),
//         _programOptions,
//         'Otros',
//       );

//       final rol = _stringValue(data?['rol'] ?? data?['role']).isNotEmpty
//           ? _stringValue(data?['rol'] ?? data?['role'])
//           : 'usuario';

//       if (!mounted) return;

//       setState(() {
//         _fullNameController.text = nombre;
//         _emailController.text = correo;
//         _headerEmail = correo;
//         _selectedGender = genero;
//         _selectedProgram = programa;
//         _rolUsuario = _formatearRol(rol);
//         _isLoadingProfile = false;
//       });
//     } catch (_) {
//       if (!mounted) return;

//       setState(() => _isLoadingProfile = false);
//       _mostrarMensaje('No se pudo cargar el perfil.');
//     }
//   }

//   void _toggleGenderDropdown() {
//     setState(() {
//       _isGenderExpanded = !_isGenderExpanded;
//       if (_isGenderExpanded) _isProgramExpanded = false;
//     });
//   }

//   void _toggleProgramDropdown() {
//     setState(() {
//       _isProgramExpanded = !_isProgramExpanded;
//       if (_isProgramExpanded) _isGenderExpanded = false;
//     });
//   }

//   void _selectGender(String value) {
//     setState(() {
//       _selectedGender = value;
//       _isGenderExpanded = false;
//     });
//   }

//   void _selectProgram(String value) {
//     setState(() {
//       _selectedProgram = value;
//       _isProgramExpanded = false;
//     });
//   }

//   Future<void> _saveProfile() async {
//     FocusScope.of(context).unfocus();

//     final usuario = _authService.usuarioActual;
//     if (usuario == null) {
//       _irALogin();
//       return;
//     }

//     final nombre = _fullNameController.text.trim();

//     if (nombre.isEmpty) {
//       _mostrarMensaje('Ingresa tu nombre completo.');
//       return;
//     }

//     if (nombre.length < 6) {
//       _mostrarMensaje('El nombre debe tener al menos 6 caracteres.');
//       return;
//     }

//     setState(() => _isSavingProfile = true);

//     try {
//     await _userService.actualizarPerfil(
//   uid: usuario.uid,
//   correo: _emailController.text.trim(),
//   nombreCompleto: nombre,
//   genero: _selectedGender,
//   programa: _selectedProgram,
// );

//       if (!mounted) return;

//       _mostrarMensaje('Perfil actualizado correctamente.');
//     } catch (_) {
//       if (!mounted) return;

//       _mostrarMensaje('No se pudo actualizar el perfil.');
//     } finally {
//       if (mounted) {
//         setState(() => _isSavingProfile = false);
//       }
//     }
//   }

//   Future<void> _savePassword() async {
//     FocusScope.of(context).unfocus();

//     final actual = _currentPasswordController.text.trim();
//     final nueva = _newPasswordController.text.trim();
//     final confirmar = _confirmPasswordController.text.trim();

//     if (actual.isEmpty) {
//       _mostrarMensaje('Ingresa la contraseña actual.');
//       return;
//     }

//     if (nueva.isEmpty) {
//       _mostrarMensaje('Ingresa la nueva contraseña.');
//       return;
//     }

//     if (nueva.length < 6) {
//       _mostrarMensaje('La nueva contraseña debe tener mínimo 6 caracteres.');
//       return;
//     }

//     if (confirmar.isEmpty) {
//       _mostrarMensaje('Confirma la nueva contraseña.');
//       return;
//     }

//     if (nueva != confirmar) {
//       _mostrarMensaje('Las contraseñas no coinciden.');
//       return;
//     }

//     setState(() => _isSavingPassword = true);

//     try {
//       await _authService.cambiarContrasena(
//         contrasenaActual: actual,
//         nuevaContrasena: nueva,
//       );

//       _currentPasswordController.clear();
//       _newPasswordController.clear();
//       _confirmPasswordController.clear();

//       if (!mounted) return;

//       _mostrarMensaje('Contraseña actualizada correctamente.');
//     } on FirebaseAuthException catch (e) {
//       if (!mounted) return;

//       _mostrarMensaje(_authService.obtenerMensajeError(e));
//     } catch (_) {
//       if (!mounted) return;

//       _mostrarMensaje('No se pudo actualizar la contraseña.');
//     } finally {
//       if (mounted) {
//         setState(() => _isSavingPassword = false);
//       }
//     }
//   }

//   Future<void> _logout() async {
//     setState(() => _isLoggingOut = true);

//     try {
//       await _authService.cerrarSesion();

//       if (!mounted) return;

//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         AppRoutes.login,
//         (route) => false,
//       );
//     } catch (_) {
//       if (!mounted) return;

//       _mostrarMensaje('No se pudo cerrar sesión.');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoggingOut = false);
//       }
//     }
//   }

//   void _irALogin() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         AppRoutes.login,
//         (route) => false,
//       );
//     });
//   }

//   void _mostrarMensaje(String mensaje) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(mensaje)),
//     );
//   }

//   String _stringValue(dynamic value) {
//     return value?.toString() ?? '';
//   }

//   String _opcionValida(
//     String value,
//     List<String> opciones,
//     String fallback,
//   ) {
//     if (opciones.contains(value)) return value;
//     return fallback;
//   }

//   String _formatearRol(String rol) {
//     final limpio = rol.trim().toLowerCase();
//     if (limpio.isEmpty) return 'Usuario';
//     if (limpio.contains('admin')) return 'Administrador';
//     return limpio[0].toUpperCase() + limpio.substring(1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         setState(() {
//           _isGenderExpanded = false;
//           _isProgramExpanded = false;
//         });
//       },
//       child: Scaffold(
//         backgroundColor: _backgroundColor,
//         bottomNavigationBar: const AppBottomNav(currentIndex: 3),
//         body: SafeArea(
//           child: _isLoadingProfile
//               ? const Center(child: CircularProgressIndicator())
//               : LayoutBuilder(
//                   builder: (context, constraints) {
//                     final w = constraints.maxWidth;
//                     final h = constraints.maxHeight;
//                     final double baseFontSize = w * 0.040;

//                     return SingleChildScrollView(
//                       padding: EdgeInsets.fromLTRB(
//                         w * 0.03,
//                         h * 0.015,
//                         w * 0.03,
//                         h * 0.025,
//                       ),
//                       child: Column(
//                         children: [
//                           Image.asset(
//                             'assets/images/logo_incitech.png',
//                             width: w * 0.80,
//                             fit: BoxFit.contain,
//                           ),
//                           SizedBox(height: h * 0.014),
//                           _buildProfileCard(baseFontSize),
//                           SizedBox(height: h * 0.028),
//                           _buildPasswordCard(baseFontSize),
//                           SizedBox(height: h * 0.03),
//                           _buildLogoutButton(baseFontSize),
//                           SizedBox(height: h * 0.02),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCard(double fontSize) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: _shadowGreen,
//             offset: Offset(4, 5),
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildProfileHeader(fontSize),
//           const SizedBox(height: 12),
//           _buildLabel('Nombre completo', fontSize),
//           const SizedBox(height: 4),
//           _buildTextField(
//             controller: _fullNameController,
//             fontSize: fontSize,
//           ),
//           const SizedBox(height: 10),
//           _buildLabel('Correo electrónico', fontSize),
//           const SizedBox(height: 4),
//           _buildTextField(
//             controller: _emailController,
//             fontSize: fontSize,
//             keyboardType: TextInputType.emailAddress,
//             readOnly: true,
//           ),
//           const SizedBox(height: 10),
//           _buildLabel('Género:', fontSize),
//           const SizedBox(height: 4),
//           ProfileExpandableDropdown(
//             value: _selectedGender,
//             items: _genderOptions,
//             isExpanded: _isGenderExpanded,
//             onTap: _toggleGenderDropdown,
//             onSelected: _selectGender,
//             fontSize: fontSize,
//           ),
//           const SizedBox(height: 10),
//           _buildLabel('Programa:', fontSize),
//           const SizedBox(height: 4),
//           ProfileExpandableDropdown(
//             value: _selectedProgram,
//             items: _programOptions,
//             isExpanded: _isProgramExpanded,
//             onTap: _toggleProgramDropdown,
//             onSelected: _selectProgram,
//             fontSize: fontSize,
//           ),
//           const SizedBox(height: 16),
//           Align(
//             alignment: Alignment.centerRight,
//             child: _buildGreenButton(
//               text: 'GUARDAR',
//               onPressed: _saveProfile,
//               small: true,
//               isLoading: _isSavingProfile,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPasswordCard(double fontSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: Text(
//             'Cambiar contraseña',
//             style: TextStyle(
//               fontSize: fontSize * 1.30,
//               fontFamily: AppTextStyles.fontFamily,
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
//           decoration: BoxDecoration(
//             color: _cardColor,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: const [
//               BoxShadow(
//                 color: _shadowGreen,
//                 offset: Offset(4, 5),
//                 blurRadius: 5,
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildLabel('Contraseña Actual', fontSize),
//               const SizedBox(height: 4),
//               _buildTextField(
//                 controller: _currentPasswordController,
//                 fontSize: fontSize,
//                 obscureText: _obscureCurrentPassword,
//                 keyboardType: TextInputType.visiblePassword,
//                 hintText: '**********',
//                 suffixIcon: IconButton(
//                   splashRadius: 18,
//                   icon: Icon(
//                     _obscureCurrentPassword
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     size: 20,
//                     color: Colors.grey.shade600,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscureCurrentPassword = !_obscureCurrentPassword;
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               _buildLabel('Nueva contraseña', fontSize),
//               const SizedBox(height: 4),
//               _buildTextField(
//                 controller: _newPasswordController,
//                 fontSize: fontSize,
//                 obscureText: _obscureNewPassword,
//                 keyboardType: TextInputType.visiblePassword,
//                 hintText: '**********',
//                 suffixIcon: IconButton(
//                   splashRadius: 18,
//                   icon: Icon(
//                     _obscureNewPassword
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     size: 20,
//                     color: Colors.grey.shade600,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscureNewPassword = !_obscureNewPassword;
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               _buildLabel('Confirmar contraseña', fontSize),
//               const SizedBox(height: 4),
//               _buildTextField(
//                 controller: _confirmPasswordController,
//                 fontSize: fontSize,
//                 obscureText: _obscureConfirmPassword,
//                 keyboardType: TextInputType.visiblePassword,
//                 hintText: '**********',
//                 suffixIcon: IconButton(
//                   splashRadius: 18,
//                   icon: Icon(
//                     _obscureConfirmPassword
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     size: 20,
//                     color: Colors.grey.shade600,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscureConfirmPassword = !_obscureConfirmPassword;
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: _buildGreenButton(
//                   text: 'GUARDAR',
//                   onPressed: _savePassword,
//                   small: true,
//                   isLoading: _isSavingPassword,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProfileHeader(double fontSize) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           radius: 22,
//           backgroundColor: AppColors.panelInput,
//           child: Icon(
//             Icons.person,
//             color: Colors.blueGrey.shade700,
//             size: 28,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 2),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   _headerEmail.isEmpty ? 'Sin correo' : _headerEmail,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     fontFamily: AppTextStyles.fontFamily,
//                     decoration: TextDecoration.underline,
//                     color: _textColor,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'Rol: $_rolUsuario',
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     fontFamily: AppTextStyles.fontFamily,
//                     color: _textColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLabel(String text, double fontSize) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 6),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: fontSize,
//           fontFamily: AppTextStyles.fontFamily,
//           color: _textColor,
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required double fontSize,
//     bool obscureText = false,
//     bool readOnly = false,
//     TextInputType keyboardType = TextInputType.text,
//     Widget? suffixIcon,
//     String? hintText,
//   }) {
//     return SizedBox(
//       height: 40,
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         readOnly: readOnly,
//         keyboardType: keyboardType,
//         style: TextStyle(
//           fontSize: fontSize,
//           fontFamily: AppTextStyles.fontFamily,
//           color: _textColor,
//         ),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: _fieldColor,
//           isDense: true,
//           hintText: hintText,
//           hintStyle: TextStyle(
//             fontSize: fontSize,
//             fontFamily: AppTextStyles.fontFamily,
//             color: Colors.grey.shade500,
//           ),
//           suffixIcon: suffixIcon,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 10,
//             vertical: 10,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(
//               color: _borderColor,
//               width: 1,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(
//               color: _primaryGreen,
//               width: 1.2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGreenButton({
//     required String text,
//     required VoidCallback onPressed,
//     bool small = false,
//     bool isLoading = false,
//   }) {
//     return SizedBox(
//       width: small ? 94 : double.infinity,
//       height: small ? 34 : 46,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _primaryGreen,
//           foregroundColor: Colors.white,
//           disabledBackgroundColor: _primaryGreen,
//           elevation: 0,
//           padding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(22),
//           ),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: small ? 14 : 18,
//                   fontFamily: AppTextStyles.fontFamily,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildLogoutButton(double fontSize) {
//     return SizedBox(
//       width: double.infinity,
//       height: 46,
//       child: ElevatedButton.icon(
//         onPressed: _isLoggingOut ? null : _logout,
//         icon: _isLoggingOut
//             ? const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : const Icon(
//                 Icons.logout,
//                 color: Colors.white,
//                 size: 20,
//               ),
//         label: Text(
//           _isLoggingOut ? 'Cerrando sesión...' : 'Cerrar sesión',
//           style: TextStyle(
//             fontSize: fontSize * 1.08,
//             fontFamily: AppTextStyles.fontFamily,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _primaryGreen,
//           foregroundColor: Colors.white,
//           disabledBackgroundColor: _primaryGreen,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
import 'package:my_app_incitech_ua/features/profile/screens/profile_expandable_dropdown.dart';
import 'package:my_app_incitech_ua/services/auth_service.dart';
import 'package:my_app_incitech_ua/services/user_service.dart';
import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _backgroundColor = AppColors.backgroundGreen;
  static const Color _cardColor = AppColors.softWhite;
  static const Color _fieldColor = AppColors.panelInput;
  static const Color _primaryGreen = AppColors.primaryGreen;
  static const Color _primaryGreenDark = AppColors.primaryGreenDark;
  static const Color _shadowGreen = AppColors.shadowGreen;
  static const Color _textColor = AppColors.textDark;
  static const Color _borderColor = AppColors.borderColor;
  static const Color _logoutColor = Color(0xFFB00020);

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isGenderExpanded = false;
  bool _isProgramExpanded = false;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoadingProfile = true;
  bool _isSavingProfile = false;
  bool _isSavingPassword = false;
  bool _isLoggingOut = false;

  String _selectedGender = 'No responde';
  String _selectedProgram = 'Otros';
  String _headerEmail = '';
  String _rolUsuario = 'Usuario';

  final List<String> _genderOptions = const [
    'Otros',
    'Masculino',
    'Femenino',
    'No responde',
  ];

  final List<String> _programOptions = const [
    'Otros',
    'Ing. sistemas',
    'Ing. agrocológica',
    'Ing. alimentos',
    'MVZ',
    'Biología',
    'Química',
    'Admin. empresas',
    'Contaduría pública',
    'Lic. español',
    'Lic. sociales',
    'Lic. ingles',
    'Lic. artística',
    'Lic. física, deportes y recreación',
    'Lic. matematicas',
    'Derecho',
    'Enfermería',
    'Psicología',
  ];

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _cargarPerfil() async {
    try {
      final usuario = _authService.usuarioActual;

      if (usuario == null) {
        _irALogin();
        return;
      }

      final data = await _userService.obtenerUsuario(usuario.uid);

      final nombre = _stringValue(
        data?['nombreCompleto'] ?? data?['nombre'] ?? data?['name'],
      );

      final correo = _stringValue(data?['correo'] ?? data?['email']).isNotEmpty
          ? _stringValue(data?['correo'] ?? data?['email'])
          : (usuario.email ?? '');

      final genero = _opcionValida(
        _stringValue(data?['genero'] ?? data?['sexo']),
        _genderOptions,
        'No responde',
      );

      final programa = _opcionValida(
        _stringValue(data?['programa']),
        _programOptions,
        'Otros',
      );

      final rol = _stringValue(data?['rol'] ?? data?['role']).isNotEmpty
          ? _stringValue(data?['rol'] ?? data?['role'])
          : 'usuario';

      if (!mounted) return;

      setState(() {
        _fullNameController.text = nombre;
        _emailController.text = correo;
        _headerEmail = correo;
        _selectedGender = genero;
        _selectedProgram = programa;
        _rolUsuario = _formatearRol(rol);
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _isLoadingProfile = false);
      _mostrarMensaje('No se pudo cargar el perfil.');
    }
  }

  void _toggleGenderDropdown() {
    setState(() {
      _isGenderExpanded = !_isGenderExpanded;
      if (_isGenderExpanded) _isProgramExpanded = false;
    });
  }

  void _toggleProgramDropdown() {
    setState(() {
      _isProgramExpanded = !_isProgramExpanded;
      if (_isProgramExpanded) _isGenderExpanded = false;
    });
  }

  void _selectGender(String value) {
    setState(() {
      _selectedGender = value;
      _isGenderExpanded = false;
    });
  }

  void _selectProgram(String value) {
    setState(() {
      _selectedProgram = value;
      _isProgramExpanded = false;
    });
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    final usuario = _authService.usuarioActual;
    if (usuario == null) {
      _irALogin();
      return;
    }

    final nombre = _fullNameController.text.trim();

    if (nombre.isEmpty) {
      _mostrarMensaje('Ingresa tu nombre completo.');
      return;
    }

    if (nombre.length < 6) {
      _mostrarMensaje('El nombre debe tener al menos 6 caracteres.');
      return;
    }

    setState(() => _isSavingProfile = true);

    try {
      await _userService.actualizarPerfil(
        uid: usuario.uid,
        correo: _emailController.text.trim(),
        nombreCompleto: nombre,
        genero: _selectedGender,
        programa: _selectedProgram,
      );

      if (!mounted) return;

      _mostrarMensaje('Perfil actualizado correctamente.');
    } catch (_) {
      if (!mounted) return;

      _mostrarMensaje('No se pudo actualizar el perfil.');
    } finally {
      if (mounted) {
        setState(() => _isSavingProfile = false);
      }
    }
  }

  Future<void> _savePassword() async {
    FocusScope.of(context).unfocus();

    final actual = _currentPasswordController.text.trim();
    final nueva = _newPasswordController.text.trim();
    final confirmar = _confirmPasswordController.text.trim();

    if (actual.isEmpty) {
      _mostrarMensaje('Ingresa la contraseña actual.');
      return;
    }

    if (nueva.isEmpty) {
      _mostrarMensaje('Ingresa la nueva contraseña.');
      return;
    }

    if (nueva.length < 6) {
      _mostrarMensaje('La nueva contraseña debe tener mínimo 6 caracteres.');
      return;
    }

    if (confirmar.isEmpty) {
      _mostrarMensaje('Confirma la nueva contraseña.');
      return;
    }

    if (nueva != confirmar) {
      _mostrarMensaje('Las contraseñas no coinciden.');
      return;
    }

    setState(() => _isSavingPassword = true);

    try {
      await _authService.cambiarContrasena(
        contrasenaActual: actual,
        nuevaContrasena: nueva,
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      if (!mounted) return;

      _mostrarMensaje('Contraseña actualizada correctamente.');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      _mostrarMensaje(_authService.obtenerMensajeError(e));
    } catch (_) {
      if (!mounted) return;

      _mostrarMensaje('No se pudo actualizar la contraseña.');
    } finally {
      if (mounted) {
        setState(() => _isSavingPassword = false);
      }
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);

    try {
      await _authService.cerrarSesion();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;

      _mostrarMensaje('No se pudo cerrar sesión.');
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  void _irALogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    });
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  String _stringValue(dynamic value) {
    return value?.toString() ?? '';
  }

  String _opcionValida(
    String value,
    List<String> opciones,
    String fallback,
  ) {
    if (opciones.contains(value)) return value;
    return fallback;
  }

  String _formatearRol(String rol) {
    final limpio = rol.trim().toLowerCase();
    if (limpio.isEmpty) return 'Usuario';
    if (limpio.contains('admin')) return 'Administrador';
    return limpio[0].toUpperCase() + limpio.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _isGenderExpanded = false;
          _isProgramExpanded = false;
        });
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        bottomNavigationBar: const AppBottomNav(currentIndex: 3),
        body: SafeArea(
          child: _isLoadingProfile
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    final baseFontSize =
                        (w * 0.038).clamp(13.0, 16.0).toDouble();
                    final logoWidth =
                        (w * 0.58).clamp(190.0, 270.0).toDouble();

                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        w * 0.04,
                        h * 0.015,
                        w * 0.04,
                        h * 0.025,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo_incitech.png',
                            width: logoWidth,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: h * 0.014),
                          _buildProfileHeaderCard(baseFontSize),
                          SizedBox(height: h * 0.014),
                          _buildProfileCard(baseFontSize),
                          SizedBox(height: h * 0.02),
                          _buildPasswordCard(baseFontSize),
                          SizedBox(height: h * 0.022),
                          _buildLogoutButton(baseFontSize),
                          SizedBox(height: h * 0.02),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(double fontSize) {
    return _buildCard(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _primaryGreen.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(
                color: _primaryGreen.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.account_circle_outlined,
              color: _primaryGreenDark,
              size: 31,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi perfil',
                  style: AppTextStyles.extraBold(
                    fontSize * 1.22,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _headerEmail.isEmpty ? 'Sin correo' : _headerEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular(
                    fontSize * 0.90,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _primaryGreen.withValues(alpha: 0.20),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Rol: $_rolUsuario',
                    style: AppTextStyles.semiBold(
                      fontSize * 0.78,
                      color: _primaryGreenDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(double fontSize) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.badge_outlined,
            title: 'Información personal',
            subtitle: 'Actualiza tus datos básicos.',
            fontSize: fontSize,
          ),
          const SizedBox(height: 14),
          _buildLabel('Nombre completo', fontSize),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _fullNameController,
            fontSize: fontSize,
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          _buildLabel('Correo electrónico', fontSize),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _emailController,
            fontSize: fontSize,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 12),
          _buildLabel('Género', fontSize),
          const SizedBox(height: 6),
          ProfileExpandableDropdown(
            value: _selectedGender,
            items: _genderOptions,
            isExpanded: _isGenderExpanded,
            onTap: _toggleGenderDropdown,
            onSelected: _selectGender,
            fontSize: fontSize,
          ),
          const SizedBox(height: 12),
          _buildLabel('Programa', fontSize),
          const SizedBox(height: 6),
          ProfileExpandableDropdown(
            value: _selectedProgram,
            items: _programOptions,
            isExpanded: _isProgramExpanded,
            onTap: _toggleProgramDropdown,
            onSelected: _selectProgram,
            fontSize: fontSize,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: _buildGreenButton(
              text: 'GUARDAR',
              onPressed: _saveProfile,
              small: true,
              isLoading: _isSavingProfile,
              icon: Icons.save_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard(double fontSize) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.lock_outline_rounded,
            title: 'Cambiar contraseña',
            subtitle: 'Actualiza tu clave de acceso.',
            fontSize: fontSize,
          ),
          const SizedBox(height: 14),
          _buildLabel('Contraseña actual', fontSize),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _currentPasswordController,
            fontSize: fontSize,
            obscureText: _obscureCurrentPassword,
            keyboardType: TextInputType.visiblePassword,
            hintText: '**********',
            prefixIcon: Icons.lock_outline_rounded,
            suffixIcon: _buildPasswordVisibilityButton(
              obscure: _obscureCurrentPassword,
              onPressed: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildLabel('Nueva contraseña', fontSize),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _newPasswordController,
            fontSize: fontSize,
            obscureText: _obscureNewPassword,
            keyboardType: TextInputType.visiblePassword,
            hintText: '**********',
            prefixIcon: Icons.lock_reset_rounded,
            suffixIcon: _buildPasswordVisibilityButton(
              obscure: _obscureNewPassword,
              onPressed: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildLabel('Confirmar contraseña', fontSize),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _confirmPasswordController,
            fontSize: fontSize,
            obscureText: _obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            hintText: '**********',
            prefixIcon: Icons.verified_user_outlined,
            suffixIcon: _buildPasswordVisibilityButton(
              obscure: _obscureConfirmPassword,
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: _buildGreenButton(
              text: 'GUARDAR',
              onPressed: _savePassword,
              small: true,
              isLoading: _isSavingPassword,
              icon: Icons.save_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(14, 14, 14, 16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _shadowGreen.withValues(alpha: 0.18),
            offset: const Offset(0, 7),
            blurRadius: 15,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
    required double fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: _primaryGreenDark,
            size: 18,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.extraBold(
                  fontSize * 1.02,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.regular(
                  fontSize * 0.84,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: AppTextStyles.extraBold(
          fontSize * 0.94,
          color: _textColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required double fontSize,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? hintText,
    IconData? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: AppTextStyles.regular(
        fontSize,
        color: _textColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly
            ? _fieldColor.withValues(alpha: 0.70)
            : _fieldColor,
        isDense: true,
        hintText: hintText,
        hintStyle: AppTextStyles.regular(
          fontSize,
          color: Colors.grey.shade500,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                size: 19,
                color: _primaryGreenDark,
              ),
        suffixIcon: suffixIcon,
        prefixIconConstraints: prefixIcon == null
            ? null
            : const BoxConstraints(
                minWidth: 42,
                minHeight: 42,
              ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _borderColor.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: _primaryGreen,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordVisibilityButton({
    required bool obscure,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      splashRadius: 18,
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20,
        color: Colors.grey.shade600,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildGreenButton({
    required String text,
    required VoidCallback onPressed,
    bool small = false,
    bool isLoading = false,
    IconData icon = Icons.check_rounded,
  }) {
    return SizedBox(
      width: small ? 116 : double.infinity,
      height: small ? 36 : 46,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                icon,
                size: small ? 16 : 20,
              ),
        label: Text(
          isLoading ? '...' : text,
          style: AppTextStyles.button(
            small ? 12.5 : 16,
            color: AppColors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: _primaryGreen.withValues(alpha: 0.60),
          disabledForegroundColor: AppColors.white,
          elevation: 2,
          shadowColor: _shadowGreen,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(double fontSize) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _isLoggingOut ? null : _logout,
        icon: _isLoggingOut
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 20,
              ),
        label: Text(
          _isLoggingOut ? 'Cerrando sesión...' : 'Cerrar sesión',
          style: AppTextStyles.button(
            fontSize,
            color: AppColors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _logoutColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _logoutColor.withValues(alpha: 0.60),
          disabledForegroundColor: Colors.white,
          elevation: 2,
          shadowColor: _shadowGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
