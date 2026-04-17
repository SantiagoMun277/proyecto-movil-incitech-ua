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

  @override
  Widget build(BuildContext context) {
    final incident =
        ModalRoute.of(context)?.settings.arguments as IncidentItem?;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: incident == null
            ? const Center(child: Text('No se recibió el incidente'))
            : LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;
                  final fontSize = w * 0.040;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: h * 0.02,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo_incitech.png',
                          width: w * 0.74,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: h * 0.02),
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
                              if (incident.imagePath != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    incident.imagePath!,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 180,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              SizedBox(height: h * 0.015),
                              Text(
                                incident.title,
                                style: TextStyle(
                                  fontSize: fontSize * 1.10,
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w700,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Descripción:\n\n${incident.description}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontFamily: 'Times New Roman',
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Fecha: ${incident.date}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontFamily: 'Times New Roman',
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Ubicación: ${incident.location}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontFamily: 'Times New Roman',
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tipo de incidente: ${incident.type}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontFamily: 'Times New Roman',
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Estado: ${incident.status.label}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontFamily: 'Times New Roman',
                                  color: _textColor,
                                ),
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
                                            borderRadius:
                                                BorderRadius.circular(24),
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
                                            borderRadius:
                                                BorderRadius.circular(24),
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