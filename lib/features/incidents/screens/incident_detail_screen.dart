import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
import 'package:my_app_incitech_ua/services/auth_service.dart';
import 'package:my_app_incitech_ua/services/user_service.dart';

class IncidentDetailScreen extends StatefulWidget {
  const IncidentDetailScreen({super.key});

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  static const Color _backgroundColor = Color(0xFFB8DEBE);
  static const Color _cardColor = Color(0xFFF2F2F2);
  static const Color _primaryGreen = Color(0xFF0C7A27);
  static const Color _textColor = Color(0xFF222222);
  static const Color _shadowGreen = Color(0x664FA96A);
  static const Color _borderColor = Color(0xFF6A6A6A);

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _isStatusExpanded = false;
  bool _statusInitialized = false;

  String _selectedStatus = 'Reportado';
  String _rolActual = 'usuario';

  final List<String> _statusOptions = const [
    'Reportado',
    'En Proceso',
    'Resuelto',
  ];

  @override
  void initState() {
    super.initState();
    _cargarRolUsuario();
  }

  Future<void> _cargarRolUsuario() async {
    try {
      final usuario = _authService.usuarioActual;

      if (usuario == null) {
        if (!mounted) return;
        setState(() {
          _rolActual = 'usuario';
        });
        return;
      }

      final data = await _userService.obtenerUsuario(usuario.uid);
      final rol = data?['rol']?.toString().trim().toLowerCase() ?? 'usuario';

      if (!mounted) return;
      setState(() {
        _rolActual = rol == 'admin' ? 'admin' : 'usuario';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _rolActual = 'usuario';
      });
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Reportado':
        return const Color(0xFFF47E7E);
      case 'En Proceso':
        return const Color(0xFFF2C45E);
      case 'Resuelto':
        return const Color(0xFF7BE48E);
      default:
        return const Color(0xFFF4F4F4);
    }
  }

  String _mapIncidentStatusToText(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.reportado:
        return 'Reportado';
      case IncidentStatus.enProceso:
        return 'En Proceso';
      case IncidentStatus.resuelto:
        return 'Resuelto';
    }
  }

  String _safeText(String? value, String fallback) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  bool _isLocalFilePath(String path) {
    return path.startsWith('/') || path.startsWith('file://');
  }

  void _guardarEstadoMock() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Estado actualizado a: $_selectedStatus'),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required double fontSize,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w800,
              color: _textColor,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w400,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 42,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildIncidentImage({
    required String? imagePath,
    required double height,
  }) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return _buildImagePlaceholder(height);
    }

    final imageWidget = _isLocalFilePath(imagePath)
        ? Image.file(
            File(imagePath),
            width: double.infinity,
            height: height,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildImagePlaceholder(height),
          )
        : Image.asset(
            imagePath,
            width: double.infinity,
            height: height,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildImagePlaceholder(height),
          );

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: imageWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    IncidentItem? incident;

    if (args is Map) {
      incident = args['incident'] as IncidentItem?;
    } else if (args is IncidentItem) {
      incident = args;
    }

    if (incident != null && !_statusInitialized) {
      _selectedStatus = _mapIncidentStatusToText(incident.status);
      _statusInitialized = true;
    }

    final bool isAdmin = _rolActual == 'admin';

    final descripcion = incident == null
        ? 'Se evidencia la falta de varios libros en la biblioteca, especialmente aquellos necesarios para el estudio y consulta de los estudiantes, lo que dificulta el acceso a material académico.\n\nYa se implementaron nuevos libro y dotación para la biblioteca.'
        : _safeText(
            incident.description,
            'Se evidencia la falta de varios libros en la biblioteca, especialmente aquellos necesarios para el estudio y consulta de los estudiantes, lo que dificulta el acceso a material académico.\n\nYa se implementaron nuevos libro y dotación para la biblioteca.',
          );

    final fecha = incident == null
        ? '24/03/2026 - 14:49'
        : _safeText(
            incident.date,
            '24/03/2026 - 14:49',
          );

    final ubicacion = incident == null
        ? 'Sede porvenir'
        : _safeText(
            incident.location,
            'Sede porvenir',
          );

    final tipoIncidente = incident == null
        ? 'Otros'
        : _safeText(
            incident.type,
            'Otros',
          );

    final titulo = incident == null
        ? 'Falta de libros en la biblioteca'
        : _safeText(
            incident.title,
            'Falta de libros en la biblioteca',
          );

    final imagePath = incident?.imagePath;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _isStatusExpanded = false;
        });
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              final fontSize = w * 0.040;
              final double logoWidth = w * 0.78;
              final double imageHeight = (w * 0.52).clamp(180.0, 240.0).toDouble();

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.02,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_incitech.png',
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: h * 0.025),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: _shadowGreen,
                            offset: Offset(4, 5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIncidentImage(
                            imagePath: imagePath,
                            height: imageHeight,
                          ),
                          SizedBox(height: h * 0.015),

                          Text(
                            titulo,
                            style: TextStyle(
                              fontSize: fontSize * 1.12,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w700,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Text(
                            'Descripción:',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w800,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _borderColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              descripcion,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontFamily: 'Times New Roman',
                                color: _textColor,
                                height: 1.05,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          _buildDetailRow(
                            label: 'Fecha:',
                            value: fecha,
                            fontSize: fontSize,
                          ),
                          const SizedBox(height: 6),
                          _buildDetailRow(
                            label: 'Ubicación:',
                            value: ubicacion,
                            fontSize: fontSize,
                          ),
                          const SizedBox(height: 6),
                          _buildDetailRow(
                            label: 'Tipo de incidente:',
                            value: tipoIncidente,
                            fontSize: fontSize,
                          ),
                          const SizedBox(height: 6),
                          _buildDetailRow(
                            label: 'Estado:',
                            value: _selectedStatus,
                            fontSize: fontSize,
                          ),

                          if (isAdmin) ...[
                            const SizedBox(height: 14),
                            Center(
                              child: Text(
                                'Actualizar estado',
                                style: TextStyle(
                                  fontSize: fontSize * 1.02,
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w700,
                                  color: _textColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildAdminStatusDropdown(fontSize),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: _guardarEstadoMock,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  'GUARDAR ESTADO',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ),
                            ),
                          ],

                          SizedBox(height: h * 0.025),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Text(
                                'VOLVER',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontFamily: 'Times New Roman',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAdminStatusDropdown(double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            setState(() {
              _isStatusExpanded = !_isStatusExpanded;
            });
          },
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: _statusColor(_selectedStatus),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedStatus,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'Times New Roman',
                      color: _textColor,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isStatusExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isStatusExpanded) ...[
          const SizedBox(height: 6),
          ..._statusOptions.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  setState(() {
                    _selectedStatus = item;
                    _isStatusExpanded = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: _statusColor(item),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _borderColor, width: 1),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'Times New Roman',
                      color: _textColor,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}