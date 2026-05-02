import 'package:cloud_firestore/cloud_firestore.dart';

enum IncidentStatus {
  reportado,
  enProceso,
  resuelto,
}

extension IncidentStatusExtension on IncidentStatus {
  String get label {
    switch (this) {
      case IncidentStatus.reportado:
        return 'Reportado';
      case IncidentStatus.enProceso:
        return 'En Proceso';
      case IncidentStatus.resuelto:
        return 'Resuelto';
    }
  }

  String get value {
    switch (this) {
      case IncidentStatus.reportado:
        return 'reportado';
      case IncidentStatus.enProceso:
        return 'en_proceso';
      case IncidentStatus.resuelto:
        return 'resuelto';
    }
  }
}

class IncidentItem {
  const IncidentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.type,
    required this.status,
    required this.imagePath,
    this.createdAt,
    this.rawData = const {},
  });

  final String id;
  final String title;
  final String description;
  final String date;
  final String location;
  final String type;
  final IncidentStatus status;
  final String? imagePath;
  final DateTime? createdAt;
  final Map<String, dynamic> rawData;

  factory IncidentItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    final createdAt = _readDateTime(data, [
      'createdAt',
      'fechaCreacion',
      'fechaRegistro',
      'date',
      'fecha',
    ]);

    return IncidentItem(
      id: doc.id,
      title: _readText(
        data,
        ['title', 'titulo', 'nombre', 'asunto'],
        fallback: 'Sin título',
      ),
      description: _readText(
        data,
        [
          'description',
          'descripcion',
          'detalle',
          'observacion',
          'observaciones',
        ],
      ),
      date: _readDateText(
        data,
        [
          'fechaTexto',
          'fecha',
          'date',
          'createdAt',
          'fechaCreacion',
          'fechaRegistro',
        ],
      ),
      location: _readText(
        data,
        [
          'location',
          'ubicacion',
          'locationText',
          'ubicacionTexto',
          'ubicacionTextual',
          'sede',
          'campus',
          'lugar',
        ],
      ),
      type: _readText(
        data,
        ['type', 'tipo', 'tipoIncidente', 'categoria'],
      ),
      status: parseStatus(
        _readText(
          data,
          ['status', 'estado'],
          fallback: 'reportado',
        ),
      ),
      imagePath: _readIncidentImagePath(data),
      createdAt: createdAt,
      rawData: data,
    );
  }

  static String? _readIncidentImagePath(Map<String, dynamic> data) {
    final directUrl = _readNullableText(
      data,
      [
        'imageUrl',
        'imagenUrl',
        'urlImagen',
        'fotoUrl',
        'imagePath',
        'imagen',
        'foto',
      ],
    );

    if (directUrl != null && directUrl.trim().isNotEmpty) {
      return directUrl.trim();
    }

    final storagePath = _readNullableText(
      data,
      [
        'imagenStoragePath',
        'storagePath',
        'gsUrl',
        'storageUrl',
      ],
    );

    if (storagePath != null && storagePath.trim().isNotEmpty) {
      return storagePath.trim();
    }

    final imageName = _readNullableText(
      data,
      [
        'imagenNombre',
        'imageName',
        'fotoNombre',
      ],
    );

    final uidAutor = _readNullableText(
      data,
      [
        'uidAutor',
        'usuarioId',
        'userId',
        'uid',
      ],
    );

    if (imageName != null &&
        imageName.trim().isNotEmpty &&
        uidAutor != null &&
        uidAutor.trim().isNotEmpty) {
      return 'incidentes/${uidAutor.trim()}/${imageName.trim()}';
    }

    return null;
  }

  static IncidentStatus parseStatus(String value) {
    final clean = value.trim().toLowerCase();

    if (clean == 'en proceso' ||
        clean == 'en_proceso' ||
        clean == 'proceso' ||
        clean == 'pendiente') {
      return IncidentStatus.enProceso;
    }

    if (clean == 'resuelto' ||
        clean == 'solucionado' ||
        clean == 'cerrado') {
      return IncidentStatus.resuelto;
    }

    return IncidentStatus.reportado;
  }

  static String _readText(
    Map<String, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    final value = _readNullableText(data, keys);
    return value ?? fallback;
  }

  static String? _readNullableText(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = data[key];

      if (value == null) continue;

      final text = _formatValue(value);

      if (text != null && text.trim().isNotEmpty) {
        return text.trim();
      }
    }

    return null;
  }

  static DateTime? _readDateTime(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = data[key];

      if (value == null) continue;

      if (value is Timestamp) {
        return value.toDate();
      }

      if (value is DateTime) {
        return value;
      }

      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
    }

    return null;
  }

  static String _readDateText(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = data[key];

      if (value == null) continue;

      if (value is Timestamp) {
        return _formatDateTime(value.toDate());
      }

      if (value is DateTime) {
        return _formatDateTime(value);
      }

      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }

    return '';
  }

  static String _formatDateTime(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} - ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  static String? _formatValue(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final text = value.trim();
      return text.isEmpty ? null : text;
    }

    if (value is Timestamp) {
      return _formatDateTime(value.toDate());
    }

    if (value is DateTime) {
      return _formatDateTime(value);
    }

    if (value is GeoPoint) {
      return '${value.latitude}, ${value.longitude}';
    }

    if (value is num || value is bool) {
      return value.toString();
    }

    if (value is List) {
      if (value.isEmpty) return null;

      return value
          .map((item) => _formatValue(item))
          .whereType<String>()
          .where((item) => item.trim().isNotEmpty)
          .join(', ');
    }

    if (value is Map) {
      if (value.isEmpty) return null;

      return value.entries
          .map((entry) {
            final formatted = _formatValue(entry.value);

            if (formatted == null || formatted.trim().isEmpty) {
              return null;
            }

            return '${entry.key}: $formatted';
          })
          .whereType<String>()
          .join(', ');
    }

    final text = value.toString().trim();

    if (text.isEmpty || text == 'null') {
      return null;
    }

    return text;
  }
}
