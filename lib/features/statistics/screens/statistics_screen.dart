

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
  static const Color _panelColor = AppColors.panelLight;
  static const Color _primaryGreen = AppColors.primaryGreen;
  static const Color _primaryGreenDark = AppColors.primaryGreenDark;
  static const Color _shadowGreen = AppColors.shadowGreen;
  static const Color _textColor = AppColors.textDark;
  static const Color _borderColor = AppColors.borderColor;

  final IncidentService _incidentService = IncidentService();

  final List<String> _graphicOptions = const [
    'Resumen general',
    'Número total de incidentes',
    'Número de incidentes por estado',
    'Número por tipo',
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
      const Color(0xFF2F9E44),
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
        return 'Electric.';
      case 'Hidráulico / agua':
        return 'Agua';
      case 'Baños / saneamiento':
        return 'Baño';
      case 'Seguridad':
        return 'Seg.';
      case 'Aseo y limpieza':
        return 'Aseo';
      case 'Mobiliario':
        return 'Mob.';
      case 'Tecnología / equipos':
        return 'Tec.';
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
            final baseFontSize = (w * 0.040).clamp(13.0, 16.0).toDouble();
            final logoWidth = (w * 0.58).clamp(190.0, 270.0).toDouble();

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
                  return _buildStateMessage(
                    icon: Icons.error_outline_rounded,
                    title: 'Error al cargar las estadísticas',
                    message:
                        'Intenta nuevamente más tarde o revisa tu conexión.',
                    fontSize: baseFontSize,
                  );
                }

                final incidents = snapshot.data ?? [];
                final data = _buildStatisticsData(incidents);

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    w * 0.04,
                    h * 0.015,
                    w * 0.04,
                    h * 0.025,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_incitech.png',
                        width: logoWidth,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: h * 0.014),
                      _buildHeaderCard(baseFontSize),
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

  Widget _buildHeaderCard(double fontSize) {
    return _buildStyledContainer(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          _buildIconBox(Icons.bar_chart_rounded),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estadísticas',
                  style: AppTextStyles.extraBold(
                    fontSize * 1.22,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Analiza los incidentes registrados.',
                  style: AppTextStyles.regular(
                    fontSize * 0.90,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            subtitle: 'Comparación de reportes por sede.',
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

      case 'Número total de incidentes':
        return [
          _buildTotalCard(data.total, fontSize),
        ];

      case 'Número de incidentes por estado':
        return [
          _buildTotalCard(data.total, fontSize),
          SizedBox(height: h * 0.02),
          _buildStatusSummary(data.statusCounts, fontSize),
          SizedBox(height: h * 0.02),
          _buildPieChartCard(data.statusCounts, data.total, fontSize),
        ];

      case 'Número por tipo':
        return [
          _buildTotalCard(data.total, fontSize),
          SizedBox(height: h * 0.02),
          _buildBarChartCard(
            title: 'Incidentes por tipo',
            subtitle: 'Comparación de categorías reportadas.',
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
            subtitle: 'Comparación de categorías reportadas.',
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
    return _buildStyledContainer(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBox(Icons.tune_rounded, size: 30, iconSize: 17),
              const SizedBox(width: 9),
              Text(
                'Gráficas',
                style: AppTextStyles.extraBold(
                  fontSize * 1.02,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          StatisticsExpandableDropdown(
            value: _selectedGraphic,
            items: _graphicOptions,
            isExpanded: _isGraphicExpanded,
            onTap: _toggleGraphicDropdown,
            onSelected: _selectGraphic,
            fontSize: fontSize * 0.92,
          ),
        ],
      ),
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
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _shadowGreen.withValues(alpha: 0.18),
            offset: const Offset(0, 7),
            blurRadius: 15,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildIconBox(
    IconData icon, {
    double size = 38,
    double iconSize = 21,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _primaryGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      child: Icon(
        icon,
        color: _primaryGreenDark,
        size: iconSize,
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    String? subtitle,
    required double fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIconBox(icon, size: 32, iconSize: 18),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.extraBold(
                  fontSize * 1.02,
                  color: _textColor,
                ),
              ),
              if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.regular(
                    fontSize * 0.84,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard(int total, double fontSize) {
    return _buildStyledContainer(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      child: Column(
        children: [
          _buildSectionTitle(
            icon: Icons.numbers_rounded,
            title: 'Total de incidentes registrados',
            subtitle: 'Cantidad general de reportes en el sistema.',
            fontSize: fontSize,
          ),
          const SizedBox(height: 16),
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: _primaryGreen.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(
                color: _primaryGreenDark,
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$total',
              style: AppTextStyles.extraBold(
                fontSize * 1.75,
                color: _primaryGreenDark,
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
          _buildSectionTitle(
            icon: Icons.pie_chart_outline_rounded,
            title: 'Distribución por estado',
            subtitle: 'Toca una sección para ver la cantidad.',
            fontSize: fontSize,
          ),
          const SizedBox(height: 14),
          if (total == 0 || entries.isEmpty)
            _buildEmptyChartMessage(
              'No hay incidentes registrados para graficar.',
              fontSize,
            )
          else ...[
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
                      sectionsSpace: 2,
                      centerSpaceRadius: 38,
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
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _cardColor.withValues(alpha: 0.94),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _borderColor.withValues(alpha: 0.45),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '$total',
                      style: AppTextStyles.extraBold(
                        fontSize * 1.45,
                        color: _primaryGreenDark,
                      ),
                    ),
                  ),
                  if (touchedEntry != null)
                    Positioned(
                      top: 4,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              offset: const Offset(0, 3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          '${touchedEntry.key}\nCantidad: ${touchedEntry.value}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.extraBold(
                            fontSize * 0.78,
                            color: AppColors.white,
                          ).copyWith(height: 1.15),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildPieLegend(entries, fontSize),
          ],
        ],
      ),
    );
  }

  Widget _buildPieLegend(List<MapEntry<String, int>> entries, double fontSize) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: _statusColor(entry.key),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${_statusPluralLabel(entry.key)} (${entry.value})',
              style: AppTextStyles.regular(
                fontSize * 0.78,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBarChartCard({
    required String title,
    required String subtitle,
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
          _buildSectionTitle(
            icon: Icons.bar_chart_rounded,
            title: title,
            subtitle: subtitle,
            fontSize: fontSize,
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
                          AppTextStyles.extraBold(
                            fontSize * 0.78,
                            color: AppColors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
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
                            style: AppTextStyles.regular(
                              fontSize * 0.72,
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
                              style: AppTextStyles.regular(
                                fontSize * 0.64,
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
                          width: 24,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined_rounded,
              size: 40,
              color: _primaryGreenDark.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular(
                fontSize * 0.92,
                color: Colors.black45,
              ),
            ),
          ],
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
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.list_alt_rounded,
            title: title,
            subtitle: 'Detalle numérico por categoría.',
            fontSize: fontSize,
          ),
          const SizedBox(height: 12),
          ...entries.map((entry) {
            final active = entry.value > 0;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: active
                    ? _panelColor.withValues(alpha: 0.88)
                    : AppColors.panelMuted.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _borderColor.withValues(alpha: 0.28),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: active
                          ? AppTextStyles.semiBold(
                              fontSize * 0.92,
                              color: _textColor,
                            )
                          : AppTextStyles.regular(
                              fontSize * 0.92,
                              color: Colors.black45,
                            ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 34),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? _primaryGreen.withValues(alpha: 0.12)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${entry.value}',
                      style: AppTextStyles.extraBold(
                        fontSize * 0.90,
                        color: active ? _primaryGreenDark : Colors.black45,
                      ),
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

  Widget _buildStateMessage({
    required IconData icon,
    required String title,
    required String message,
    required double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: _buildStyledContainer(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 44,
                color: _primaryGreenDark,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.extraBold(
                  fontSize,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(
                  fontSize * 0.92,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
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
  static const Color _borderColor = AppColors.borderColor;
  static const Color _shadowGreen = AppColors.shadowGreen;

  final int count;
  final String label;
  final Color circleColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _shadowGreen.withValues(alpha: 0.14),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black87,
                width: 1,
              ),
            ),
            child: Text(
              '$count',
              style: AppTextStyles.extraBold(
                fontSize * 0.92,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.semiBold(
                fontSize * 0.72,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

