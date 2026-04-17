

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
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
  static const Color _backgroundColor = Color(0xFFB8DEBE);
  static const Color _cardColor = Color(0xFFE9E9E9);
  static const Color _primaryGreen = Color(0xFF0C7A27);
  static const Color _shadowGreen = Color(0x664FA96A);
  static const Color _textColor = Color(0xFF222222);
  static const Color _fieldColor = Color(0xFFF4F4F4);
  static const Color _borderColor = Color(0xFF6A6A6A);

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

      final nombre = _stringValue(data?['nombreCompleto']);
      final correo = _stringValue(data?['correo']).isNotEmpty
          ? _stringValue(data?['correo'])
          : (usuario.email ?? '');

      final genero = _opcionValida(
        _stringValue(data?['genero']),
        _genderOptions,
        'No responde',
      );

      final programa = _opcionValida(
        _stringValue(data?['programa']),
        _programOptions,
        'Otros',
      );

      final rol = _stringValue(data?['rol']).isNotEmpty
          ? _stringValue(data?['rol'])
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
                    final double baseFontSize = w * 0.040;

                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        w * 0.03,
                        h * 0.015,
                        w * 0.03,
                        h * 0.025,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo_incitech.png',
                            width: w * 0.80,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: h * 0.014),
                          _buildProfileCard(baseFontSize),
                          SizedBox(height: h * 0.028),
                          _buildPasswordCard(baseFontSize),
                          SizedBox(height: h * 0.03),
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

  Widget _buildProfileCard(double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: _shadowGreen,
            offset: Offset(4, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(fontSize),
          const SizedBox(height: 12),
          _buildLabel('Nombre completo', fontSize),
          const SizedBox(height: 4),
          _buildTextField(
            controller: _fullNameController,
            fontSize: fontSize,
          ),
          const SizedBox(height: 10),
          _buildLabel('Correo electrónico', fontSize),
          const SizedBox(height: 4),
          _buildTextField(
            controller: _emailController,
            fontSize: fontSize,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
          ),
          const SizedBox(height: 10),
          _buildLabel('Género:', fontSize),
          const SizedBox(height: 4),
          ProfileExpandableDropdown(
            value: _selectedGender,
            items: _genderOptions,
            isExpanded: _isGenderExpanded,
            onTap: _toggleGenderDropdown,
            onSelected: _selectGender,
            fontSize: fontSize,
          ),
          const SizedBox(height: 10),
          _buildLabel('Programa:', fontSize),
          const SizedBox(height: 4),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard(double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Cambiar contraseña',
            style: TextStyle(
              fontSize: fontSize * 1.30,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: _shadowGreen,
                offset: Offset(4, 5),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Contraseña Actual', fontSize),
              const SizedBox(height: 4),
              _buildTextField(
                controller: _currentPasswordController,
                fontSize: fontSize,
                obscureText: _obscureCurrentPassword,
                keyboardType: TextInputType.visiblePassword,
                hintText: '**********',
                suffixIcon: IconButton(
                  splashRadius: 18,
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              _buildLabel('Nueva contraseña', fontSize),
              const SizedBox(height: 4),
              _buildTextField(
                controller: _newPasswordController,
                fontSize: fontSize,
                obscureText: _obscureNewPassword,
                keyboardType: TextInputType.visiblePassword,
                hintText: '**********',
                suffixIcon: IconButton(
                  splashRadius: 18,
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              _buildLabel('Confirmar contraseña', fontSize),
              const SizedBox(height: 4),
              _buildTextField(
                controller: _confirmPasswordController,
                fontSize: fontSize,
                obscureText: _obscureConfirmPassword,
                keyboardType: TextInputType.visiblePassword,
                hintText: '**********',
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFF6F6F6),
          child: Icon(
            Icons.person,
            color: Colors.blueGrey.shade700,
            size: 28,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _headerEmail.isEmpty ? 'Sin correo' : _headerEmail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'Times New Roman',
                    decoration: TextDecoration.underline,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rol: $_rolUsuario',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'Times New Roman',
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Times New Roman',
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
  }) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Times New Roman',
          color: _textColor,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: _fieldColor,
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Times New Roman',
            color: Colors.grey.shade500,
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: _borderColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: _primaryGreen,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreenButton({
    required String text,
    required VoidCallback onPressed,
    bool small = false,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: small ? 94 : double.infinity,
      height: small ? 34 : 46,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _primaryGreen,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: small ? 14 : 18,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  Widget _buildLogoutButton(double fontSize) {
    return SizedBox(
      width: double.infinity,
      height: 46,
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
                Icons.logout,
                color: Colors.white,
                size: 20,
              ),
        label: Text(
          _isLoggingOut ? 'Cerrando sesión...' : 'Cerrar sesión',
          style: TextStyle(
            fontSize: fontSize * 1.08,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _primaryGreen,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}