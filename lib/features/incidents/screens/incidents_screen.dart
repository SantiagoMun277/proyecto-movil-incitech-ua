// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
// import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

// import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
// import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
// import 'package:my_app_incitech_ua/features/incidents/widgets/incident_card.dart';
// import 'package:my_app_incitech_ua/services/incident_service.dart';
// import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

// class IncidentsScreen extends StatefulWidget {
//   const IncidentsScreen({super.key});

//   @override
//   State<IncidentsScreen> createState() => _IncidentsScreenState();
// }

// class _IncidentsScreenState extends State<IncidentsScreen> {
//   static const Color _backgroundColor = AppColors.backgroundGreen;
//   static const Color _cardColor = AppColors.softWhite;
//   static const Color _primaryGreen = AppColors.primaryGreenAlt;
//   static const Color _textColor = AppColors.textDark;
//   static const Color _searchHintColor = AppColors.textMuted;
//   static const Color _borderColor = AppColors.borderDark;

//   final TextEditingController _searchController = TextEditingController();
//   final IncidentService _incidentService = IncidentService();

//   IncidentFilter _selectedFilter = IncidentFilter.todos;
//   bool _isFilterExpanded = false;

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   List<IncidentItem> _applyFilters(List<IncidentItem> incidents) {
//     final query = _searchController.text.trim().toLowerCase();

//     return incidents.where((incident) {
//       final matchesSearch =
//           incident.title.toLowerCase().contains(query) ||
//           incident.location.toLowerCase().contains(query) ||
//           incident.type.toLowerCase().contains(query);

//       final matchesFilter = switch (_selectedFilter) {
//         IncidentFilter.todos => true,
//         IncidentFilter.reportado => incident.status == IncidentStatus.reportado,
//         IncidentFilter.enProceso => incident.status == IncidentStatus.enProceso,
//         IncidentFilter.resuelto => incident.status == IncidentStatus.resuelto,
//       };

//       return matchesSearch && matchesFilter;
//     }).toList();
//   }

//   void _goToCreateIncident() {
//     Navigator.pushNamed(context, AppRoutes.createIncident);
//   }

//   void _openIncidentDetail(IncidentItem incident) {
//     Navigator.pushNamed(
//       context,
//       AppRoutes.incidentDetail,
//       arguments: {
//         'incident': incident,
//         'canEditStatus': false,
//       },
//     );
//   }

//   String _filterLabel(IncidentFilter filter) {
//     switch (filter) {
//       case IncidentFilter.todos:
//         return 'Todos';
//       case IncidentFilter.reportado:
//         return 'Reportado';
//       case IncidentFilter.enProceso:
//         return 'En Proceso';
//       case IncidentFilter.resuelto:
//         return 'Resuelto';
//     }
//   }

//   void _selectFilter(IncidentFilter filter) {
//     setState(() {
//       _selectedFilter = filter;
//       _isFilterExpanded = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       floatingActionButton: FloatingActionButton(
//         onPressed: _goToCreateIncident,
//         backgroundColor: _primaryGreen,
//         elevation: 2,
//         shape: const CircleBorder(),
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 34,
//         ),
//       ),
//       bottomNavigationBar: const AppBottomNav(currentIndex: 0),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final w = constraints.maxWidth;
//             final h = constraints.maxHeight;
//             final double unifiedFontSize = w * 0.040;

//             return Column(
//               children: [
//                 SizedBox(height: h * 0.012),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: w * 0.03),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/logo_incitech.png',
//                         width: w * 0.78,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: h * 0.012),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: w * 0.035),
//                   child: _buildSearchBox(unifiedFontSize),
//                 ),
//                 SizedBox(height: h * 0.015),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: w * 0.035),
//                   child: _buildFilterCard(unifiedFontSize),
//                 ),
//                 SizedBox(height: h * 0.015),
//                 Expanded(
//                   child: StreamBuilder<List<IncidentItem>>(
//                     stream: _incidentService.streamIncidents(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }

//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text(
//                             'Error al cargar los incidentes.',
//                             style: TextStyle(
//                               fontSize: unifiedFontSize,
//                               fontFamily: AppTextStyles.fontFamily,
//                               color: _textColor,
//                             ),
//                           ),
//                         );
//                       }

//                       final incidents = _applyFilters(snapshot.data ?? []);

//                       if (incidents.isEmpty) {
//                         return Center(
//                           child: Text(
//                             'No hay incidentes registrados.',
//                             style: TextStyle(
//                               fontSize: unifiedFontSize,
//                               fontFamily: AppTextStyles.fontFamily,
//                               color: _textColor,
//                             ),
//                           ),
//                         );
//                       }

//                       return ListView.separated(
//                         padding: EdgeInsets.fromLTRB(
//                           w * 0.035,
//                           0,
//                           w * 0.035,
//                           h * 0.02,
//                         ),
//                         itemCount: incidents.length,
//                         separatorBuilder: (_, __) => SizedBox(height: h * 0.018),
//                         itemBuilder: (context, index) {
//                           final incident = incidents[index];

//                           return IncidentCard(
//                             key: ValueKey(incident.id),
//                             incident: incident,
//                             onTap: () => _openIncidentDetail(incident),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBox(double unifiedFontSize) {
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         controller: _searchController,
//         onChanged: (_) => setState(() {}),
//         style: TextStyle(
//           fontSize: unifiedFontSize,
//           fontFamily: AppTextStyles.fontFamily,
//           color: _textColor,
//         ),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           prefixIcon: const Icon(
//             Icons.search,
//             color: Colors.black54,
//           ),
//           hintText: 'Buscar incidente',
//           hintStyle: TextStyle(
//             fontSize: unifiedFontSize,
//             color: _searchHintColor,
//             fontFamily: AppTextStyles.fontFamily,
//           ),
//           contentPadding: const EdgeInsets.symmetric(vertical: 12),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterCard(double unifiedFontSize) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Filtrar por estado',
//             style: TextStyle(
//               fontSize: unifiedFontSize * 1.05,
//               fontFamily: AppTextStyles.fontFamily,
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 _isFilterExpanded = !_isFilterExpanded;
//               });
//             },
//             child: Container(
//               height: 33,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: _cardColor,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: _borderColor,
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       _filterLabel(_selectedFilter),
//                       style: TextStyle(
//                         fontSize: unifiedFontSize,
//                         fontFamily: AppTextStyles.fontFamily,
//                         color: _textColor,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 28,
//                     height: 18,
//                     decoration: BoxDecoration(
//                       color: AppColors.panelMuted,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           offset: Offset(1, 2),
//                           blurRadius: 3,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       _isFilterExpanded
//                           ? Icons.arrow_drop_up
//                           : Icons.arrow_drop_down,
//                       color: Colors.black,
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (_isFilterExpanded) ...[
//             const SizedBox(height: 10),
//             _buildFilterOption(              label: 'Todos',
//               backgroundColor: AppColors.chipGreen,
//               onTap: () => _selectFilter(IncidentFilter.todos),
//             ),
//             const SizedBox(height: 9),
//             _buildFilterOption(              label: 'Reportado',
//               backgroundColor: AppColors.chipRed,
//               onTap: () => _selectFilter(IncidentFilter.reportado),
//             ),
//             const SizedBox(height: 9),
//             _buildFilterOption(
//               label: 'En Proceso',
//               backgroundColor: AppColors.chipYellow,
//               onTap: () => _selectFilter(IncidentFilter.enProceso),
//             ),
//             const SizedBox(height: 9),
//             _buildFilterOption(
//               label: 'Resuelto',
//               backgroundColor: AppColors.chipGreen,
//               onTap: () => _selectFilter(IncidentFilter.resuelto),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterOption({
//     required String label,
//     required Color backgroundColor,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 30,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: _borderColor,
//             width: 0.8,
//           ),
//         ),
//         alignment: Alignment.centerLeft,
//         child: Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontFamily: AppTextStyles.fontFamily,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }

// enum IncidentFilter {
//   todos,
//   reportado,
//   enProceso,
//   resuelto,
// }

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
