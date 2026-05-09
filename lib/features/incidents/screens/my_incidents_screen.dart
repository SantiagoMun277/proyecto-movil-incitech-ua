import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/incident_card.dart';
import 'package:my_app_incitech_ua/services/incident_service.dart';
import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

class MyIncidentsScreen extends StatefulWidget {
  const MyIncidentsScreen({super.key});

  @override
  State<MyIncidentsScreen> createState() => _MyIncidentsScreenState();
}

class _MyIncidentsScreenState extends State<MyIncidentsScreen> {
  static const Color _backgroundColor = AppColors.backgroundGreen;
  static const Color _cardColor = AppColors.softWhite;
  static const Color _primaryGreen = AppColors.primaryGreenAlt;
  static const Color _textColor = AppColors.textDark;
  static const Color _searchHintColor = AppColors.textMuted;
  static const Color _borderColor = AppColors.borderDark;

  final TextEditingController _searchController = TextEditingController();
  final IncidentService _incidentService = IncidentService();

  MyIncidentFilter _selectedFilter = MyIncidentFilter.todos;
  bool _isFilterExpanded = false;

  Stream<List<IncidentItem>>? _myIncidentsStream;
  String? _currentStreamUid;
  int _refreshVersion = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<IncidentItem>> _getMyIncidentsStream(String uid) {
    if (_myIncidentsStream == null || _currentStreamUid != uid) {
      _currentStreamUid = uid;
      _myIncidentsStream = _incidentService.streamMyIncidents(uid);
    }

    return _myIncidentsStream!;
  }

  void _forceRefreshList() {
    setState(() {
      _myIncidentsStream = null;
      _currentStreamUid = null;
      _refreshVersion++;
    });
  }

  List<IncidentItem> _applyFilters(List<IncidentItem> incidents) {
    final query = _searchController.text.trim().toLowerCase();

    return incidents.where((incident) {
      final matchesSearch =
          incident.title.toLowerCase().contains(query) ||
          incident.location.toLowerCase().contains(query) ||
          incident.type.toLowerCase().contains(query);

      final matchesFilter = switch (_selectedFilter) {
        MyIncidentFilter.todos => true,
        MyIncidentFilter.reportado =>
          incident.status == IncidentStatus.reportado,
        MyIncidentFilter.enProceso =>
          incident.status == IncidentStatus.enProceso,
        MyIncidentFilter.resuelto =>
          incident.status == IncidentStatus.resuelto,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _goToCreateIncident() {
    Navigator.pushNamed(context, AppRoutes.createIncident).then((_) {
      if (!mounted) return;
      _forceRefreshList();
    });
  }

  Future<void> _openIncidentDetail(IncidentItem incident) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.myIncidentDetail,
      arguments: {
        'incident': incident,
        'canEditStatus': false,
      },
    );

    if (!mounted) return;

    _forceRefreshList();
  }

  String _filterLabel(MyIncidentFilter filter) {
    switch (filter) {
      case MyIncidentFilter.todos:
        return 'Todos';
      case MyIncidentFilter.reportado:
        return 'Reportado';
      case MyIncidentFilter.enProceso:
        return 'En Proceso';
      case MyIncidentFilter.resuelto:
        return 'Resuelto';
    }
  }

  void _selectFilter(MyIncidentFilter filter) {
    setState(() {
      _selectedFilter = filter;
      _isFilterExpanded = false;
    });
  }

  String _cardKeyValue(IncidentItem incident) {
    final imagePath = incident.imagePath ?? '';
    final updateDate = incident.rawData['fechaActualizacion']?.toString() ??
        incident.rawData['updatedAt']?.toString() ??
        '';

    return '${incident.id}_${incident.title}_${incident.location}_${incident.type}_${incident.status.label}_${imagePath}_$updateDate';
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: _backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateIncident,
        backgroundColor: _primaryGreen,
        elevation: 2,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 34,
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final double unifiedFontSize = w * 0.040;

            if (uid == null) {
              return Center(
                child: Text(
                  'Debes iniciar sesión para ver tus incidentes.',
                  style: TextStyle(
                    fontSize: unifiedFontSize,
                    fontFamily: AppTextStyles.fontFamily,
                    color: _textColor,
                  ),
                ),
              );
            }

            return Column(
              children: [
                SizedBox(height: h * 0.012),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_incitech.png',
                        width: w * 0.78,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mis Incidentes',
                        style: TextStyle(
                          fontSize: unifiedFontSize * 0.95,
                          fontFamily: AppTextStyles.fontFamily,
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.012),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                  child: _buildSearchBox(unifiedFontSize),
                ),
                SizedBox(height: h * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                  child: _buildFilterCard(unifiedFontSize),
                ),
                SizedBox(height: h * 0.015),
                Expanded(
                  child: StreamBuilder<List<IncidentItem>>(
                    key: ValueKey('my-incidents-stream-$uid-$_refreshVersion'),
                    stream: _getMyIncidentsStream(uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error al cargar tus incidentes.',
                            style: TextStyle(
                              fontSize: unifiedFontSize,
                              fontFamily: AppTextStyles.fontFamily,
                              color: _textColor,
                            ),
                          ),
                        );
                      }

                      final allIncidents = snapshot.data ?? [];
                      final incidents = _applyFilters(allIncidents);

                      if (allIncidents.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.report_problem_outlined,
                                size: unifiedFontSize * 3,
                                color: _textColor.withOpacity(0.5),
                              ),
                              SizedBox(height: h * 0.02),
                              Text(
                                'Aún no has creado ningún incidente.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: unifiedFontSize,
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: _textColor,
                                ),
                              ),
                              SizedBox(height: h * 0.02),
                              ElevatedButton(
                                onPressed: _goToCreateIncident,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryGreen,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.1,
                                    vertical: h * 0.015,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Crear mi primer incidente',
                                  style: TextStyle(
                                    fontSize: unifiedFontSize * 0.9,
                                    fontFamily: AppTextStyles.fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (incidents.isEmpty) {
                        return Center(
                          child: Text(
                            'No hay incidentes que coincidan con los filtros aplicados.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: unifiedFontSize,
                              fontFamily: AppTextStyles.fontFamily,
                              color: _textColor,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          w * 0.035,
                          0,
                          w * 0.035,
                          h * 0.02,
                        ),
                        itemCount: incidents.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: h * 0.018),
                        itemBuilder: (context, index) {
                          final incident = incidents[index];

                          return IncidentCard(
                            key: ValueKey(_cardKeyValue(incident)),
                            incident: incident,
                            onTap: () => _openIncidentDetail(incident),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBox(double unifiedFontSize) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: TextStyle(
          fontSize: unifiedFontSize,
          fontFamily: AppTextStyles.fontFamily,
          color: _textColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black54,
          ),
          hintText: 'Buscar incidente',
          hintStyle: TextStyle(
            fontSize: unifiedFontSize,
            color: _searchHintColor,
            fontFamily: AppTextStyles.fontFamily,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterCard(double unifiedFontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtrar por estado',
            style: TextStyle(
              fontSize: unifiedFontSize * 1.05,
              fontFamily: AppTextStyles.fontFamily,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _isFilterExpanded = !_isFilterExpanded;
              });
            },
            child: Container(
              height: 33,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _filterLabel(_selectedFilter),
                      style: TextStyle(
                        fontSize: unifiedFontSize,
                        fontFamily: AppTextStyles.fontFamily,
                        color: _textColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.panelMuted,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isFilterExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isFilterExpanded) ...[
            const SizedBox(height: 10),
            _buildFilterOption(
              label: 'Todos',
              backgroundColor: AppColors.chipGreen,
              onTap: () => _selectFilter(MyIncidentFilter.todos),
            ),
            const SizedBox(height: 9),
            _buildFilterOption(
              label: 'Reportado',
              backgroundColor: AppColors.chipRed,
              onTap: () => _selectFilter(MyIncidentFilter.reportado),
            ),
            const SizedBox(height: 9),
            _buildFilterOption(
              label: 'En Proceso',
              backgroundColor: AppColors.chipYellow,
              onTap: () => _selectFilter(MyIncidentFilter.enProceso),
            ),
            const SizedBox(height: 9),
            _buildFilterOption(
              label: 'Resuelto',
              backgroundColor: AppColors.chipGreen,
              onTap: () => _selectFilter(MyIncidentFilter.resuelto),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterOption({
    required String label,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _borderColor,
            width: 0.8,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

enum MyIncidentFilter {
  todos,
  reportado,
  enProceso,
  resuelto,
}


