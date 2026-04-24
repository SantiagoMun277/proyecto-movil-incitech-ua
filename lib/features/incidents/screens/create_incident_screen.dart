import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_app_incitech_ua/features/incidents/models/selected_map_location.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/map_location_picker_screen.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/gps_location_row.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/gps_location_status_card.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/incident_option_sheet.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/photo_source_sheet.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/report_result_dialog.dart';

import '../../../services/image_service.dart';
import '../../../services/location_service.dart';

class CreateIncidentScreen extends StatefulWidget {
  const CreateIncidentScreen({super.key});

  @override
  State<CreateIncidentScreen> createState() => _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends State<CreateIncidentScreen> {
  static const Color _backgroundColor = Color(0xFFB8DEBE);
  static const Color _cardColor = Color(0xFFF2F2F2);
  static const Color _inputColor = Color(0xFFB8DEBE);
  static const Color _primaryGreen = Color(0xFF0C7A27);
  static const Color _textColor = Color(0xFF222222);
  static const Color _shadowGreen = Color(0x664FA96A);
  static const Color _borderColor = Color(0xFF4E4E4E);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final LocationService _locationService = LocationService();
  final ImageService _imageService = ImageService();

  bool _isGettingGps = false;

  double? _gpsLatitude;
  double? _gpsLongitude;
  bool _gpsRegistrada = false;

  String _selectedType = 'Seleccionar un tipo';
  String _selectedCampus = 'Sede Porvenir';

  XFile? _selectedImageFile;

  final List<String> _typeOptions = const [
    'Infraestructura',
    'Electricidad',
    'Hidráulico / agua',
    'Baños / saneamiento',
    'Seguridad',
    'Aseo y limpieza',
    'Mobiliario',
    'Tecnología / equipos',
    'Conectividad / red',
    'Zonas verdes / exteriores',
    'Señalización / accesibilidad',
    'Riesgo biológico o ambiental',
    'Emergencia',
    'Convivencia / comportamiento',
    'Otros',
  ];

  final List<String> _campusOptions = const [
    'Sede Porvenir',
    'Sede Juan XXII',
    'Sede social',
    'Sede santo domingo',
    'Sede macagual',
  ];

  @override
  void initState() {
    super.initState();
    _restoreLostImageIfNeeded();
  }

  Future<void> _restoreLostImageIfNeeded() async {
    final files = await _imageService.retrieveLostImages();
    if (!mounted || files.isEmpty) return;

    setState(() {
      _selectedImageFile = files.first;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationTextController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formattedNow() {
    final now = DateTime.now();

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(now.day)}/${twoDigits(now.month)}/${now.year} - ${twoDigits(now.hour)}:${twoDigits(now.minute)}';
  }

  Future<void> _selectType() async {
    final selected = await IncidentOptionSheet.show(
      context: context,
      title: 'Tipo de incidente',
      selectedValue: _selectedType,
      options: _typeOptions,
    );

    if (selected != null) {
      setState(() => _selectedType = selected);
    }
  }

  Future<void> _selectCampus() async {
    final selected = await IncidentOptionSheet.show(
      context: context,
      title: 'Ubicación',
      selectedValue: _selectedCampus,
      options: _campusOptions,
    );

    if (selected != null) {
      setState(() => _selectedCampus = selected);
    }
  }

  Future<void> _usarGps() async {
    setState(() {
      _isGettingGps = true;
    });

    final result = await _locationService.getCurrentLocation();

    if (!mounted) return;

    setState(() {
      _isGettingGps = false;
    });

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );

      if (result.message.contains('apagado')) {
        await _locationService.openLocationSettings();
      } else if (result.message.contains('permanentemente')) {
        await _locationService.openAppSettings();
      }
      return;
    }

    final selected = await Navigator.push<SelectedMapLocation>(
      context,
      MaterialPageRoute(
        builder: (_) => MapLocationPickerScreen(
          initialLatitude: result.latitude!,
          initialLongitude: result.longitude!,
        ),
      ),
    );

    if (!mounted || selected == null) return;

    setState(() {
      _gpsLatitude = selected.latitude;
      _gpsLongitude = selected.longitude;
      _gpsRegistrada = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ubicación GPS registrada correctamente.')),
    );
  }

  Future<void> _ajustarUbicacionEnMapa() async {
    if (_gpsLatitude == null || _gpsLongitude == null) return;

    final selected = await Navigator.push<SelectedMapLocation>(
      context,
      MaterialPageRoute(
        builder: (_) => MapLocationPickerScreen(
          initialLatitude: _gpsLatitude!,
          initialLongitude: _gpsLongitude!,
        ),
      ),
    );

    if (!mounted || selected == null) return;

    setState(() {
      _gpsLatitude = selected.latitude;
      _gpsLongitude = selected.longitude;
      _gpsRegistrada = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ubicación GPS ajustada correctamente.')),
    );
  }

  Future<XFile?> _pickFromCamera() async {
    return _imageService.takePhoto();
  }

  Future<XFile?> _pickFromGallery() async {
    return _imageService.pickFromGallery();
  }

  Future<void> _openPhotoSheet() async {
    final selected = await PhotoSourceSheet.show(
      context: context,
      onCameraPick: _pickFromCamera,
      onGalleryPick: _pickFromGallery,
      initialFile: _selectedImageFile,
      initialAssetPath: null,
    );

    if (!mounted || selected == null) return;

    setState(() {
      _selectedImageFile = selected;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Imagen confirmada correctamente.')),
    );
  }

  bool _validarFormulario() {
    if (_titleController.text.trim().isEmpty) return false;
    if (_selectedType == 'Seleccionar un tipo') return false;
    if (_selectedCampus.trim().isEmpty) return false;
    if (_locationTextController.text.trim().isEmpty) return false;
    if (_descriptionController.text.trim().isEmpty) return false;
    return true;
  }

  Future<void> _mostrarDialogoExito() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ReportResultDialog(
        isSuccess: true,
        title: 'Incidente Guardado\nCorrectamente',
        message: 'Su reporte ha sido recibido\ncon éxito.',
        buttonText: 'Aceptar ↗',
        onButtonPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _mostrarDialogoError() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ReportResultDialog(
        isSuccess: false,
        title: 'Fallo al Guardar\nel Reporte',
        message:
            'Hubo un problema al procesar su\nreporte.\n\nPor favor, verifique su conexión e\nintente nuevamente.',
        buttonText: 'Reintentar ↻',
        onButtonPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _guardarMock() async {
    final valido = _validarFormulario();

    if (!valido) {
      await _mostrarDialogoError();
      return;
    }

    await _mostrarDialogoExito();
  }

  @override
  Widget build(BuildContext context) {
    const estado = 'Reportado';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              final fontSize = w * 0.040;
              final double photoSectionWidth = w * 0.52;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  w * 0.05,
                  h * 0.02,
                  w * 0.05,
                  h * 0.02,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_incitech.png',
                      width: w * 0.78,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: h * 0.028),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Titulo:', fontSize),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _titleController,
                            fontSize: fontSize,
                            height: 38,
                          ),

                          const SizedBox(height: 18),

                          _buildLabel('Tipo de incidente', fontSize),
                          const SizedBox(height: 6),
                          _buildDropdownField(
                            text: _selectedType,
                            fontSize: fontSize,
                            onTap: _selectType,
                          ),

                          const SizedBox(height: 26),

                          _buildLabel('Ubicación:', fontSize),
                          const SizedBox(height: 6),
                          _buildDropdownField(
                            text: _selectedCampus,
                            fontSize: fontSize,
                            onTap: _selectCampus,
                            arrowColor: Colors.grey.shade600,
                          ),

                          const SizedBox(height: 12),

                          _buildLabel('Ubicación Textual', fontSize),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _locationTextController,
                            fontSize: fontSize,
                            height: 38,
                          ),

                          const SizedBox(height: 12),

                          GpsLocationRow(
                            fontSize: fontSize,
                            onTap: _usarGps,
                            isLoading: _isGettingGps,
                          ),

                          const SizedBox(height: 12),

                          GpsLocationStatusCard(
                            fontSize: fontSize,
                            isRegistered: _gpsRegistrada,
                            latitude: _gpsLatitude,
                            longitude: _gpsLongitude,
                            onOpenMap:
                                _gpsRegistrada ? _ajustarUbicacionEnMapa : null,
                          ),

                          const SizedBox(height: 18),

                          _buildLabel('Descripción:', fontSize),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _descriptionController,
                            fontSize: fontSize,
                            maxLines: 8,
                            minLines: 8,
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: SizedBox(
                              width: photoSectionWidth,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: _selectedImageFile != null
                                        ? Image.file(
                                            File(_selectedImageFile!.path),
                                            width: photoSectionWidth,
                                            height: 110,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _buildImagePlaceholder(
                                              width: photoSectionWidth,
                                            ),
                                          )
                                        : _buildImagePlaceholder(
                                            width: photoSectionWidth,
                                          ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: photoSectionWidth,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: _openPhotoSheet,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFA8B9AA),
                                        foregroundColor: Colors.black54,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color: _borderColor,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        _selectedImageFile == null
                                            ? 'Agregar foto'
                                            : 'Cambiar foto',
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
                          ),

                          const SizedBox(height: 42),

                          _buildInfoRow(
                            'Fecha y hora:',
                            _formattedNow(),
                            fontSize,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Estado:', estado, fontSize),

                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: w * 0.34,
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: Text(
                                    'VOLVER',
                                    style: TextStyle(
                                      fontSize: fontSize * 0.92,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: w * 0.34,
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: _guardarMock,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: Text(
                                    'GUARDAR',
                                    style: TextStyle(
                                      fontSize: fontSize * 0.92,
                                      fontFamily: 'Times New Roman',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 26),

                          Center(
                            child: Text(
                              '¡UNIVERSIDAD DE LA AMAZONIA\nMAS CONECTADA QUE NUNCA!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontSize * 1.02,
                                height: 1.0,
                                fontWeight: FontWeight.w600,
                                color: _textColor,
                                fontFamily: 'Times New Roman',
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

  Widget _buildLabel(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize * 1.02,
          fontFamily: 'Times New Roman',
          color: _textColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, double fontSize) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(
              fontSize: fontSize * 1.02,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: fontSize * 1.02,
              fontFamily: 'Times New Roman',
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required double fontSize,
    double? height,
    int maxLines = 1,
    int? minLines,
  }) {
    final isMultiline = maxLines > 1 || (minLines != null && minLines > 1);

    return SizedBox(
      height: isMultiline ? null : height ?? 38,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Times New Roman',
          color: _textColor,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: _inputColor,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _borderColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _primaryGreen,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String text,
    required double fontSize,
    required VoidCallback onTap,
    Color arrowColor = Colors.black,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _inputColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Times New Roman',
                  color: text == 'Seleccionar un tipo'
                      ? Colors.grey.shade700
                      : _textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_drop_down,
              size: 28,
              color: arrowColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder({required double width}) {
    return Container(
      width: width,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.image_outlined,
        size: 34,
        color: Colors.white70,
      ),
    );
  }
}