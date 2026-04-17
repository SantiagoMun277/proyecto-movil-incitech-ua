import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';

class EditIncidentScreen extends StatefulWidget {
  const EditIncidentScreen({super.key});

  @override
  State<EditIncidentScreen> createState() => _EditIncidentScreenState();
}

class _EditIncidentScreenState extends State<EditIncidentScreen> {
  static const Color _backgroundColor = Color(0xFFB8DEBE);
  static const Color _cardColor = Color(0xFFF2F2F2);
  static const Color _primaryGreen = Color(0xFF0C7A27);
  static const Color _textColor = Color(0xFF222222);
  static const Color _shadowGreen = Color(0x664FA96A);

  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final incident =
        ModalRoute.of(context)?.settings.arguments as IncidentItem?;

    _titleController = TextEditingController(text: incident?.title ?? '');
    _locationController = TextEditingController(text: incident?.location ?? '');
    _descriptionController =
        TextEditingController(text: incident?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
                              Text(
                                'Modificar incidente',
                                style: TextStyle(
                                  fontSize: fontSize * 1.05,
                                  fontFamily: 'Times New Roman',
                                  fontWeight: FontWeight.w700,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _buildLabel('Titulo'),
                              _buildInput(_titleController),
                              const SizedBox(height: 12),
                              _buildLabel('Ubicación'),
                              _buildInput(_locationController),
                              const SizedBox(height: 12),
                              _buildLabel('Descripción'),
                              _buildInput(
                                _descriptionController,
                                maxLines: 5,
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Más adelante aquí guardaremos en Supabase.',
                                              ),
                                            ),
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
                                          'GUARDAR',
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Times New Roman',
          color: _textColor,
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Times New Roman',
        color: _textColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: _cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primaryGreen),
        ),
      ),
    );
  }
}