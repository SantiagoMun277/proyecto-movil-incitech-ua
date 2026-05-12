



import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
import 'package:my_app_incitech_ua/features/incidents/models/selected_map_location.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/map_location_picker_screen.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/gps_location_row.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/gps_location_status_card.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/incident_image.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/incident_option_sheet.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/photo_source_sheet.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/report_result_dialog.dart';
import 'package:my_app_incitech_ua/services/image_service.dart';
import 'package:my_app_incitech_ua/services/incident_service.dart';
import 'package:my_app_incitech_ua/services/location_service.dart';

class EditIncidentScreen extends StatefulWidget {
  const EditIncidentScreen({super.key});

  @override
  State<EditIncidentScreen> createState() => _EditIncidentScreenState();
}

class _EditIncidentScreenState extends State<EditIncidentScreen> {
  static const Color _backgroundColor = AppColors.backgroundGreen;
  static const Color _cardColor = AppColors.softWhite;
  static const Color _inputColor = AppColors.panelInput;
  static const Color _primaryGreen = AppColors.primaryGreen;
  static const Color _primaryGreenDark = AppColors.primaryGreenDark;
  static const Color _textColor = AppColors.textDark;
  static const Color _shadowGreen = AppColors.shadowGreen;
  static const Color _borderColor = AppColors.borderColor;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final LocationService _locationService = LocationService();
  final ImageService _imageService = ImageService();
  final IncidentService _incidentService = IncidentService();

  bool _loaded = false;
  bool _isGettingGps = false;
  bool _saving = false;
  bool _imageChangedByUser = false;

  double? _gpsLatitude;
  double? _gpsLongitude;
  bool _gpsRegistrada = false;

  String _selectedType = 'Seleccionar un tipo';
  String _selectedCampus = 'Sede Porvenir';

  String? _previewImagePath;
  XFile? _selectedImageFile;
  Uint8List? _selectedImageBytes;

  IncidentItem? _incident;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;

    final incident = _readIncidentFromArgs(
      ModalRoute.of(context)?.settings.arguments,
    );

    _incident = incident;

    if (incident == null) {
      _titleController.text = '';
      _locationTextController.text = '';
      _descriptionController.text = '';
      _selectedType = 'Seleccionar un tipo';
      _selectedCampus = 'Sede Porvenir';
      _loaded = true;
      return;
    }

    final rawData = incident.rawData;

    _titleController.text = _safeText(incident.title, '');
    _descriptionController.text = _safeText(incident.description, '');

    final type = _safeText(incident.type, 'Otros');
    _selectedType = _typeOptions.contains(type) ? type : 'Otros';

    final campus = _readTextFromData(
      rawData,
      ['sede', 'campus'],
      fallback: 'Sede Porvenir',
    );

    _selectedCampus = _campusOptions.contains(campus)
        ? campus
        : 'Sede Porvenir';

    final locationText = _readTextFromData(
      rawData,
      [
        'ubicacionTextual',
        'ubicacionTexto',
        'locationText',
        'ubicacion',
        'location',
      ],
      fallback: incident.location,
    );

    _locationTextController.text = locationText;

    _previewImagePath = incident.imagePath;

    _loadGpsFromIncident(rawData);

    _loaded = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationTextController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  IncidentItem? _readIncidentFromArgs(Object? args) {
    if (args is IncidentItem) {
      return args;
    }

    if (args is Map) {
      final value = args['incident'];

      if (value is IncidentItem) {
        return value;
      }
    }

    return null;
  }

  String _safeText(String? value, String fallback) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  String _readTextFromData(
    Map<String, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = data[key];

      if (value == null) continue;

      final text = value.toString().trim();

      if (text.isNotEmpty && text != 'null') {
        return text;
      }
    }

    return fallback;
  }

  bool _readBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) return value;

    if (value is num) return value == 1;

    final text = value.toString().trim().toLowerCase();

    return text == 'true' ||
        text == '1' ||
        text == 'si' ||
        text == 'sí' ||
        text == 'yes';
  }

  double? _readDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) return value.toDouble();

    if (value is String) {
      return double.tryParse(value.trim());
    }

    return null;
  }

  void _loadGpsFromIncident(Map<String, dynamic> rawData) {
    final gps = rawData['gps'];

    if (gps is GeoPoint) {
      _gpsLatitude = gps.latitude;
      _gpsLongitude = gps.longitude;
      _gpsRegistrada = true;
      return;
    }

    _gpsLatitude = _readDouble(
      rawData['gpsLatitud'] ??
          rawData['gpsLatitude'] ??
          rawData['latitud'],
    );

    _gpsLongitude = _readDouble(
      rawData['gpsLongitud'] ??
          rawData['gpsLongitude'] ??
          rawData['longitud'],
    );

    final gpsFlag = _readBool(
      rawData['gpsRegistrada'] ??
          rawData['gpsRegistrado'] ??
          rawData['gpsRegistered'],
    );

    _gpsRegistrada = gpsFlag ||
        (_gpsLatitude != null && _gpsLongitude != null);
  }

  bool _isAssetPath(String? path) {
    if (path == null) return false;
    return path.trim().startsWith('assets/');
  }

  Future<void> _restoreLostImageIfNeeded() async {
    return;
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
      const SnackBar(
        content: Text('Ubicación GPS registrada correctamente.'),
      ),
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
      const SnackBar(
        content: Text('Ubicación GPS ajustada correctamente.'),
      ),
    );
  }

  Future<XFile?> _pickFromCamera() async {
    final file = await _imageService.takePhoto();
    return file;
  }

  Future<XFile?> _pickFromGallery() async {
    final file = await _imageService.pickFromGallery();
    return file;
  }

  Future<void> _openPhotoSheet() async {
    final selected = await PhotoSourceSheet.show(
      context: context,
      onCameraPick: _pickFromCamera,
      onGalleryPick: _pickFromGallery,
      initialFile: _selectedImageFile,
      initialAssetPath: _isAssetPath(_previewImagePath)
          ? _previewImagePath
          : null,
    );

    if (!mounted || selected == null) return;

    final bytes = await selected.readAsBytes();

    if (!mounted) return;

    setState(() {
      _selectedImageFile = selected;
      _selectedImageBytes = bytes;
      _previewImagePath = null;
      _imageChangedByUser = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Imagen confirmada correctamente.'),
      ),
    );
  }

  bool _validarFormulario() {
    if (_incident == null) return false;
    if (_titleController.text.trim().isEmpty) return false;
    if (_selectedType.trim().isEmpty ||
        _selectedType == 'Seleccionar un tipo') {
      return false;
    }
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
        title: 'Incidente Modificado\nCorrectamente',
        message: 'Los cambios del reporte se guardaron con éxito.',
        buttonText: 'Aceptar ↗',
        onButtonPressed: () {
          Navigator.pop(context);
          Navigator.pop(context, true);
        },
      ),
    );
  }

  Future<void> _mostrarDialogoError({
    String? message,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ReportResultDialog(
        isSuccess: false,
        title: 'Fallo al Modificar\nel Reporte',
        message: message ??
            'Hubo un problema al procesar los cambios.\n\nPor favor, verifique la información e intente nuevamente.',
        buttonText: 'Reintentar ↻',
        onButtonPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _guardarIncidente() async {
    if (_saving) return;

    final valido = _validarFormulario();

    if (!valido || _incident == null) {
      await _mostrarDialogoError(
        message:
            'Verifique que todos los campos estén completos antes de guardar.',
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await _incidentService.updateIncident(
        incidentId: _incident!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        campus: _selectedCampus,
        locationText: _locationTextController.text.trim(),
        gpsRegistered: _gpsRegistrada,
        gpsLatitude: _gpsLatitude,
        gpsLongitude: _gpsLongitude,
        imageFile: _imageChangedByUser ? _selectedImageFile : null,
      );

      if (!mounted) return;

      await _mostrarDialogoExito();
    } catch (error) {
      debugPrint('ERROR MODIFICANDO INCIDENTE: $error');

      if (!mounted) return;

      await _mostrarDialogoError(
        message: 'No se pudo guardar el incidente.\n\n$error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _primaryGreen,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: _primaryGreen.withValues(alpha: 0.55),
      disabledForegroundColor: AppColors.white,
      elevation: 2,
      minimumSize: const Size(0, 46),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  ButtonStyle _secondaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.panelLight,
      foregroundColor: _primaryGreenDark,
      disabledBackgroundColor: AppColors.panelLight.withValues(alpha: 0.55),
      disabledForegroundColor: _primaryGreenDark.withValues(alpha: 0.55),
      elevation: 0,
      minimumSize: const Size(0, 46),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _borderColor.withValues(alpha: 0.55),
          width: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final incident = _incident;
    final imagePath = _previewImagePath ?? incident?.imagePath;

    final fechaHora = incident?.date ?? '';
    final estado = incident?.status.label ?? 'Reportado';

    if (_loaded && incident == null) {
      return const Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Center(
            child: Text(
              'No se encontró la información del incidente para modificar.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;

              final fontSize = (w * 0.038).clamp(13.0, 16.0).toDouble();
              final titleFontSize = (w * 0.052).clamp(18.0, 22.0).toDouble();
              final logoWidth = (w * 0.58).clamp(190.0, 270.0).toDouble();
              final imageHeight = (w * 0.47).clamp(155.0, 220.0).toDouble();

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.018,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_incitech.png',
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: h * 0.018),
                    _buildTopHeader(fontSize),
                    SizedBox(height: h * 0.016),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: _shadowGreen.withValues(alpha: 0.28),
                            offset: const Offset(0, 8),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIntroPanel(fontSize),
                            const SizedBox(height: 14),
                            _buildSectionCard(
                              icon: Icons.assignment_outlined,
                              title: 'Datos principales',
                              fontSize: fontSize,
                              children: [
                                _buildFieldLabel('Título', fontSize),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _titleController,
                                  fontSize: fontSize,
                                  leadingIcon: Icons.title_rounded,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 13),
                                _buildFieldLabel(
                                  'Tipo de incidente',
                                  fontSize,
                                ),
                                const SizedBox(height: 6),
                                _buildDropdownField(
                                  text: _selectedType,
                                  fontSize: fontSize,
                                  onTap: _selectType,
                                  leadingIcon: Icons.category_outlined,
                                  isPlaceholder:
                                      _selectedType == 'Seleccionar un tipo',
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildSectionCard(
                              icon: Icons.location_on_outlined,
                              title: 'Ubicación',
                              fontSize: fontSize,
                              children: [
                                _buildFieldLabel('Sede', fontSize),
                                const SizedBox(height: 6),
                                _buildDropdownField(
                                  text: _selectedCampus,
                                  fontSize: fontSize,
                                  onTap: _selectCampus,
                                  leadingIcon: Icons.apartment_rounded,
                                ),
                                const SizedBox(height: 13),
                                _buildFieldLabel(
                                  'Ubicación textual',
                                  fontSize,
                                ),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _locationTextController,
                                  fontSize: fontSize,
                                  leadingIcon: Icons.place_outlined,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 12),
                                _buildGpsActionWrapper(fontSize),
                                const SizedBox(height: 10),
                                GpsLocationStatusCard(
                                  fontSize: fontSize,
                                  isRegistered: _gpsRegistrada,
                                  latitude: _gpsLatitude,
                                  longitude: _gpsLongitude,
                                  onOpenMap: _gpsRegistrada
                                      ? _ajustarUbicacionEnMapa
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildPhotoSection(
                              imagePath: imagePath,
                              imageHeight: imageHeight,
                              fontSize: fontSize,
                            ),
                            const SizedBox(height: 14),
                            _buildSectionCard(
                              icon: Icons.notes_rounded,
                              title: 'Descripción',
                              fontSize: fontSize,
                              children: [
                                _buildFieldLabel(
                                  'Detalle del problema',
                                  fontSize,
                                ),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _descriptionController,
                                  fontSize: fontSize,
                                  leadingIcon: Icons.edit_note_rounded,
                                  maxLines: 7,
                                  minLines: 5,
                                  textInputAction: TextInputAction.newline,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildInfoSection(
                              fechaHora: fechaHora,
                              estado: estado,
                              fontSize: fontSize,
                            ),
                            const SizedBox(height: 18),
                            _buildActionButtons(
                              width: w,
                              fontSize: fontSize,
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: Text(
                                '¡UNIVERSIDAD DE LA AMAZONIA\nMÁS CONECTADA QUE NUNCA!',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.semiBold(
                                  fontSize * 0.94,
                                  color: _textColor,
                                ).copyWith(height: 1.15),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildTopHeader(double fontSize) {
    return Row(
      children: [
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _saving ? null : () => Navigator.pop(context),
            child: Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_rounded,
                color: _primaryGreenDark,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Modificar incidente',
            style: AppTextStyles.extraBold(
              fontSize * 1.18,
              color: _textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntroPanel(double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.panelLight.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _primaryGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: _primaryGreenDark,
              size: 19,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar reporte',
                  style: AppTextStyles.extraBold(
                    fontSize * 1.03,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Actualiza los datos del incidente sin cambiar su registro base.',
                  style: AppTextStyles.regular(
                    fontSize * 0.90,
                    color: AppColors.textSecondary,
                  ).copyWith(height: 1.18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required double fontSize,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.panelLight.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: icon,
            title: title,
            fontSize: fontSize,
          ),
          const SizedBox(height: 13),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required double fontSize,
  }) {
    return Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: _primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 18,
            color: _primaryGreenDark,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.extraBold(
              fontSize * 1.02,
              color: _textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: AppTextStyles.extraBold(
          fontSize * 0.94,
          color: _textColor,
        ),
      ),
    );
  }

  Widget _buildGpsActionWrapper(double fontSize) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: GpsLocationRow(
        fontSize: fontSize,
        onTap: _usarGps,
        isLoading: _isGettingGps,
      ),
    );
  }

  Widget _buildPhotoSection({
    required String? imagePath,
    required double imageHeight,
    required double fontSize,
  }) {
    return _buildSectionCard(
      icon: Icons.image_outlined,
      title: 'Imagen del incidente',
      fontSize: fontSize,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.softWhite,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _borderColor.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _buildPreviewImage(
              width: double.infinity,
              height: imageHeight,
              imagePath: imagePath,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: _openPhotoSheet,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(
              'Cambiar imagen',
              style: AppTextStyles.button(fontSize),
            ),
            style: _primaryButtonStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required String fechaHora,
    required String estado,
    required double fontSize,
  }) {
    return _buildSectionCard(
      icon: Icons.info_outline_rounded,
      title: 'Información actual',
      fontSize: fontSize,
      children: [
        if (fechaHora.trim().isNotEmpty)
          _buildInfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'Fecha y hora:',
            value: fechaHora,
            fontSize: fontSize,
          ),
        _buildInfoRow(
          icon: Icons.flag_outlined,
          label: 'Estado:',
          value: estado,
          fontSize: fontSize,
        ),
      ],
    );
  }

  Widget _buildActionButtons({
    required double width,
    required double fontSize,
  }) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(
                'Volver',
                style: AppTextStyles.button(
                  fontSize,
                  color: _primaryGreenDark,
                ),
              ),
              style: _secondaryButtonStyle(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _guardarIncidente,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _saving ? 'Guardando...' : 'Guardar',
                style: AppTextStyles.button(fontSize),
              ),
              style: _primaryButtonStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewImage({
    required double width,
    required double height,
    required String? imagePath,
  }) {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(
            width: width,
            height: height,
          );
        },
      );
    }

    if (imagePath != null && imagePath.trim().isNotEmpty) {
      return IncidentImage(
        imagePath: imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return _buildImagePlaceholder(
      width: width,
      height: height,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required double fontSize,
  }) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 17,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label ',
                    style: AppTextStyles.extraBold(
                      fontSize,
                      color: _textColor,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: AppTextStyles.regular(
                      fontSize,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required double fontSize,
    IconData? leadingIcon,
    double? height,
    int maxLines = 1,
    int? minLines,
    TextInputAction? textInputAction,
  }) {
    final isMultiline = maxLines > 1 || (minLines != null && minLines > 1);

    return SizedBox(
      height: isMultiline ? null : height ?? 44,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        textInputAction: textInputAction,
        style: AppTextStyles.regular(
          fontSize,
          color: _textColor,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: _inputColor,
          isDense: true,
          prefixIcon: leadingIcon == null
              ? null
              : Icon(
                  leadingIcon,
                  size: 19,
                  color: _primaryGreenDark,
                ),
          prefixIconConstraints: leadingIcon == null
              ? null
              : const BoxConstraints(
                  minWidth: 42,
                  minHeight: 42,
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: _borderColor.withValues(alpha: 0.45),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: _primaryGreen,
              width: 1.4,
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
    IconData? leadingIcon,
    bool isPlaceholder = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 44,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _inputColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _borderColor.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 19,
                color: _primaryGreenDark,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.regular(
                  fontSize,
                  color: isPlaceholder
                      ? AppColors.textSecondary
                      : _textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 25,
              color: _primaryGreenDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_outlined,
            size: 38,
            color: Colors.white70,
          ),
          const SizedBox(height: 6),
          Text(
            'Sin imagen seleccionada',
            style: AppTextStyles.semiBold(
              13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
