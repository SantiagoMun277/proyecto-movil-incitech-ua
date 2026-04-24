import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';

class MyIncidentDetailScreen extends StatelessWidget {
  const MyIncidentDetailScreen({super.key});

  static const Color _backgroundColor = Color(0xFFB8DEBE);
  static const Color _cardColor = Color(0xFFF2F2F2);
  static const Color _primaryGreen = Color(0xFF0C7A27);
  static const Color _textColor = Color(0xFF222222);
  static const Color _shadowGreen = Color(0x664FA96A);
  static const Color _borderColor = Color(0xFF6A6A6A);

  String _safeText(String? value, String fallback) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  bool _isLocalFilePath(String path) {
    return path.startsWith('/') || path.startsWith('file://');
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

    final titulo = incident == null
        ? 'Falta de libros en la biblioteca'
        : _safeText(
            incident.title,
            'Falta de libros en la biblioteca',
          );

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

    final estado = incident == null
        ? 'Reportado'
        : incident.status.label;

    final imagePath = incident?.imagePath;

    return Scaffold(
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
                          value: estado,
                          fontSize: fontSize,
                        ),

                        SizedBox(height: h * 0.025),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
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
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.editIncident,
                                      arguments: incident,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryGreen,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: Text(
                                    'MODIFICAR',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}