import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/incident_card.dart';


class MyIncidentsScreen extends StatefulWidget {
  const MyIncidentsScreen({super.key});

  @override
  State<MyIncidentsScreen> createState() => _MyIncidentsScreenState();
}

class _MyIncidentsScreenState extends State<MyIncidentsScreen> {
  static const Color _backgroundColor = Color(0xFFB8DEBE);
  static const Color _cardColor = Color(0xFFF2F2F2);
  static const Color _primaryGreen = Color(0xFF0C7A27);
  static const Color _textColor = Color(0xFF222222);
  static const Color _searchHintColor = Color(0xFF9B9B9B);
  static const Color _borderColor = Color(0xFF3D3D3D);

  final TextEditingController _searchController = TextEditingController();

  MyIncidentFilter _selectedFilter = MyIncidentFilter.todos;
  bool _isFilterExpanded = false;


  final List<IncidentItem> _myIncidents = const [
    IncidentItem(
      id: '1',
      title: 'Falta de libros en la biblioteca',
      description:
          'Se evidencia la falta de varios libros en la biblioteca, especialmente aquellos necesarios para el estudio y consulta de los estudiantes, lo que dificulta el acceso a material académico.',
      date: '24/03/2026 14:49',
      location: 'Sede Porvenir',
      type: 'Otros',
      status: IncidentStatus.reportado,
      imagePath: 'assets/images/incidents/libros_biblioteca.jpg',
    ),
    IncidentItem(
      id: '2',
      title: 'Cafeterías colapsadas',
      description:
          'Se presenta saturación en las cafeterías durante horas pico, lo que genera largas filas y retraso en la atención.',
      date: '23/03/2026 10:20',
      location: 'Sede Porvenir',
      type: 'Infraestructura',
      status: IncidentStatus.reportado,
      imagePath: 'assets/images/incidents/cafeterias.jpg',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IncidentItem> get _filteredIncidents {
    final query = _searchController.text.trim().toLowerCase();

    return _myIncidents.where((incident) {
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
    Navigator.pushNamed(context, AppRoutes.createIncident);
  }

  void _openIncidentDetail(IncidentItem incident) {
    Navigator.pushNamed(
      context,
      AppRoutes.myIncidentDetail,
      arguments: incident,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateIncident,
        backgroundColor: _primaryGreen,
        elevation: 2,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 34),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final double unifiedFontSize = w * 0.040;

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
                          fontFamily: 'Times New Roman',
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
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      w * 0.035,
                      0,
                      w * 0.035,
                      h * 0.02,
                    ),
                    itemCount: _filteredIncidents.length,
                    separatorBuilder: (_, __) => SizedBox(height: h * 0.018),
                    itemBuilder: (context, index) {
                      final incident = _filteredIncidents[index];
                     return IncidentCard(
  incident: incident,
  onTap: () => _openIncidentDetail(incident),
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
          fontFamily: 'Times New Roman',
          color: _textColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.black54),
          hintText: 'Buscar incidente',
          hintStyle: TextStyle(
            fontSize: unifiedFontSize,
            color: _searchHintColor,
            fontFamily: 'Times New Roman',
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
              fontFamily: 'Times New Roman',
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
                border: Border.all(color: _borderColor, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _filterLabel(_selectedFilter),
                      style: TextStyle(
                        fontSize: unifiedFontSize,
                        fontFamily: 'Times New Roman',
                        color: _textColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
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
              label: 'Reportado',
              backgroundColor: const Color(0xFFF47E7E),
              onTap: () => _selectFilter(MyIncidentFilter.reportado),
            ),
            const SizedBox(height: 9),
            _buildFilterOption(
              label: 'En Proceso',
              backgroundColor: const Color(0xFFE5C469),
              onTap: () => _selectFilter(MyIncidentFilter.enProceso),
            ),
            const SizedBox(height: 9),
            _buildFilterOption(
              label: 'Resuelto',
              backgroundColor: const Color(0xFF84E09E),
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
          border: Border.all(color: _borderColor, width: 0.8),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Times New Roman',
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