

// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/features/auth/login_screen.dart';
// import 'package:my_app_incitech_ua/features/auth/register_screen.dart';
// import 'package:my_app_incitech_ua/features/incidents/screens/create_incident_screen.dart';
// import 'package:my_app_incitech_ua/features/incidents/screens/edit_incident_screen.dart';
// import 'package:my_app_incitech_ua/features/incidents/screens/incident_detail_screen.dart';
// import 'package:my_app_incitech_ua/features/incidents/screens/incidents_screen.dart';
// import 'package:my_app_incitech_ua/features/incidents/screens/my_incident_detail_screen.dart';
// import 'package:my_app_incitech_ua/features/incidents/screens/my_incidents_screen.dart';
// import 'package:my_app_incitech_ua/features/profile/screens/profile_screen.dart';
// import 'package:my_app_incitech_ua/features/statistics/screens/statistics_screen.dart';

// import '../../features/welcome/welcome_screen.dart';


// class AppRoutes {
//   static const String welcome = '/';
//   static const String login = '/login';
//   static const String register = '/register';

//   static const String incidentsHome = '/incidents';
//   static const String myIncidents = '/my-incidents';
//   static const String incidentDetail = '/incident-detail';
//   static const String myIncidentDetail = '/my-incident-detail';
//   static const String createIncident = '/create-incident';
//   static const String editIncident = '/edit-incident';

//   static const String statistics = '/statistics';
//   static const String profile = '/profile';

//   static Map<String, WidgetBuilder> get routes => {
//         welcome: (context) => const WelcomeScreen(),
//         login: (context) => const LoginScreen(),
//         register: (context) => const RegisterScreen(),
//         incidentsHome: (context) => const IncidentsScreen(),
//         myIncidents: (context) => const MyIncidentsScreen(),
//         incidentDetail: (context) => const IncidentDetailScreen(),
//         myIncidentDetail: (context) => const MyIncidentDetailScreen(),
//         createIncident: (context) => const CreateIncidentScreen(),
//         editIncident: (context) => const EditIncidentScreen(),
//         statistics: (context) => const StatisticsScreen(),
//         profile: (context) => const ProfileScreen(),
//       };
// }

import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/features/auth/login_screen.dart';
import 'package:my_app_incitech_ua/features/auth/register_screen.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/create_incident_screen.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/edit_incident_screen.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/incident_detail_screen.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/incidents_screen.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/my_incident_detail_screen.dart';
import 'package:my_app_incitech_ua/features/incidents/screens/my_incidents_screen.dart';
import 'package:my_app_incitech_ua/features/profile/screens/profile_screen.dart';
import 'package:my_app_incitech_ua/features/statistics/screens/statistics_screen.dart';
import 'package:my_app_incitech_ua/features/welcome/welcome_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String incidentsHome = '/incidents';
  static const String myIncidents = '/my-incidents';
  static const String incidentDetail = '/incident-detail';
  static const String myIncidentDetail = '/my-incident-detail';
  static const String createIncident = '/create-incident';
  static const String editIncident = '/edit-incident';

  // Alias opcional por si algún botón usa este nombre
  static const String modifyIncident = '/modify-incident';

  static const String statistics = '/statistics';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        welcome: (context) => const WelcomeScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        incidentsHome: (context) => const IncidentsScreen(),
        myIncidents: (context) => const MyIncidentsScreen(),
        incidentDetail: (context) => const IncidentDetailScreen(),
        myIncidentDetail: (context) => const MyIncidentDetailScreen(),
        createIncident: (context) => const CreateIncidentScreen(),
        editIncident: (context) => const EditIncidentScreen(),

        // Alias opcional
        modifyIncident: (context) => const EditIncidentScreen(),

        statistics: (context) => const StatisticsScreen(),
        profile: (context) => const ProfileScreen(),
      };
}
