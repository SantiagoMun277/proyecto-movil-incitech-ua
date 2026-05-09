

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/incident_image.dart';
import 'package:my_app_incitech_ua/services/auth_service.dart';
import 'package:my_app_incitech_ua/services/incident_service.dart';
import 'package:my_app_incitech_ua/services/user_service.dart';

class IncidentDetailScreen extends StatefulWidget {
  const IncidentDetailScreen({
    super.key,
    this.enableAdminStatusEdit = true,
    this.showModifyButton = false,
    this.showDeleteButton = false,
    this.modifyRouteName = '/modify-incident',
  });

  final bool enableAdminStatusEdit;
  final bool showModifyButton;
  final bool showDeleteButton;
  final String modifyRouteName;

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  static const Color _backgroundColor = AppColors.backgroundGreen;
  static const Color _cardColor = AppColors.softWhite;
  static const Color _primaryGreen = AppColors.primaryGreen;
  static const Color _textColor = AppColors.textDark;
  static const Color _shadowGreen = AppColors.shadowGreen;
  static const Color _borderColor = AppColors.borderColor;

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final IncidentService _incidentService = IncidentService();

  bool _isStatusExpanded = false;
  bool _statusInitialized = false;
  bool _savingStatus = false;
  bool _loadingRole = true;
  bool _hasPendingStatusChange = false;
  bool _deletingIncident = false;

  String _selectedStatus = 'Reportado';
  String _rolActual = 'usuario';
  String? _fechaActualizacionLocal;
  String? _statusIncidentId;

  final List<String> _statusOptions = const [
    'Reportado',
    'En Proceso',
    'Resuelto',
  ];

  final Set<String> _knownKeys = const {
    'titulo',
    'title',
    'nombre',
    'asunto',
    'descripcion',
    'description',
    'detalle',
    'observacion',
    'observaciones',
    'fecha',
    'date',
    'createdAt',
    'fechaCreacion',
    'fechaRegistro',
    'fechaTexto',
    'fechaCreacionIso',
    'ubicacion',
    'location',
    'ubicacionTexto',
    'ubicacionTextual',
    'locationText',
    'sede',
    'campus',
    'lugar',
    'tipoIncidente',
    'tipo',
    'type',
    'categoria',
    'estado',
    'status',
    'id',
    'uidAutor',
    'uidUsuario',
    'usuarioId',
    'userId',
    'uid',
    'imagePath',
    'imagenUrl',
    'imageUrl',
    'fotoUrl',
    'urlImagen',
    'imagen',
    'foto',
    'gsUrl',
    'storageUrl',
    'imagenStoragePath',
    'storagePath',
    'imagenNombre',
    'imageName',
    'fotoNombre',
    'gps',
    'gpsRegistrada',
    'gpsRegistrado',
    'gpsRegistered',
    'gpsLatitud',
    'gpsLatitude',
    'latitud',
    'gpsLongitud',
    'gpsLongitude',
    'longitud',
    'fechaActualizacion',
    'updatedAt',
    'fechaActualizacionIso',
    'updatedAtIso',
    'canEditStatus',
  };

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
          _loadingRole = false;
        });
        return;
      }

      final data = await _userService.obtenerUsuario(usuario.uid);
      final rolRaw = data?['rol'] ?? data?['role'];
      final rol = rolRaw?.toString().trim().toLowerCase() ?? 'usuario';

      if (!mounted) return;
      setState(() {
        _rolActual = rol.contains('admin') ? 'admin' : 'usuario';
        _loadingRole = false;
      });
    } catch (error) {
      debugPrint('ERROR CARGANDO ROL DEL USUARIO: $error');

      if (!mounted) return;
      setState(() {
        _rolActual = 'usuario';
        _loadingRole = false;
      });
    }
  }

  void _syncStatusWithIncident(IncidentItem incident) {
    if (_statusIncidentId != incident.id) {
      _statusIncidentId = incident.id;
      _selectedStatus = incident.status.label;
      _statusInitialized = true;
      _fechaActualizacionLocal = null;
      _hasPendingStatusChange = false;
      return;
    }

    if (!_statusInitialized) {
      _selectedStatus = incident.status.label;
      _statusInitialized = true;
      _hasPendingStatusChange = false;
      return;
    }

    if (_savingStatus || _isStatusExpanded || _hasPendingStatusChange) {
      return;
    }

    if (incident.status.label != _selectedStatus) {
      _selectedStatus = incident.status.label;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Reportado':
        return AppColors.reported;
      case 'En Proceso':
        return AppColors.inProgress;
      case 'Resuelto':
        return AppColors.resolved;
      default:
        return AppColors.surfaceLight;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'En Proceso':
        return Icons.pending_actions_rounded;
      case 'Resuelto':
        return Icons.check_circle_outline_rounded;
      case 'Reportado':
      default:
        return Icons.error_outline_rounded;
    }
  }

  String _statusToFirestoreValue(String status) {
    switch (status) {
      case 'En Proceso':
        return 'en_proceso';
      case 'Resuelto':
        return 'resuelto';
      case 'Reportado':
      default:
        return 'reportado';
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

  ButtonStyle _deleteButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFB00020),
      foregroundColor: AppColors.white,
      disabledBackgroundColor: const Color(0xFFB00020).withValues(alpha: 0.55),
      disabledForegroundColor: AppColors.white,
      elevation: 2,
      minimumSize: const Size(0, 46),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
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

  String? _formatValue(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final text = value.trim();
      return text.isEmpty ? null : text;
    }

    if (value is Timestamp) return _formatDateTime(value.toDate());

    if (value is DateTime) return _formatDateTime(value);

    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;

    return text;
  }

  String _formatDateTime(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} - ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  String _formatLabel(String key) {
    final spaced = key
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .trim();

    if (spaced.isEmpty) return key;

    return '${spaced[0].toUpperCase()}${spaced.substring(1)}:';
  }

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  double? _readDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) return value.toDouble();

    if (value is String) return double.tryParse(value.trim());

    return null;
  }

  bool _readGpsRegistered(Map<String, dynamic> data) {
    final value =
        data['gpsRegistrada'] ?? data['gpsRegistrado'] ?? data['gpsRegistered'];

    return _readBool(value);
  }

  double? _readLatitude(Map<String, dynamic> data) {
    final gps = data['gps'];

    if (gps is GeoPoint) return gps.latitude;

    return _readDouble(
      data['gpsLatitud'] ?? data['gpsLatitude'] ?? data['latitud'],
    );
  }

  double? _readLongitude(Map<String, dynamic> data) {
    final gps = data['gps'];

    if (gps is GeoPoint) return gps.longitude;

    return _readDouble(
      data['gpsLongitud'] ?? data['gpsLongitude'] ?? data['longitud'],
    );
  }

  String? _readUpdateDate(Map<String, dynamic> data) {
    if (_fechaActualizacionLocal != null &&
        _fechaActualizacionLocal!.trim().isNotEmpty) {
      return _fechaActualizacionLocal;
    }

    return _formatValue(
      data['fechaActualizacion'] ??
          data['updatedAt'] ??
          data['fechaActualizacionIso'] ??
          data['updatedAtIso'],
    );
  }

  Future<void> _abrirGoogleMaps({
    required double latitude,
    required double longitude,
  }) async {
    final mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      final opened = await launchUrl(
        mapsUri,
        mode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );

      if (opened) return;

      final fallbackOpened = await launchUrl(
        mapsUri,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_blank',
      );

      if (fallbackOpened) return;

      throw Exception('No se pudo abrir Google Maps.');
    } catch (error) {
      debugPrint('ERROR ABRIENDO GOOGLE MAPS: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir la ubicación: $error')),
      );
    }
  }

  Future<void> _guardarEstado(IncidentItem incident) async {
    if (_savingStatus) return;

    setState(() {
      _savingStatus = true;
    });

    try {
      await _incidentService.updateIncidentStatus(
        incidentId: incident.id,
        estado: _statusToFirestoreValue(_selectedStatus),
      );

      final nowText = _formatDateTime(DateTime.now());

      if (!mounted) return;

      setState(() {
        _fechaActualizacionLocal = nowText;
        _hasPendingStatusChange = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado actualizado a: $_selectedStatus')),
      );
    } catch (error) {
      debugPrint('ERROR ACTUALIZANDO ESTADO DEL INCIDENTE: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo actualizar el estado: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingStatus = false;
        });
      }
    }
  }

  Future<void> _abrirModificarIncidente(IncidentItem incident) async {
    final updated = await Navigator.pushNamed(
      context,
      widget.modifyRouteName,
      arguments: incident,
    );

    if (!mounted) return;

    if (updated == true) {
      setState(() {
        _fechaActualizacionLocal = null;
        _statusInitialized = false;
      });
    }
  }

  Future<void> _eliminarIncidente(IncidentItem incident) async {
    if (_deletingIncident) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Eliminar incidente',
            style: AppTextStyles.extraBold(18, color: _textColor),
          ),
          content: Text(
            '¿Seguro que deseas eliminar este incidente?\n\nEsta acción eliminará el reporte y su imagen de Firebase.',
            style: AppTextStyles.regular(15, color: _textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Color(0xFFB00020)),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _deletingIncident = true;
    });

    try {
      await _incidentService.deleteIncident(
        incidentId: incident.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incidente eliminado correctamente.'),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      debugPrint('ERROR ELIMINANDO INCIDENTE: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo eliminar el incidente: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deletingIncident = false;
        });
      }
    }
  }

  bool _isCurrentUserOwner(IncidentItem incident) {
    final currentUser = _authService.usuarioActual;

    if (currentUser == null) return false;

    final uidActual = currentUser.uid.trim();

    final uidAutor = incident.rawData['uidAutor']?.toString().trim();
    final uidUsuario = incident.rawData['uidUsuario']?.toString().trim();
    final usuarioId = incident.rawData['usuarioId']?.toString().trim();
    final userId = incident.rawData['userId']?.toString().trim();
    final uid = incident.rawData['uid']?.toString().trim();

    return uidActual == uidAutor ||
        uidActual == uidUsuario ||
        uidActual == usuarioId ||
        uidActual == userId ||
        uidActual == uid;
  }

  Widget _buildTopBackButton({
    required double fontSize,
  }) {
    return Row(
      children: [
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _deletingIncident ? null : () => Navigator.pop(context),
            child: Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primaryGreenDark,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Detalle del incidente',
            style: AppTextStyles.extraBold(
              fontSize * 1.12,
              color: _textColor,
            ),
          ),
        ),
      ],
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
            color: AppColors.primaryGreenDark,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.extraBold(
              fontSize,
              color: _textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPill({
    required String status,
    required double fontSize,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.borderDark,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _statusIcon(status),
            size: 16,
            color: _textColor,
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: AppTextStyles.semiBold(
              fontSize * 0.88,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo({
    required IncidentItem incident,
    required double titleFontSize,
    required double bodyFontSize,
  }) {
    final title =
        incident.title.trim().isEmpty ? 'Sin título' : incident.title.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusPill(
            status: _selectedStatus,
            fontSize: bodyFontSize,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.extraBold(
              titleFontSize,
              color: _textColor,
            ).copyWith(height: 1.12),
          ),
        ],
      ),
    );
  }

  Widget _buildImageOnly({
    required IncidentItem incident,
    required double imageHeight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.panelLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _borderColor.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return IncidentImage(
                imagePath: incident.imagePath,
                width: constraints.maxWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required double fontSize,
    IconData icon = Icons.info_outline_rounded,
    Color? iconColor,
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
            color: iconColor ?? AppColors.textSecondary,
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

  Widget _buildDescriptionBox({
    required String description,
    required double fontSize,
  }) {
    if (description.trim().isEmpty) {
      return const SizedBox.shrink();
    }

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
            icon: Icons.notes_rounded,
            title: 'Descripción',
            fontSize: fontSize * 1.02,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: AppTextStyles.regular(
              fontSize,
              color: _textColor,
            ).copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel({
    required IncidentItem incident,
    required String? updateDate,
    required double fontSize,
  }) {
    final rows = <Widget>[];

    if (_hasValue(incident.date)) {
      rows.add(
        _buildDetailRow(
          label: 'Fecha:',
          value: incident.date,
          fontSize: fontSize,
          icon: Icons.calendar_month_rounded,
        ),
      );
    }

    if (_hasValue(updateDate)) {
      rows.add(
        _buildDetailRow(
          label: 'Actualización:',
          value: updateDate!,
          fontSize: fontSize,
          icon: Icons.update_rounded,
        ),
      );
    }

    if (_hasValue(incident.type)) {
      rows.add(
        _buildDetailRow(
          label: 'Tipo:',
          value: incident.type,
          fontSize: fontSize,
          icon: Icons.category_outlined,
        ),
      );
    }

    if (_hasValue(incident.location)) {
      rows.add(
        _buildDetailRow(
          label: 'Ubicación:',
          value: incident.location,
          fontSize: fontSize,
          icon: Icons.location_on_outlined,
        ),
      );
    }

    rows.add(
      _buildDetailRow(
        label: 'Estado:',
        value: _selectedStatus,
        fontSize: fontSize,
        icon: _statusIcon(_selectedStatus),
        iconColor: _textColor,
      ),
    );

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
            icon: Icons.assignment_outlined,
            title: 'Información del reporte',
            fontSize: fontSize * 1.02,
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildGpsBox({
    required double latitude,
    required double longitude,
    required double fontSize,
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
            icon: Icons.location_on_rounded,
            title: 'Ubicación GPS',
            fontSize: fontSize * 1.02,
          ),
          const SizedBox(height: 10),
          Text(
            'Este incidente tiene una ubicación GPS registrada. Puedes abrirla en Google Maps para revisar el punto exacto.',
            style: AppTextStyles.regular(
              fontSize,
              color: _textColor,
            ).copyWith(height: 1.22),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: AppColors.softWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _borderColor.withValues(alpha: 0.30),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.my_location_rounded,
                  size: 19,
                  color: _primaryGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lat: ${latitude.toStringAsFixed(6)}  ·  Lon: ${longitude.toStringAsFixed(6)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.regular(
                      fontSize * 0.90,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                _abrirGoogleMaps(latitude: latitude, longitude: longitude);
              },
              icon: const Icon(Icons.map_outlined),
              label: Text(
                'Abrir en Google Maps',
                style: AppTextStyles.button(fontSize),
              ),
              style: _primaryButtonStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons({
    required IncidentItem incident,
    required double fontSize,
    required bool showModify,
    required bool showDelete,
  }) {
    if (!showModify && !showDelete) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (showModify)
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _deletingIncident
                  ? null
                  : () => _abrirModificarIncidente(incident),
              icon: const Icon(Icons.edit_outlined),
              label: Text(
                'Modificar incidente',
                style: AppTextStyles.button(fontSize),
              ),
              style: _primaryButtonStyle(),
            ),
          ),
        if (showModify && showDelete) const SizedBox(height: 10),
        if (showDelete)
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _deletingIncident
                  ? null
                  : () => _eliminarIncidente(incident),
              icon: _deletingIncident
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.delete_outline_rounded),
              label: Text(
                _deletingIncident ? 'Eliminando...' : 'Eliminar incidente',
                style: AppTextStyles.button(fontSize),
              ),
              style: _deleteButtonStyle(),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildExtraRows({
    required IncidentItem incident,
    required double fontSize,
  }) {
    final rows = <Widget>[];

    for (final entry in incident.rawData.entries) {
      final key = entry.key;

      if (_knownKeys.contains(key)) continue;

      final value = _formatValue(entry.value);

      if (value == null || value.trim().isEmpty) continue;

      rows.add(
        _buildDetailRow(
          label: _formatLabel(key),
          value: value,
          fontSize: fontSize,
          icon: Icons.add_circle_outline_rounded,
        ),
      );
    }

    if (rows.isEmpty) return rows;

    return [
      Container(
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
              icon: Icons.more_horiz_rounded,
              title: 'Datos adicionales',
              fontSize: fontSize * 1.02,
            ),
            const SizedBox(height: 12),
            ...rows,
          ],
        ),
      ),
    ];
  }

  IncidentItem? _readIncidentFromArgs(Object? args) {
    if (args is IncidentItem) return args;

    if (args is Map) {
      final value = args['incident'];

      if (value is IncidentItem) return value;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final initialIncident = _readIncidentFromArgs(args);

    if (initialIncident == null) {
      return const Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(
          child: Text('No se encontró la información del incidente.'),
        ),
      );
    }

    return StreamBuilder<IncidentItem?>(
      stream: _incidentService.streamIncidentById(initialIncident.id),
      initialData: initialIncident,
      builder: (context, snapshot) {
        final incident = snapshot.data ?? initialIncident;

        if (snapshot.hasError) {
          debugPrint('ERROR ESCUCHANDO INCIDENTE: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return const Scaffold(
            backgroundColor: _backgroundColor,
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        _syncStatusWithIncident(incident);

        final bool isAdmin =
            widget.enableAdminStatusEdit && _rolActual == 'admin';

        final bool canModifyOwnIncident =
            widget.showModifyButton && _isCurrentUserOwner(incident);

        final bool canDeleteOwnIncident =
            widget.showDeleteButton && _isCurrentUserOwner(incident);

        final updateDate = _readUpdateDate(incident.rawData);

        final gpsRegistered = _readGpsRegistered(incident.rawData);
        final latitude = _readLatitude(incident.rawData);
        final longitude = _readLongitude(incident.rawData);
        final showGpsButton =
            gpsRegistered && latitude != null && longitude != null;

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

                  final fontSize = (w * 0.038).clamp(13.0, 16.0).toDouble();
                  final titleFontSize =
                      (w * 0.052).clamp(18.0, 22.0).toDouble();
                  final logoWidth = (w * 0.58).clamp(190.0, 270.0).toDouble();
                  final imageHeight =
                      (w * 0.58).clamp(210.0, 275.0).toDouble();

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
                        _buildTopBackButton(fontSize: fontSize),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeaderInfo(
                                  incident: incident,
                                  titleFontSize: titleFontSize,
                                  bodyFontSize: fontSize,
                                ),
                                _buildImageOnly(
                                  incident: incident,
                                  imageHeight: imageHeight,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 14, 14, 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDescriptionBox(
                                        description: incident.description,
                                        fontSize: fontSize,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInfoPanel(
                                        incident: incident,
                                        updateDate: updateDate,
                                        fontSize: fontSize,
                                      ),
                                      if (showGpsButton) ...[
                                        const SizedBox(height: 12),
                                        _buildGpsBox(
                                          latitude: latitude,
                                          longitude: longitude,
                                          fontSize: fontSize,
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      ..._buildExtraRows(
                                        incident: incident,
                                        fontSize: fontSize,
                                      ),
                                      if (_loadingRole) ...[
                                        const SizedBox(height: 14),
                                        const Center(
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (isAdmin) ...[
                                        const SizedBox(height: 14),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(13),
                                          decoration: BoxDecoration(
                                            color: AppColors.panelLight
                                                .withValues(alpha: 0.92),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                              color: _borderColor
                                                  .withValues(alpha: 0.35),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildSectionTitle(
                                                icon: Icons
                                                    .admin_panel_settings_rounded,
                                                title: 'Gestión del estado',
                                                fontSize: fontSize * 1.02,
                                              ),
                                              const SizedBox(height: 12),
                                              _buildAdminStatusDropdown(
                                                fontSize,
                                              ),
                                              const SizedBox(height: 12),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 46,
                                                child: ElevatedButton.icon(
                                                  onPressed: _savingStatus
                                                      ? null
                                                      : () => _guardarEstado(
                                                            incident,
                                                          ),
                                                  icon: _savingStatus
                                                      ? const SizedBox(
                                                          width: 18,
                                                          height: 18,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                        )
                                                      : const Icon(
                                                          Icons.save_outlined,
                                                        ),
                                                  label: Text(
                                                    _savingStatus
                                                        ? 'Guardando...'
                                                        : 'Guardar estado',
                                                    style: AppTextStyles.button(
                                                      fontSize,
                                                    ),
                                                  ),
                                                  style: _primaryButtonStyle(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: h * 0.022),
                                      _buildBottomButtons(
                                        incident: incident,
                                        fontSize: fontSize,
                                        showModify: canModifyOwnIncident,
                                        showDelete: canDeleteOwnIncident,
                                      ),
                                    ],
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
      },
    );
  }

  Widget _buildAdminStatusDropdown(double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _isStatusExpanded = !_isStatusExpanded;
            });
          },
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 44,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _statusColor(_selectedStatus),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderDark,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _statusIcon(_selectedStatus),
                  size: 18,
                  color: _textColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedStatus,
                    style: AppTextStyles.semiBold(
                      fontSize,
                      color: _textColor,
                    ),
                  ),
                ),
                Icon(
                  _isStatusExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
        if (_isStatusExpanded) ...[
          const SizedBox(height: 8),
          ..._statusOptions.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  setState(() {
                    _selectedStatus = item;
                    _isStatusExpanded = false;
                    _hasPendingStatusChange = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 42,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _statusColor(item),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.borderDark,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _statusIcon(item),
                        size: 18,
                        color: _textColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTextStyles.semiBold(
                            fontSize,
                            color: _textColor,
                          ),
                        ),
                      ),
                    ],
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