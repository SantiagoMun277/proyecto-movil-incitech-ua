

// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
// import 'package:my_app_incitech_ua/features/incidents/models/selected_map_location.dart';
// import 'package:my_app_incitech_ua/features/incidents/screens/map_location_picker_screen.dart';
// import 'package:my_app_incitech_ua/features/incidents/widgets/gps_location_row.dart';
// import 'package:my_app_incitech_ua/features/incidents/widgets/gps_location_status_card.dart';
// import 'package:my_app_incitech_ua/features/incidents/widgets/incident_image.dart';
// import 'package:my_app_incitech_ua/features/incidents/widgets/incident_option_sheet.dart';
// import 'package:my_app_incitech_ua/features/incidents/widgets/photo_source_sheet.dart';
// import 'package:my_app_incitech_ua/features/incidents/widgets/report_result_dialog.dart';
// import 'package:my_app_incitech_ua/services/image_service.dart';
// import 'package:my_app_incitech_ua/services/incident_service.dart';
// import 'package:my_app_incitech_ua/services/location_service.dart';

// class EditIncidentScreen extends StatefulWidget {
//   const EditIncidentScreen({super.key});

//   @override
//   State<EditIncidentScreen> createState() => _EditIncidentScreenState();
// }

// class _EditIncidentScreenState extends State<EditIncidentScreen> {
//   static const Color _backgroundColor = Color(0xFFB8DEBE);
//   static const Color _cardColor = Color(0xFFF2F2F2);
//   static const Color _inputColor = Color(0xFFB8DEBE);
//   static const Color _primaryGreen = Color(0xFF0C7A27);
//   static const Color _textColor = Color(0xFF222222);
//   static const Color _shadowGreen = Color(0x664FA96A);
//   static const Color _borderColor = Color(0xFF4E4E4E);

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _locationTextController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   final LocationService _locationService = LocationService();
//   final ImageService _imageService = ImageService();
//   final IncidentService _incidentService = IncidentService();

//   bool _loaded = false;
//   bool _isGettingGps = false;
//   bool _saving = false;

//   double? _gpsLatitude;
//   double? _gpsLongitude;
//   bool _gpsRegistrada = false;

//   String _selectedType = 'Seleccionar un tipo';
//   String _selectedCampus = 'Sede Porvenir';

//   String? _previewImagePath;
//   XFile? _selectedImageFile;
//   Uint8List? _selectedImageBytes;

//   IncidentItem? _incident;

//   final List<String> _typeOptions = const [
//     'Infraestructura',
//     'Electricidad',
//     'Hidráulico / agua',
//     'Baños / saneamiento',
//     'Seguridad',
//     'Aseo y limpieza',
//     'Mobiliario',
//     'Tecnología / equipos',
//     'Conectividad / red',
//     'Zonas verdes / exteriores',
//     'Señalización / accesibilidad',
//     'Riesgo biológico o ambiental',
//     'Emergencia',
//     'Convivencia / comportamiento',
//     'Otros',
//   ];

//   final List<String> _campusOptions = const [
//     'Sede Porvenir',
//     'Sede Juan XXII',
//     'Sede social',
//     'Sede santo domingo',
//     'Sede macagual',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _restoreLostImageIfNeeded();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     if (_loaded) return;

//     final incident = _readIncidentFromArgs(
//       ModalRoute.of(context)?.settings.arguments,
//     );

//     _incident = incident;

//     if (incident == null) {
//       _titleController.text = '';
//       _locationTextController.text = '';
//       _descriptionController.text = '';
//       _selectedType = 'Seleccionar un tipo';
//       _selectedCampus = 'Sede Porvenir';
//       _loaded = true;
//       return;
//     }

//     final rawData = incident.rawData;

//     _titleController.text = _safeText(incident.title, '');
//     _descriptionController.text = _safeText(incident.description, '');

//     final type = _safeText(incident.type, 'Otros');
//     _selectedType = _typeOptions.contains(type) ? type : 'Otros';

//     final campus = _readTextFromData(
//       rawData,
//       ['sede', 'campus'],
//       fallback: 'Sede Porvenir',
//     );

//     _selectedCampus = _campusOptions.contains(campus)
//         ? campus
//         : 'Sede Porvenir';

//     final locationText = _readTextFromData(
//       rawData,
//       [
//         'ubicacionTextual',
//         'ubicacionTexto',
//         'locationText',
//         'ubicacion',
//         'location',
//       ],
//       fallback: incident.location,
//     );

//     _locationTextController.text = locationText;

//     _previewImagePath = incident.imagePath;

//     _loadGpsFromIncident(rawData);

//     _loaded = true;
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _locationTextController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   IncidentItem? _readIncidentFromArgs(Object? args) {
//     if (args is IncidentItem) {
//       return args;
//     }

//     if (args is Map) {
//       final value = args['incident'];

//       if (value is IncidentItem) {
//         return value;
//       }
//     }

//     return null;
//   }

//   String _safeText(String? value, String fallback) {
//     final text = value?.trim() ?? '';
//     return text.isEmpty ? fallback : text;
//   }

//   String _readTextFromData(
//     Map<String, dynamic> data,
//     List<String> keys, {
//     String fallback = '',
//   }) {
//     for (final key in keys) {
//       final value = data[key];

//       if (value == null) continue;

//       final text = value.toString().trim();

//       if (text.isNotEmpty && text != 'null') {
//         return text;
//       }
//     }

//     return fallback;
//   }

//   bool _readBool(dynamic value) {
//     if (value == null) return false;

//     if (value is bool) return value;

//     if (value is num) return value == 1;

//     final text = value.toString().trim().toLowerCase();

//     return text == 'true' ||
//         text == '1' ||
//         text == 'si' ||
//         text == 'sí' ||
//         text == 'yes';
//   }

//   double? _readDouble(dynamic value) {
//     if (value == null) return null;

//     if (value is num) return value.toDouble();

//     if (value is String) {
//       return double.tryParse(value.trim());
//     }

//     return null;
//   }

//   void _loadGpsFromIncident(Map<String, dynamic> rawData) {
//     final gps = rawData['gps'];

//     if (gps is GeoPoint) {
//       _gpsLatitude = gps.latitude;
//       _gpsLongitude = gps.longitude;
//       _gpsRegistrada = true;
//       return;
//     }

//     _gpsLatitude = _readDouble(
//       rawData['gpsLatitud'] ??
//           rawData['gpsLatitude'] ??
//           rawData['latitud'],
//     );

//     _gpsLongitude = _readDouble(
//       rawData['gpsLongitud'] ??
//           rawData['gpsLongitude'] ??
//           rawData['longitud'],
//     );

//     final gpsFlag = _readBool(
//       rawData['gpsRegistrada'] ??
//           rawData['gpsRegistrado'] ??
//           rawData['gpsRegistered'],
//     );

//     _gpsRegistrada = gpsFlag ||
//         (_gpsLatitude != null && _gpsLongitude != null);
//   }

//   bool _isAssetPath(String? path) {
//     if (path == null) return false;
//     return path.trim().startsWith('assets/');
//   }

//   Future<void> _restoreLostImageIfNeeded() async {
//     try {
//       final files = await _imageService.retrieveLostImages();

//       if (!mounted || files.isEmpty) return;

//       final file = files.first;
//       final bytes = await file.readAsBytes();

//       if (!mounted) return;

//       setState(() {
//         _selectedImageFile = file;
//         _selectedImageBytes = bytes;
//         _previewImagePath = null;
//       });
//     } catch (error) {
//       debugPrint('ERROR RECUPERANDO IMAGEN PERDIDA: $error');
//     }
//   }

//   Future<void> _selectType() async {
//     final selected = await IncidentOptionSheet.show(
//       context: context,
//       title: 'Tipo de incidente',
//       selectedValue: _selectedType,
//       options: _typeOptions,
//     );

//     if (selected != null) {
//       setState(() => _selectedType = selected);
//     }
//   }

//   Future<void> _selectCampus() async {
//     final selected = await IncidentOptionSheet.show(
//       context: context,
//       title: 'Ubicación',
//       selectedValue: _selectedCampus,
//       options: _campusOptions,
//     );

//     if (selected != null) {
//       setState(() => _selectedCampus = selected);
//     }
//   }

//   Future<void> _usarGps() async {
//     setState(() {
//       _isGettingGps = true;
//     });

//     final result = await _locationService.getCurrentLocation();

//     if (!mounted) return;

//     setState(() {
//       _isGettingGps = false;
//     });

//     if (!result.success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result.message)),
//       );

//       if (result.message.contains('apagado')) {
//         await _locationService.openLocationSettings();
//       } else if (result.message.contains('permanentemente')) {
//         await _locationService.openAppSettings();
//       }

//       return;
//     }

//     final selected = await Navigator.push<SelectedMapLocation>(
//       context,
//       MaterialPageRoute(
//         builder: (_) => MapLocationPickerScreen(
//           initialLatitude: result.latitude!,
//           initialLongitude: result.longitude!,
//         ),
//       ),
//     );

//     if (!mounted || selected == null) return;

//     setState(() {
//       _gpsLatitude = selected.latitude;
//       _gpsLongitude = selected.longitude;
//       _gpsRegistrada = true;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Ubicación GPS registrada correctamente.'),
//       ),
//     );
//   }

//   Future<void> _ajustarUbicacionEnMapa() async {
//     if (_gpsLatitude == null || _gpsLongitude == null) return;

//     final selected = await Navigator.push<SelectedMapLocation>(
//       context,
//       MaterialPageRoute(
//         builder: (_) => MapLocationPickerScreen(
//           initialLatitude: _gpsLatitude!,
//           initialLongitude: _gpsLongitude!,
//         ),
//       ),
//     );

//     if (!mounted || selected == null) return;

//     setState(() {
//       _gpsLatitude = selected.latitude;
//       _gpsLongitude = selected.longitude;
//       _gpsRegistrada = true;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Ubicación GPS ajustada correctamente.'),
//       ),
//     );
//   }

//   Future<XFile?> _pickFromCamera() async {
//     final file = await _imageService.takePhoto();
//     return file;
//   }

//   Future<XFile?> _pickFromGallery() async {
//     final file = await _imageService.pickFromGallery();
//     return file;
//   }

//   Future<void> _openPhotoSheet() async {
//     final selected = await PhotoSourceSheet.show(
//       context: context,
//       onCameraPick: _pickFromCamera,
//       onGalleryPick: _pickFromGallery,
//       initialFile: _selectedImageFile,
//       initialAssetPath: _isAssetPath(_previewImagePath)
//           ? _previewImagePath
//           : null,
//     );

//     if (!mounted || selected == null) return;

//     final bytes = await selected.readAsBytes();

//     if (!mounted) return;

//     setState(() {
//       _selectedImageFile = selected;
//       _selectedImageBytes = bytes;
//       _previewImagePath = null;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Imagen confirmada correctamente.'),
//       ),
//     );
//   }

//   bool _validarFormulario() {
//     if (_incident == null) return false;
//     if (_titleController.text.trim().isEmpty) return false;
//     if (_selectedType.trim().isEmpty ||
//         _selectedType == 'Seleccionar un tipo') {
//       return false;
//     }
//     if (_selectedCampus.trim().isEmpty) return false;
//     if (_locationTextController.text.trim().isEmpty) return false;
//     if (_descriptionController.text.trim().isEmpty) return false;

//     return true;
//   }

//   Future<void> _mostrarDialogoExito() async {
//     await showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) => ReportResultDialog(
//         isSuccess: true,
//         title: 'Incidente Modificado\nCorrectamente',
//         message: 'Los cambios del reporte se guardaron con éxito.',
//         buttonText: 'Aceptar ↗',
//         onButtonPressed: () {
//           Navigator.pop(context);
//           Navigator.pop(context, true);
//         },
//       ),
//     );
//   }

//   Future<void> _mostrarDialogoError({
//     String? message,
//   }) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) => ReportResultDialog(
//         isSuccess: false,
//         title: 'Fallo al Modificar\nel Reporte',
//         message: message ??
//             'Hubo un problema al procesar los cambios.\n\nPor favor, verifique la información e intente nuevamente.',
//         buttonText: 'Reintentar ↻',
//         onButtonPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }

//   Future<void> _guardarIncidente() async {
//     if (_saving) return;

//     final valido = _validarFormulario();

//     if (!valido || _incident == null) {
//       await _mostrarDialogoError(
//         message:
//             'Verifique que todos los campos estén completos antes de guardar.',
//       );
//       return;
//     }

//     setState(() {
//       _saving = true;
//     });

//     try {
//       await _incidentService.updateIncident(
//         incidentId: _incident!.id,
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         type: _selectedType,
//         campus: _selectedCampus,
//         locationText: _locationTextController.text.trim(),
//         gpsRegistered: _gpsRegistrada,
//         gpsLatitude: _gpsLatitude,
//         gpsLongitude: _gpsLongitude,
//         imageFile: _selectedImageFile,
//       );

//       if (!mounted) return;

//       await _mostrarDialogoExito();
//     } catch (error) {
//       debugPrint('ERROR MODIFICANDO INCIDENTE: $error');

//       if (!mounted) return;

//       await _mostrarDialogoError(
//         message:
//             'No se pudo guardar el incidente.\n\n$error',
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _saving = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final incident = _incident;
//     final imagePath = incident?.imagePath;

//     final fechaHora = incident?.date ?? '';
//     final estado = incident?.status.label ?? 'Reportado';

//     if (_loaded && incident == null) {
//       return const Scaffold(
//         backgroundColor: _backgroundColor,
//         body: SafeArea(
//           child: Center(
//             child: Text(
//               'No se encontró la información del incidente para modificar.',
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: _backgroundColor,
//         body: SafeArea(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final w = constraints.maxWidth;
//               final h = constraints.maxHeight;
//               final fontSize = w * 0.040;
//               final double photoSectionWidth = w * 0.52;

//               return SingleChildScrollView(
//                 padding: EdgeInsets.fromLTRB(
//                   w * 0.05,
//                   h * 0.02,
//                   w * 0.05,
//                   h * 0.02,
//                 ),
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'assets/images/logo_incitech.png',
//                       width: w * 0.78,
//                       fit: BoxFit.contain,
//                     ),
//                     SizedBox(height: h * 0.028),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
//                       decoration: BoxDecoration(
//                         color: _cardColor,
//                         borderRadius: BorderRadius.circular(22),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: _shadowGreen,
//                             offset: Offset(5, 6),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildLabel('Titulo:', fontSize),
//                           const SizedBox(height: 6),
//                           _buildTextField(
//                             controller: _titleController,
//                             fontSize: fontSize,
//                             height: 38,
//                           ),
//                           const SizedBox(height: 18),
//                           _buildLabel('Tipo de incidente', fontSize),
//                           const SizedBox(height: 6),
//                           _buildDropdownField(
//                             text: _selectedType,
//                             fontSize: fontSize,
//                             onTap: _selectType,
//                           ),
//                           const SizedBox(height: 26),
//                           _buildLabel('Sede:', fontSize),
//                           const SizedBox(height: 6),
//                           _buildDropdownField(
//                             text: _selectedCampus,
//                             fontSize: fontSize,
//                             onTap: _selectCampus,
//                             arrowColor: Colors.grey.shade600,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildLabel('Ubicación Textual', fontSize),
//                           const SizedBox(height: 6),
//                           _buildTextField(
//                             controller: _locationTextController,
//                             fontSize: fontSize,
//                             height: 38,
//                           ),
//                           const SizedBox(height: 12),
//                           GpsLocationRow(
//                             fontSize: fontSize,
//                             onTap: _usarGps,
//                             isLoading: _isGettingGps,
//                           ),
//                           const SizedBox(height: 12),
//                           GpsLocationStatusCard(
//                             fontSize: fontSize,
//                             isRegistered: _gpsRegistrada,
//                             latitude: _gpsLatitude,
//                             longitude: _gpsLongitude,
//                             onOpenMap: _gpsRegistrada
//                                 ? _ajustarUbicacionEnMapa
//                                 : null,
//                           ),
//                           const SizedBox(height: 18),
//                           _buildLabel('Descripción:', fontSize),
//                           const SizedBox(height: 6),
//                           _buildTextField(
//                             controller: _descriptionController,
//                             fontSize: fontSize,
//                             maxLines: 8,
//                             minLines: 8,
//                           ),
//                           const SizedBox(height: 20),
//                           Center(
//                             child: SizedBox(
//                               width: photoSectionWidth,
//                               child: Column(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(14),
//                                     child: _buildPreviewImage(
//                                       width: photoSectionWidth,
//                                       imagePath: imagePath,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   SizedBox(
//                                     width: photoSectionWidth,
//                                     height: 40,
//                                     child: ElevatedButton(
//                                       onPressed: _openPhotoSheet,
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             const Color(0xFFA8B9AA),
//                                         foregroundColor: Colors.black54,
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           side: const BorderSide(
//                                             color: _borderColor,
//                                             width: 1,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Text(
//                                         'Cambiar',
//                                         style: TextStyle(
//                                           fontSize: fontSize,
//                                           fontFamily: 'Times New Roman',
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 42),
//                           if (fechaHora.trim().isNotEmpty)
//                             _buildInfoRow(
//                               'Fecha y hora:',
//                               fechaHora,
//                               fontSize,
//                             ),
//                           if (fechaHora.trim().isNotEmpty)
//                             const SizedBox(height: 12),
//                           _buildInfoRow('Estado:', estado, fontSize),
//                           const SizedBox(height: 28),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SizedBox(
//                                 width: w * 0.34,
//                                 height: 38,
//                                 child: ElevatedButton(
//                                   onPressed: _saving
//                                       ? null
//                                       : () => Navigator.pop(context),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: _primaryGreen,
//                                     foregroundColor: Colors.white,
//                                     disabledBackgroundColor:
//                                         _primaryGreen.withOpacity(0.55),
//                                     disabledForegroundColor: Colors.white,
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(22),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     'VOLVER',
//                                     style: TextStyle(
//                                       fontSize: fontSize * 0.92,
//                                       fontFamily: 'Times New Roman',
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: w * 0.34,
//                                 height: 38,
//                                 child: ElevatedButton(
//                                   onPressed:
//                                       _saving ? null : _guardarIncidente,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: _primaryGreen,
//                                     foregroundColor: Colors.white,
//                                     disabledBackgroundColor:
//                                         _primaryGreen.withOpacity(0.55),
//                                     disabledForegroundColor: Colors.white,
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(22),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     _saving ? 'GUARDANDO...' : 'GUARDAR',
//                                     style: TextStyle(
//                                       fontSize: fontSize * 0.92,
//                                       fontFamily: 'Times New Roman',
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 26),
//                           Center(
//                             child: Text(
//                               '¡UNIVERSIDAD DE LA AMAZONIA\nMAS CONECTADA QUE NUNCA!',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: fontSize * 1.02,
//                                 height: 1.0,
//                                 fontWeight: FontWeight.w600,
//                                 color: _textColor,
//                                 fontFamily: 'Times New Roman',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPreviewImage({
//     required double width,
//     required String? imagePath,
//   }) {
//     if (_selectedImageBytes != null) {
//       return Image.memory(
//         _selectedImageBytes!,
//         width: width,
//         height: 110,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return _buildImagePlaceholder(width: width);
//         },
//       );
//     }

//     if (imagePath != null && imagePath.trim().isNotEmpty) {
//       return IncidentImage(
//         imagePath: imagePath,
//         width: width,
//         height: 110,
//         fit: BoxFit.cover,
//       );
//     }

//     return _buildImagePlaceholder(width: width);
//   }

//   Widget _buildLabel(String text, double fontSize) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 4),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: fontSize * 1.02,
//           fontFamily: 'Times New Roman',
//           color: _textColor,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value, double fontSize) {
//     return Text.rich(
//       TextSpan(
//         children: [
//           TextSpan(
//             text: '$label ',
//             style: TextStyle(
//               fontSize: fontSize * 1.02,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//           TextSpan(
//             text: value,
//             style: TextStyle(
//               fontSize: fontSize * 1.02,
//               fontFamily: 'Times New Roman',
//               color: _textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required double fontSize,
//     double? height,
//     int maxLines = 1,
//     int? minLines,
//   }) {
//     final isMultiline = maxLines > 1 || (minLines != null && minLines > 1);

//     return SizedBox(
//       height: isMultiline ? null : height ?? 38,
//       child: TextField(
//         controller: controller,
//         maxLines: maxLines,
//         minLines: minLines,
//         style: TextStyle(
//           fontSize: fontSize,
//           fontFamily: 'Times New Roman',
//           color: _textColor,
//         ),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: _inputColor,
//           isDense: true,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 10,
//             vertical: 10,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(
//               color: _borderColor,
//               width: 1,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(
//               color: _primaryGreen,
//               width: 1.2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownField({
//     required String text,
//     required double fontSize,
//     required VoidCallback onTap,
//     Color arrowColor = Colors.black,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: onTap,
//       child: Container(
//         height: 40,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           color: _inputColor,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: _borderColor,
//             width: 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: fontSize,
//                   fontFamily: 'Times New Roman',
//                   color: text == 'Seleccionar un tipo'
//                       ? Colors.grey.shade700
//                       : _textColor,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Icon(
//               Icons.arrow_drop_down,
//               size: 28,
//               color: arrowColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePlaceholder({required double width}) {
//     return Container(
//       width: width,
//       height: 110,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: const Icon(
//         Icons.image_outlined,
//         size: 34,
//         color: Colors.white70,
//       ),
//     );
//   }
// }


import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    // En edición no se recupera automáticamente una imagen perdida.
    // Esto evita que una imagen vieja del picker se tome como "nueva"
    // sin que el usuario haya presionado Cambiar.
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
                          _buildLabel('Sede:', fontSize),
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
                            onOpenMap: _gpsRegistrada
                                ? _ajustarUbicacionEnMapa
                                : null,
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
                                    child: _buildPreviewImage(
                                      width: photoSectionWidth,
                                      imagePath: imagePath,
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
                                        'Cambiar',
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
                          if (fechaHora.trim().isNotEmpty)
                            _buildInfoRow(
                              'Fecha y hora:',
                              fechaHora,
                              fontSize,
                            ),
                          if (fechaHora.trim().isNotEmpty)
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
                                  onPressed: _saving
                                      ? null
                                      : () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryGreen,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        _primaryGreen.withOpacity(0.55),
                                    disabledForegroundColor: Colors.white,
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
                                  onPressed:
                                      _saving ? null : _guardarIncidente,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryGreen,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        _primaryGreen.withOpacity(0.55),
                                    disabledForegroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: Text(
                                    _saving ? 'GUARDANDO...' : 'GUARDAR',
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

  Widget _buildPreviewImage({
    required double width,
    required String? imagePath,
  }) {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        width: width,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(width: width);
        },
      );
    }

    if (imagePath != null && imagePath.trim().isNotEmpty) {
      return IncidentImage(
        imagePath: imagePath,
        width: width,
        height: 110,
        fit: BoxFit.cover,
      );
    }

    return _buildImagePlaceholder(width: width);
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