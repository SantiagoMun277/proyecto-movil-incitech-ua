
import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/incident_list_base_screen.dart';

class MyIncidentsScreen extends StatelessWidget {
  const MyIncidentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const IncidentListBaseScreen(
      title: 'Mis Incidentes',
      subtitle: 'Revisa y gestiona tus reportes.',
      headerIcon: Icons.assignment_ind_outlined,
      bottomNavIndex: 1,
      detailRouteName: AppRoutes.myIncidentDetail,
      onlyCurrentUser: true,
      emptyTitle: 'Aún no has creado incidentes',
      emptyMessage: 'Crea tu primer reporte para hacer seguimiento desde aquí.',
      emptyButtonText: 'Crear mi primer incidente',
    );
  }
}