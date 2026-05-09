import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
import 'package:my_app_incitech_ua/features/statistics/screens/statistics_expandable_dropdown.dart';
import 'package:my_app_incitech_ua/services/incident_service.dart';
import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  static const Color _backgroundColor = AppColors.backgroundGreen;
  static const Color _cardColor = AppColors.softWhite;
  static const Color _primaryGreen = AppColors.primaryGreenAlt;
  static const Color _shadowGreen = AppColors.shadowGreen;
  static const Color _textColor = AppColors.textDark;
  static const Color _borderColor = AppColors.borderStrong;

  final IncidentService _incidentService = IncidentService();

  final List<String> _graphicOptions = const [
    'Resumen general',
    'Numero total de incidentes',
    'Numero de incidentes por estado',
    'Numero por tipo',
    'Incidentes por sede',
  ];

  final List<String> _typeOptions = const [
    'Infraestructura',
    'Electricidad',
    'Hidráulico / agua',
    'Baños / saneamiento',
    'Seguridad',
    'Aseo y limpieza',
    'Mobiliario',
    'Tecnología / equipos',
    'Conectividad / red',
    'Zonas verdes / exteriores',
    'Señalización / accesibilidad',
    'Riesgo biológico o ambiental',
    'Emergencia',
    'Convivencia / comportamiento',
    'Otros',
  ];

  final List<String> _siteOptions = const [
    'Sede Porvenir',
    'Sede Juan XXII',
    'Sede social',
    'Sede santo domingo',
    'Sede macagual',
  ];

  String _selectedGraphic = 'Resumen general';
  bool _isGraphicExpanded = false;

  int _touchedPieIndex = -1;

  void _toggleGraphicDropdown() {
    setState(() {
      _isGraphicExpanded = !_isGraphicExpanded;
    });
  }

  void _selectGraphic(String value) {
    setState(() {
      _selectedGraphic = value;
      _isGraphicExpanded = false;
      _touchedPieIndex = -1;
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Reportado':
        return AppColors.chipRed;
      case 'En Proceso':
        return const Color(0xFFF2C45E);
      case 'Resuelto':
        return const Color(0xFF7BE48E);
      default:
        return Colors.grey;
    }
  }

  Color _barColor(int index) {
    final colors = <Color>[
      const Color(0xFF0B7F2A),
      const Color(0xFF108E34),
      const Color(0xFF179D3F),
      const Color(0xFF1E7B35),
      AppColors.shadowGreen,
      const Color(0xFF66BB6A),
      const Color(0xFF81C784),
    ];

    return colors[index % colors.length];
  }

  String _statusLabel(IncidentItem incident) {
    switch (incident.status) {
      case IncidentStatus.reportado:
        return 'Reportado';
      case IncidentStatus.enProceso:
        return 'En Proceso';
      case IncidentStatus.resuelto:
        return 'Resuelto';
    }
  }

  String _statusPluralLabel(String status) {
    switch (status) {
      case 'Reportado':
        return 'Reportados';
      case 'En Proceso':
        return 'En proceso';
      case 'Resuelto':
        return 'Resueltos';
      default:
        return status;
    }
  }

  String _readTextFromData(
    Map<String, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = data[key];

      if (value == null) continue;

      final text = value.toString().trim();

      if (text.isNotEmpty && text != 'null') {
        return text;
      }
    }

    return fallback;
  }

  String _normalizeIncidentType(IncidentItem incident) {
    final rawType = incident.type.trim().isNotEmpty
        ? incident.type.trim()
        : _readTextFromData(
            incident.rawData,
            ['tipoIncidente', 'tipo', 'type', 'categoria'],
            fallback: 'Otros',
          );

    if (_typeOptions.contains(rawType)) {
      return rawType;
    }

    return 'Otros';
  }

  String _normalizeSite(IncidentItem incident) {
    final rawSite = _readTextFromData(
      incident.rawData,
      ['sede', 'campus'],
      fallback: '',
    );

    if (_siteOptions.contains(rawSite)) {
      return rawSite;
    }

    return 'No especificada';
  }

  String _shortLabel(String label) {
    switch (label) {
      case 'Infraestructura':
        return 'Infra.';
      case 'Electricidad':
        return 'Electricidad';
      case 'Hidráulico / agua':
        return 'Agua';
      case 'Baños / saneamiento':
        return 'Baño';
      case 'Seguridad':
        return 'Seguridad';
      case 'Aseo y limpieza':
        return 'Aseo';
      case 'Mobiliario':
        return 'Mobiliario';
      case 'Tecnología / equipos':
        return 'Tecnología';
      case 'Conectividad / red':
        return 'Red';
      case 'Zonas verdes / exteriores':
        return 'Zonas';
      case 'Señalización / accesibilidad':
        return 'Señal.';
      case 'Riesgo biológico o ambiental':
        return 'Riesgo';
      case 'Emergencia':
        return 'Emerg.';
      case 'Convivencia / comportamiento':
        return 'Conviv.';
      case 'Sede Porvenir':
        return 'Porvenir';
      case 'Sede Juan XXII':
        return 'Juan XXII';
      case 'Sede social':
        return 'Social';
      case 'Sede santo domingo':
        return 'Sto. Domingo';
      case 'Sede macagual':
        return 'Macagual';
      default:
        return label.length > 10 ? '${label.substring(0, 10)}.' : label;
    }
  }

  _StatisticsData _buildStatisticsData(List<IncidentItem> incidents) {
    final statusCounts = <String, int>{
      'Reportado': 0,
      'En Proceso': 0,
      'Resuelto': 0,
    };

    final typeCounts = <String, int>{
      for (final type in _typeOptions) type: 0,
    };

    final siteCounts = <String, int>{
      for (final site in _siteOptions) site: 0,
      'No especificada': 0,
    };

    for (final incident in incidents) {
      final status = _statusLabel(incident);
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;

      final type = _normalizeIncidentType(incident);
      typeCounts[type] = (typeCounts[type] ?? 0) + 1;

      final site = _normalizeSite(incident);
      siteCounts[site] = (siteCounts[site] ?? 0) + 1;
    }

    return _StatisticsData(
      total: incidents.length,
      statusCounts: statusCounts,
      typeCounts: typeCounts,
      siteCounts: siteCounts,
    );
  }

  List<MapEntry<String, int>> _positiveEntries(Map<String, int> values) {
    return values.entries.where((entry) => entry.value > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final baseFontSize = w * 0.040;

            return StreamBuilder<List<IncidentItem>>(
              stream: _incidentService.streamIncidents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar las estadísticas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: baseFontSize,
                        fontFamily: AppTextStyles.fontFamily,
                        color: _textColor,
                      ),
                    ),
                  );
                }

                final incidents = snapshot.data ?? [];
                final data = _buildStatisticsData(incidents);

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    w * 0.03,
                    h * 0.015,
                    w * 0.03,
                    h * 0.025,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ESTADÍSTICAS',
                          style: TextStyle(
                            fontSize: baseFontSize * 0.88,
                            color: Colors.black54,
                            fontFamily: AppTextStyles.accentFontFamily,
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.006),
                      Center(
                        child: Image.asset(
                          'assets/images/logo_incitech.png',
                          width: w * 0.74,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: h * 0.014),
                      _buildTopSelector(baseFontSize),
                      SizedBox(height: h * 0.02),
                      ..._buildFilteredWidgets(
                        data: data,
                        fontSize: baseFontSize,
                        h: h,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildFilteredWidgets({
    required _StatisticsData data,
    required double fontSize,
    required double h,
  }) {
    switch (_selectedGraphic) {
      case 'Incidentes por sede':
        return [
          _buildTotalCard(data.total, fontSize),
          SizedBox(height: h * 0.02),
          _buildBarChartCard(
            title: 'Incidentes por sede',
            entries: _positiveEntries(data.siteCounts),
            fontSize: fontSize,
          ),
          SizedBox(height: h * 0.02),
          _buildSummaryListCard(
            title: 'Resumen por sede',
            values: data.siteCounts,
            fontSize: fontSize,
          ),
        ];

      case 'Numero total de incidentes':
        return [
          _buildTotalCard(data.total, fontSize),
        ];

      case 'Numero de incidentes por estado':
        return [
          _buildTotalCard(data.total, fontSize),
          SizedBox(height: h * 0.02),
          _buildStatusSummary(data.statusCounts, fontSize),
          SizedBox(height: h * 0.02),
          _buildPieChartCard(data.statusCounts, data.total, fontSize),
        ];

      case 'Numero por tipo':
        return [
          _buildTotalCard(data.total, fontSize),
          SizedBox(height: h * 0.02),
          _buildBarChartCard(
            title: 'Incidentes por tipo',
            entries: _positiveEntries(data.typeCounts),
            fontSize: fontSize,
          ),
          SizedBox(height: h * 0.02),
          _buildSummaryListCard(
            title: 'Resumen de todos los tipos de incidente',
            values: data.typeCounts,
            fontSize: fontSize,
          ),
        ];

      case 'Resumen general':
      default:
        return [
          _buildStatusSummary(data.statusCounts, fontSize),
          SizedBox(height: h * 0.018),
          _buildPieChartCard(data.statusCounts, data.total, fontSize),
          SizedBox(height: h * 0.025),
          _buildBarChartCard(
            title: 'Incidentes por tipo',
            entries: _positiveEntries(data.typeCounts),
            fontSize: fontSize,
          ),
          SizedBox(height: h * 0.02),
          _buildSummaryListCard(
            title: 'Resumen de todos los tipos de incidente',
            values: data.typeCounts,
            fontSize: fontSize,
          ),
        ];
    }
  }

  Widget _buildTopSelector(double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Gráficas:',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: AppTextStyles.fontFamily,
              color: _textColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatisticsExpandableDropdown(
            value: _selectedGraphic,
            items: _graphicOptions,
            isExpanded: _isGraphicExpanded,
            onTap: _toggleGraphicDropdown,
            onSelected: _selectGraphic,
            fontSize: fontSize * 0.92,
          ),
        ),
      ],
    );
  }

  Widget _buildStyledContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: _shadowGreen,
            offset: Offset(4, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTotalCard(int total, double fontSize) {
    return _buildStyledContainer(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      child: Column(
        children: [
          Text(
            'Total de incidentes registrados',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize * 1.02,
              fontFamily: AppTextStyles.fontFamily,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3E9),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1E7B35),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$total',
              style: TextStyle(
                fontSize: fontSize * 1.60,
                fontWeight: FontWeight.w700,
                fontFamily: AppTextStyles.fontFamily,
                color: _primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSummary(Map<String, int> counts, double fontSize) {
    final items = [
      MapEntry('Reportado', counts['Reportado'] ?? 0),
      MapEntry('En Proceso', counts['En Proceso'] ?? 0),
      MapEntry('Resuelto', counts['Resuelto'] ?? 0),
    ];

    return Row(
      children: items.map((entry) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _StatusBubbleCard(
              count: entry.value,
              label: _statusPluralLabel(entry.key),
              circleColor: _statusColor(entry.key),
              fontSize: fontSize,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPieChartCard(
    Map<String, int> counts,
    int total,
    double fontSize,
  ) {
    final entries = counts.entries.where((entry) => entry.value > 0).toList();

    final touchedEntry =
        (_touchedPieIndex >= 0 && _touchedPieIndex < entries.length)
            ? entries[_touchedPieIndex]
            : null;

    return _buildStyledContainer(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución por estado',
            style: TextStyle(
              fontSize: fontSize * 1.02,
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 14),
          if (total == 0 || entries.isEmpty)
            _buildEmptyChartMessage(
              'No hay incidentes registrados para graficar.',
              fontSize,
            )
          else
            SizedBox(
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedPieIndex = -1;
                              return;
                            }

                            _touchedPieIndex = pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                          });
                        },
                      ),
                      sectionsSpace: 1,
                      centerSpaceRadius: 26,
                      startDegreeOffset: -90,
                      sections: entries.asMap().entries.map((item) {
                        final index = item.key;
                        final entry = item.value;
                        final isTouched = index == _touchedPieIndex;

                        return PieChartSectionData(
                          value: entry.value.toDouble(),
                          color: _statusColor(entry.key),
                          title: '',
                          radius: isTouched ? 96 : 88,
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    width: 58,
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _cardColor.withOpacity(0.90),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$total',
                      style: TextStyle(
                        fontSize: fontSize * 1.35,
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.w800,
                        color: _primaryGreen,
                      ),
                    ),
                  ),
                  if (touchedEntry != null)
                    Positioned(
                      top: 4,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 190),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '${touchedEntry.key}\nCantidad: ${touchedEntry.value}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize * 0.78,
                            fontFamily: AppTextStyles.fontFamily,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard({
    required String title,
    required List<MapEntry<String, int>> entries,
    required double fontSize,
  }) {
    final maxValue = entries.isEmpty
        ? 0
        : entries.map((entry) => entry.value).reduce(math.max);

    final maxY = maxValue <= 0 ? 1.0 : (maxValue + 1).toDouble();

    return _buildStyledContainer(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize * 1.02,
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 14),
          if (entries.isEmpty)
            _buildEmptyChartMessage(
              'No hay datos mayores a cero para mostrar en esta gráfica.',
              fontSize,
            )
          else
            SizedBox(
              height: 245,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  minY: 0,
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final index = group.x.toInt();

                        if (index < 0 || index >= entries.length) {
                          return null;
                        }

                        final entry = entries[index];

                        return BarTooltipItem(
                          '${entry.key}\nCantidad: ${entry.value}',
                          TextStyle(
                            color: Colors.white,
                            fontSize: fontSize * 0.78,
                            fontFamily: AppTextStyles.fontFamily,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.black12,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.black12,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0) {
                            return const SizedBox.shrink();
                          }

                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: fontSize * 0.72,
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.black54,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index < 0 || index >= entries.length) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _shortLabel(entries[index].key),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: fontSize * 0.64,
                                fontFamily: AppTextStyles.fontFamily,
                                color: _textColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: entries.asMap().entries.map((item) {
                    final index = item.key;
                    final entry = item.value;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          width: 26,
                          color: _barColor(index),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyChartMessage(String message, double fontSize) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize * 0.92,
            color: Colors.black45,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryListCard({
    required String title,
    required Map<String, int> values,
    required double fontSize,
  }) {
    final entries = values.entries.toList();

    return _buildStyledContainer(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize * 1.02,
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${entry.key}:',
                      style: TextStyle(
                        fontSize: fontSize * 0.96,
                        fontFamily: AppTextStyles.fontFamily,
                        color: _textColor,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value}',
                    style: TextStyle(
                      fontSize: fontSize * 0.96,
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w700,
                      color: entry.value > 0 ? _textColor : Colors.black45,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatisticsData {
  const _StatisticsData({
    required this.total,
    required this.statusCounts,
    required this.typeCounts,
    required this.siteCounts,
  });

  final int total;
  final Map<String, int> statusCounts;
  final Map<String, int> typeCounts;
  final Map<String, int> siteCounts;
}

class _StatusBubbleCard extends StatelessWidget {
  const _StatusBubbleCard({
    required this.count,
    required this.label,
    required this.circleColor,
    required this.fontSize,
  });

  static const Color _cardColor = AppColors.softWhite;
  static const Color _textColor = AppColors.textDark;
  static const Color _borderColor = AppColors.borderStrong;

  final int count;
  final String label;
  final Color circleColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: fontSize * 0.92,
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize * 0.72,
                fontFamily: AppTextStyles.fontFamily,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



