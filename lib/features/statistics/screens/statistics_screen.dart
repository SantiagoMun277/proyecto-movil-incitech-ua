import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/features/statistics/screens/statistics_expandable_dropdown.dart';
import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  static const Color _backgroundColor = Color(0xFFB8DEBE);
  static const Color _cardColor = Color(0xFFEFEFEF);
  static const Color _primaryGreen = Color(0xFF0C7A27);
  static const Color _shadowGreen = Color(0x664FA96A);
  static const Color _textColor = Color(0xFF222222);

  bool _isGraphicExpanded = false;

  String _selectedGraphic = 'Incidentes por sede';

  final List<String> _graphicOptions = const [
    'Incidentes por sede',
    'Numero total de incidentes',
    'Numero de incidentes por estado',
    'Numero por tipo',
  ];

  final Map<String, int> _statusCounts = const {
    'Reportados': 2,
    'En proceso': 1,
    'Resueltos': 1,
  };

  final Map<String, int> _typeCounts = const {
    'Baño': 4,
    'Electricidad': 3,
    'Seguridad': 2,
    'Otros': 1,
  };

  void _toggleGraphicDropdown() {
    setState(() {
      _isGraphicExpanded = !_isGraphicExpanded;
    });
  }

  void _selectGraphic(String value) {
    setState(() {
      _selectedGraphic = value;
      _isGraphicExpanded = false;
    });
  }

  int get _totalIncidents =>
      _statusCounts.values.fold(0, (sum, value) => sum + value);

  Map<String, int> get _positiveTypeCounts {
    return Map.fromEntries(
      _typeCounts.entries.where((entry) => entry.value > 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _isGraphicExpanded = false;
        });
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        bottomNavigationBar: const AppBottomNav(currentIndex: 2),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              final double baseFontSize = w * 0.040;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  w * 0.03,
                  h * 0.015,
                  w * 0.03,
                  h * 0.025,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_incitech.png',
                      width: w * 0.80,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: h * 0.014),

                    _buildTopSelector(baseFontSize),
                    SizedBox(height: h * 0.02),

                    _buildTotalCard(baseFontSize),
                    SizedBox(height: h * 0.022),

                    _buildStatusSummary(baseFontSize),
                    SizedBox(height: h * 0.02),

                    _buildStateDistributionCard(baseFontSize),
                    SizedBox(height: h * 0.02),

                    _buildTypeChartCard(baseFontSize),
                    SizedBox(height: h * 0.02),

                    _buildTypeSummaryCard(baseFontSize),
                    SizedBox(height: h * 0.035),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '¡UNIVERSIDAD DE LA AMAZONIA\nMAS CONECTADA QUE NUNCA!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: baseFontSize * 1.08,
                          height: 1.0,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopSelector(double fontSize) {
    return Row(
      children: [
        Text(
          'Graficas:',
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Times New Roman',
            color: _textColor,
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
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard(double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            'Total de incidentes:',
            style: TextStyle(
              fontSize: fontSize * 1.05,
              fontFamily: 'Times New Roman',
              color: _textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$_totalIncidents',
            style: TextStyle(
              fontSize: fontSize * 1.18,
              fontFamily: 'Times New Roman',
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSummary(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatusMiniCard(
          count: _statusCounts['Reportados'] ?? 0,
          label: 'Reportados',
          circleColor: const Color(0xFFF47E7E),
          fontSize: fontSize,
        ),
        _StatusMiniCard(
          count: _statusCounts['En proceso'] ?? 0,
          label: 'En proceso',
          circleColor: const Color(0xFFF2C45E),
          fontSize: fontSize,
        ),
        _StatusMiniCard(
          count: _statusCounts['Resueltos'] ?? 0,
          label: 'Resueltos',
          circleColor: const Color(0xFF7BE48E),
          fontSize: fontSize,
        ),
      ],
    );
  }

  Widget _buildStateDistributionCard(double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución por estado',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(120, 120),
                  painter: _PieChartPainter(
                    values: [
                      _statusCounts['Reportados'] ?? 0,
                      _statusCounts['En proceso'] ?? 0,
                      _statusCounts['Resueltos'] ?? 0,
                    ],
                    colors: const [
                      Color(0xFFF23D3D),
                      Color(0xFFF5A400),
                      Color(0xFF12833A),
                    ],
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 18,
                  child: Text(
                    'Reportado',
                    style: TextStyle(
                      fontSize: fontSize * 0.70,
                      fontFamily: 'Times New Roman',
                      color: const Color(0xFFF23D3D),
                    ),
                  ),
                ),
                Positioned(
                  left: 2,
                  bottom: 30,
                  child: Text(
                    'En proceso',
                    style: TextStyle(
                      fontSize: fontSize * 0.70,
                      fontFamily: 'Times New Roman',
                      color: const Color(0xFFF5A400),
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 8,
                  child: Text(
                    'Resuelto',
                    style: TextStyle(
                      fontSize: fontSize * 0.70,
                      fontFamily: 'Times New Roman',
                      color: const Color(0xFF12833A),
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

  Widget _buildTypeChartCard(double fontSize) {
    final positiveTypes = _positiveTypeCounts;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Incidentes por tipo',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 10),
          _BarChart(
            values: positiveTypes,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSummaryCard(double fontSize) {
    final orderedKeys = _typeCounts.keys.toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: orderedKeys.map((key) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$key:',
                    style: TextStyle(
                      fontSize: fontSize * 1.02,
                      fontFamily: 'Times New Roman',
                      color: _textColor,
                    ),
                  ),
                ),
                Text(
                  '${_typeCounts[key] ?? 0}',
                  style: TextStyle(
                    fontSize: fontSize * 1.02,
                    fontFamily: 'Times New Roman',
                    color: _textColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatusMiniCard extends StatelessWidget {
  const _StatusMiniCard({
    required this.count,
    required this.label,
    required this.circleColor,
    required this.fontSize,
  });

  final int count;
  final String label;
  final Color circleColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF6B6B6B), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black54, width: 0.8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: fontSize * 0.82,
                fontFamily: 'Times New Roman',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize * 0.74,
              fontFamily: 'Times New Roman',
              color: const Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({
    required this.values,
    required this.fontSize,
  });

  final Map<String, int> values;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'No hay datos para mostrar',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Times New Roman',
            ),
          ),
        ),
      );
    }

    final maxValue = values.values.reduce(math.max);

    return Container(
      height: 170,
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(maxValue + 1, (index) {
                final value = maxValue - index;
                return Text(
                  '$value',
                  style: TextStyle(
                    fontSize: fontSize * 0.60,
                    fontFamily: 'Times New Roman',
                    color: Colors.grey.shade700,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: values.entries.map((entry) {
                final barHeight = (entry.value / maxValue) * 110.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 110,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFF138534),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry.key,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fontSize * 0.60,
                            fontFamily: 'Times New Roman',
                            color: const Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.values,
    required this.colors,
  });

  final List<int> values;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<int>(0, (sum, item) => sum + item);
    if (total == 0) return;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    double startAngle = -math.pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * math.pi;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}