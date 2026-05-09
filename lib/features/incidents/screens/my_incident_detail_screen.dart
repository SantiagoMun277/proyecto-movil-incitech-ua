

import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/incident_detail_screen.dart';

class MyIncidentDetailScreen extends StatelessWidget {
  const MyIncidentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const IncidentDetailScreen(
      enableAdminStatusEdit: false,
      showModifyButton: true,
      showDeleteButton: true,
      modifyRouteName: AppRoutes.editIncident,
    );
  }
}