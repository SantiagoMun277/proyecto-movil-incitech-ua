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
  });

  final String id;
  final String title;
  final String description;
  final String date;
  final String location;
  final String type;
  final IncidentStatus status;
  final String? imagePath;
}

enum IncidentStatus {
  reportado,
  enProceso,
  resuelto,
}

extension IncidentStatusX on IncidentStatus {
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
}