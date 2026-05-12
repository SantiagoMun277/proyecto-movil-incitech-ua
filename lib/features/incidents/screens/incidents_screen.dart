

import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/incident_list_base_screen.dart';

class IncidentsScreen extends StatelessWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const IncidentListBaseScreen(
      title: 'Incidentes',
      subtitle: 'Consulta los reportes registrados.',
      headerIcon: Icons.dashboard_outlined,
      bottomNavIndex: 0,
      detailRouteName: AppRoutes.incidentDetail,
      onlyCurrentUser: false,
      emptyTitle: 'No hay incidentes registrados',
      emptyMessage: 'Cuando se cree un reporte aparecerá en esta lista.',
      emptyButtonText: 'Crear incidente',
    );
  }
}
