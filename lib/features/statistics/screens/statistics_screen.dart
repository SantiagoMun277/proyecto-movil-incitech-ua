
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

// class StatisticsScreen extends StatefulWidget {
//   const StatisticsScreen({super.key});

//   @override
//   State<StatisticsScreen> createState() => _StatisticsScreenState();
// }

// class _StatisticsScreenState extends State<StatisticsScreen> {
//   static const Color _backgroundColor = Color(0xFFB8DEBE);
//   static const Color _cardColor = Color(0xFFF2F2F2);
//   static const Color _primaryGreen = Color(0xFF0C7A27);
//   static const Color _shadowGreen = Color(0x664FA96A);
//   static const Color _textColor = Color(0xFF222222);
//   static const Color _borderColor = Color(0xFF6A6A6A);

//   final Map<String, int> _statusCounts = const {
//     'Reportado': 2,
//     'En proceso': 1,
//     'Resuelto': 1,
//   };

//   final Map<String, int> _allTypeCounts = const {
//     'Infraestructura': 0,
//     'Electricidad': 3,
//     'Hidráulico / agua': 0,
//     'Baños / saneamiento': 4,
//     'Seguridad': 2,
//     'Aseo y limpieza': 0,
//     'Mobiliario': 0,
//     'Tecnología / equipos': 0,
//     'Conectividad / red': 1,
//     'Zonas verdes / exteriores': 0,
//     'Señalización / accesibilidad': 0,
//     'Riesgo biológico o ambiental': 0,
//     'Emergencia': 0,
//     'Convivencia / comportamiento': 0,
//     'Otros': 1,
//   };

//   int get _totalIncidents =>
//       _statusCounts.values.fold(0, (sum, value) => sum + value);

//   Map<String, int> get _positiveTypeCounts {
//     return Map.fromEntries(
//       _allTypeCounts.entries.where((entry) => entry.value > 0),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       bottomNavigationBar: const AppBottomNav(currentIndex: 2),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final w = constraints.maxWidth;
//             final h = constraints.maxHeight;
//             final baseFontSize = w * 0.040;

//             return SingleChildScrollView(
//               padding: EdgeInsets.fromLTRB(
//                 w * 0.035,
//                 h * 0.015,
//                 w * 0.035,
//                 h * 0.025,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Center(
//                     child: Image.asset(
//                       'assets/images/logo_incitech.png',
//                       width: w * 0.78,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(height: h * 0.018),

//                   _buildSectionHeader(
//                     title: 'Gráficas generales',
//                     subtitle: 'Resumen fijo de incidentes por estado y por tipo',
//                     fontSize: baseFontSize,
//                   ),
//                   SizedBox(height: h * 0.018),

//                   _buildTotalCard(baseFontSize),
//                   SizedBox(height: h * 0.02),

//                   _buildStatusSummary(baseFontSize),
//                   SizedBox(height: h * 0.02),

//                   _buildStateDistributionCard(baseFontSize),
//                   SizedBox(height: h * 0.02),

//                   _buildTypeChartCard(baseFontSize),
//                   SizedBox(height: h * 0.02),

//                   _buildTypeSummaryCard(baseFontSize),
//                   SizedBox(height: h * 0.03),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       '¡UNIVERSIDAD DE LA AMAZONIA\nMAS CONECTADA QUE NUNCA!',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: baseFontSize * 1.08,
//                         height: 1.0,
//                         fontWeight: FontWeight.w600,
//                         color: _textColor,
//                         fontFamily: 'Times New Roman',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader({
//     required String title,
//     required String subtitle,
//     required double fontSize,
//   }) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: _shadowGreen,
//             offset: Offset(4, 5),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: fontSize * 1.10,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: fontSize * 0.88,
//               fontFamily: 'Times New Roman',
//               color: Colors.black54,
//               height: 1.15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTotalCard(double fontSize) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: _shadowGreen,
//             offset: Offset(4, 5),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             'Total de incidentes registrados',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: fontSize * 1.02,
//               fontFamily: 'Times New Roman',
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Container(
//             width: 76,
//             height: 76,
//             decoration: BoxDecoration(
//               color: const Color(0xFFE7F3E9),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: const Color(0xFF1E7B35),
//                 width: 1.2,
//               ),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               '$_totalIncidents',
//               style: TextStyle(
//                 fontSize: fontSize * 1.65,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'Times New Roman',
//                 color: const Color(0xFF0C7A27),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusSummary(double fontSize) {
//     return Row(
//       children: [
//         Expanded(
//           child: _StatusMiniCard(
//             count: _statusCounts['Reportado'] ?? 0,
//             label: 'Reportado',
//             circleColor: const Color(0xFFF47E7E),
//             fontSize: fontSize,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _StatusMiniCard(
//             count: _statusCounts['En proceso'] ?? 0,
//             label: 'En proceso',
//             circleColor: const Color(0xFFF2C45E),
//             fontSize: fontSize,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _StatusMiniCard(
//             count: _statusCounts['Resuelto'] ?? 0,
//             label: 'Resuelto',
//             circleColor: const Color(0xFF7BE48E),
//             fontSize: fontSize,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStateDistributionCard(double fontSize) {
//     final items = [
//       _ChartDatum(
//         label: 'Reportado',
//         value: _statusCounts['Reportado'] ?? 0,
//         color: const Color(0xFFF23D3D),
//       ),
//       _ChartDatum(
//         label: 'En proceso',
//         value: _statusCounts['En proceso'] ?? 0,
//         color: const Color(0xFFF5A400),
//       ),
//       _ChartDatum(
//         label: 'Resuelto',
//         value: _statusCounts['Resuelto'] ?? 0,
//         color: const Color(0xFF12833A),
//       ),
//     ];

//     return Container(
//       padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: _shadowGreen,
//             offset: Offset(4, 5),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Distribución por estado',
//             style: TextStyle(
//               fontSize: fontSize * 1.02,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Aquí se visualiza el peso de cada estado dentro del total.',
//             style: TextStyle(
//               fontSize: fontSize * 0.82,
//               fontFamily: 'Times New Roman',
//               color: Colors.black54,
//             ),
//           ),
//           const SizedBox(height: 14),
//           Row(
//             children: [
//               Expanded(
//                 flex: 5,
//                 child: SizedBox(
//                   height: 180,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       CustomPaint(
//                         size: const Size(170, 170),
//                         painter: _PieChartPainter(items: items),
//                       ),
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Total',
//                             style: TextStyle(
//                               fontSize: fontSize * 0.80,
//                               fontFamily: 'Times New Roman',
//                               color: Colors.black54,
//                             ),
//                           ),
//                           Text(
//                             '$_totalIncidents',
//                             style: TextStyle(
//                               fontSize: fontSize * 1.25,
//                               fontFamily: 'Times New Roman',
//                               fontWeight: FontWeight.w700,
//                               color: _textColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 4,
//                 child: Column(
//                   children: items.map((item) {
//                     final percent = _totalIncidents == 0
//                         ? 0
//                         : ((item.value / _totalIncidents) * 100).round();
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       child: _LegendTile(
//                         color: item.color,
//                         label: item.label,
//                         valueText: '${item.value} ($percent%)',
//                         fontSize: fontSize,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypeChartCard(double fontSize) {
//     final positiveTypes = _positiveTypeCounts;

//     return Container(
//       padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: _shadowGreen,
//             offset: Offset(4, 5),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Incidentes por tipo',
//             style: TextStyle(
//               fontSize: fontSize * 1.02,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'En la gráfica solo aparecen los tipos con cantidad mayor que 0. En móvil toca la barra; en computador puedes pasar el mouse.',
//             style: TextStyle(
//               fontSize: fontSize * 0.80,
//               fontFamily: 'Times New Roman',
//               color: Colors.black54,
//               height: 1.15,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _InteractiveBarChart(
//             values: positiveTypes,
//             fontSize: fontSize,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypeSummaryCard(double fontSize) {
//     final orderedEntries = _allTypeCounts.entries.toList();

//     return Container(
//       padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: _shadowGreen,
//             offset: Offset(4, 5),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Cantidad por cada tipo',
//             style: TextStyle(
//               fontSize: fontSize * 1.02,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 10),
//           ...List.generate(orderedEntries.length, (index) {
//             final entry = orderedEntries[index];
//             final isEven = index.isEven;

//             return Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
//               decoration: BoxDecoration(
//                 color: isEven
//                     ? const Color(0xFFF8F8F8)
//                     : const Color(0xFFEFEFEF),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: const Color(0x11000000),
//                   width: 0.8,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       entry.key,
//                       style: TextStyle(
//                         fontSize: fontSize * 0.95,
//                         fontFamily: 'Times New Roman',
//                         color: _textColor,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     constraints: const BoxConstraints(minWidth: 34),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE7F3E9),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: const Color(0x220C7A27),
//                         width: 0.9,
//                       ),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       '${entry.value}',
//                       style: TextStyle(
//                         fontSize: fontSize * 0.92,
//                         fontFamily: 'Times New Roman',
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xFF0C7A27),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// class _ChartDatum {
//   const _ChartDatum({
//     required this.label,
//     required this.value,
//     required this.color,
//   });

//   final String label;
//   final int value;
//   final Color color;
// }

// class _StatusMiniCard extends StatelessWidget {
//   const _StatusMiniCard({
//     required this.count,
//     required this.label,
//     required this.circleColor,
//     required this.fontSize,
//   });

//   final int count;
//   final String label;
//   final Color circleColor;
//   final double fontSize;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF6F6F6),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFF6B6B6B), width: 0.9),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x224FA96A),
//             offset: Offset(2, 3),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: circleColor,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.black54, width: 0.8),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               '$count',
//               style: TextStyle(
//                 fontSize: fontSize * 0.78,
//                 fontFamily: 'Times New Roman',
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: fontSize * 0.72,
//               fontFamily: 'Times New Roman',
//               color: const Color(0xFF222222),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LegendTile extends StatelessWidget {
//   const _LegendTile({
//     required this.color,
//     required this.label,
//     required this.valueText,
//     required this.fontSize,
//   });

//   final Color color;
//   final String label;
//   final String valueText;
//   final double fontSize;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F8F8),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: const Color(0x11000000),
//           width: 0.8,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 14,
//             height: 14,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: fontSize * 0.82,
//                 fontFamily: 'Times New Roman',
//                 color: const Color(0xFF222222),
//               ),
//             ),
//           ),
//           Text(
//             valueText,
//             style: TextStyle(
//               fontSize: fontSize * 0.78,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF222222),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InteractiveBarChart extends StatefulWidget {
//   const _InteractiveBarChart({
//     required this.values,
//     required this.fontSize,
//   });

//   final Map<String, int> values;
//   final double fontSize;

//   @override
//   State<_InteractiveBarChart> createState() => _InteractiveBarChartState();
// }

// class _InteractiveBarChartState extends State<_InteractiveBarChart> {
//   int? _activeIndex;

//   @override
//   Widget build(BuildContext context) {
//     if (widget.values.isEmpty) {
//       return SizedBox(
//         height: 190,
//         child: Center(
//           child: Text(
//             'No hay tipos con cantidad mayor que 0.',
//             style: TextStyle(
//               fontSize: widget.fontSize,
//               fontFamily: 'Times New Roman',
//               color: const Color(0xFF222222),
//             ),
//           ),
//         ),
//       );
//     }

//     final entries = widget.values.entries.toList();
//     final maxValue = entries.map((e) => e.value).reduce(math.max);
//     final midValue = (maxValue / 2).ceil();

//     return Container(
//       height: 245,
//       padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F8F8),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: const Color(0x11000000),
//           width: 0.8,
//         ),
//       ),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final minChartWidth = math.max(
//             constraints.maxWidth - 34,
//             entries.length * 78.0,
//           ).toDouble();

//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               SizedBox(
//                 width: 24,
//                 height: 170,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _axisText('$maxValue'),
//                     _axisText('$midValue'),
//                     _axisText('0'),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SizedBox(
//                     width: minChartWidth,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: List.generate(entries.length, (index) {
//                         final entry = entries[index];
//                         final isActive = _activeIndex == index;

//                         return Expanded(
//                           child: _InteractiveBarItem(
//                             label: entry.key,
//                             value: entry.value,
//                             maxValue: maxValue,
//                             fontSize: widget.fontSize,
//                             isActive: isActive,
//                             onActivate: () {
//                               setState(() {
//                                 _activeIndex =
//                                     _activeIndex == index ? null : index;
//                               });
//                             },
//                             onHoverEnter: () {
//                               setState(() {
//                                 _activeIndex = index;
//                               });
//                             },
//                             onHoverExit: () {
//                               setState(() {
//                                 if (_activeIndex == index) {
//                                   _activeIndex = null;
//                                 }
//                               });
//                             },
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _axisText(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: widget.fontSize * 0.64,
//         fontFamily: 'Times New Roman',
//         color: Colors.grey.shade700,
//       ),
//     );
//   }
// }

// class _InteractiveBarItem extends StatelessWidget {
//   const _InteractiveBarItem({
//     required this.label,
//     required this.value,
//     required this.maxValue,
//     required this.fontSize,
//     required this.isActive,
//     required this.onActivate,
//     required this.onHoverEnter,
//     required this.onHoverExit,
//   });

//   final String label;
//   final int value;
//   final int maxValue;
//   final double fontSize;
//   final bool isActive;
//   final VoidCallback onActivate;
//   final VoidCallback onHoverEnter;
//   final VoidCallback onHoverExit;

//   @override
//   Widget build(BuildContext context) {
//     final double barMaxHeight = 118;
//     final double barHeight =
//         maxValue == 0 ? 0 : (value / maxValue) * barMaxHeight;

//     return MouseRegion(
//       onEnter: (_) => onHoverEnter(),
//       onExit: (_) => onHoverExit(),
//       child: GestureDetector(
//         onTap: onActivate,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               SizedBox(
//                 height: 50,
//                 child: isActive
//                     ? Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1B1B1B),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           '$label\nCantidad: $value',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: fontSize * 0.68,
//                             fontFamily: 'Times New Roman',
//                             color: Colors.white,
//                             height: 1.05,
//                           ),
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//               ),
//               const SizedBox(height: 6),
//               Container(
//                 height: 124,
//                 alignment: Alignment.bottomCenter,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 180),
//                   width: isActive ? 30 : 24,
//                   height: barHeight,
//                   decoration: BoxDecoration(
//                     color: isActive
//                         ? const Color(0xFF0C7A27)
//                         : const Color(0xFF1A8C39),
//                     borderRadius: BorderRadius.circular(6),
//                     boxShadow: isActive
//                         ? const [
//                             BoxShadow(
//                               color: Color(0x334FA96A),
//                               blurRadius: 6,
//                               offset: Offset(1, 2),
//                             ),
//                           ]
//                         : null,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: fontSize * 0.64,
//                   fontFamily: 'Times New Roman',
//                   color: const Color(0xFF222222),
//                   height: 1.05,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _PieChartPainter extends CustomPainter {
//   _PieChartPainter({
//     required this.items,
//   });

//   final List<_ChartDatum> items;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final total = items.fold<int>(0, (sum, item) => sum + item.value);
//     if (total == 0) return;

//     final rect = Rect.fromCircle(
//       center: Offset(size.width / 2, size.height / 2),
//       radius: size.width / 2,
//     );

//     double startAngle = -math.pi / 2;

//     for (final item in items) {
//       final sweepAngle = (item.value / total) * 2 * math.pi;

//       final paint = Paint()
//         ..color = item.color
//         ..style = PaintingStyle.fill;

//       canvas.drawArc(
//         rect,
//         startAngle,
//         sweepAngle,
//         true,
//         paint,
//       );

//       startAngle += sweepAngle;
//     }

//     final holePaint = Paint()
//       ..color = const Color(0xFFF2F2F2)
//       ..style = PaintingStyle.fill;

//     canvas.drawCircle(
//       Offset(size.width / 2, size.height / 2),
//       size.width * 0.24,
//       holePaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
//     return oldDelegate.items != items;
//   }
// }





















//////////////////////////////////////////////////////////////////////////






// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/features/statistics/screens/statistics_expandable_dropdown.dart';
// import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

// class StatisticsScreen extends StatefulWidget {
//   const StatisticsScreen({super.key});

//   @override
//   State<StatisticsScreen> createState() => _StatisticsScreenState();
// }

// class _StatisticsScreenState extends State<StatisticsScreen> {
//   static const Color _backgroundColor = Color(0xFFB8DEBE);
//   static const Color _cardColor = Color(0xFFF2F2F2);
//   static const Color _primaryGreen = Color(0xFF0C7A27);
//   static const Color _shadowGreen = Color(0x664FA96A);
//   static const Color _textColor = Color(0xFF222222);
//   static const Color _borderColor = Color(0xFF6A6A6A);

//   bool _isGraphicExpanded = false;

//   String _selectedGraphic = 'Resumen general';

//   final List<String> _graphicOptions = const [
//     'Resumen general',
//     'Incidentes por sede',
//     'Numero total de incidentes',
//     'Numero de incidentes por estado',
//     'Numero por tipo',
//   ];

//   // Datos simulados por ahora
//   final Map<String, int> _statusCounts = const {
//     'Reportado': 2,
//     'En proceso': 1,
//     'Resuelto': 1,
//   };

//   final Map<String, int> _siteCounts = const {
//     'Sede Porvenir': 2,
//     'Sede Juan XXIII': 1,
//     'Sede Social': 1,
//     'Sede Santo Domingo': 0,
//     'Sede Macagual': 0,
//   };

//   final Map<String, int> _allTypeCounts = const {
//     'Infraestructura': 0,
//     'Electricidad': 3,
//     'Hidráulico / agua': 0,
//     'Baños / saneamiento': 4,
//     'Seguridad': 2,
//     'Aseo y limpieza': 0,
//     'Mobiliario': 0,
//     'Tecnología / equipos': 0,
//     'Conectividad / red': 1,
//     'Zonas verdes / exteriores': 0,
//     'Señalización / accesibilidad': 0,
//     'Riesgo biológico o ambiental': 0,
//     'Emergencia': 0,
//     'Convivencia / comportamiento': 0,
//     'Otros': 1,
//   };

//   void _toggleGraphicDropdown() {
//     setState(() {
//       _isGraphicExpanded = !_isGraphicExpanded;
//     });
//   }

//   void _selectGraphic(String value) {
//     setState(() {
//       _selectedGraphic = value;
//       _isGraphicExpanded = false;
//     });
//   }

//   int get _totalIncidents =>
//       _statusCounts.values.fold(0, (sum, value) => sum + value);

//   Map<String, int> get _positiveTypeCounts {
//     return Map.fromEntries(
//       _allTypeCounts.entries.where((entry) => entry.value > 0),
//     );
//   }

//   Map<String, int> get _positiveSiteCounts {
//     return Map.fromEntries(
//       _siteCounts.entries.where((entry) => entry.value > 0),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         setState(() {
//           _isGraphicExpanded = false;
//         });
//       },
//       child: Scaffold(
//         backgroundColor: _backgroundColor,
//         bottomNavigationBar: const AppBottomNav(currentIndex: 2),
//         body: SafeArea(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final w = constraints.maxWidth;
//               final h = constraints.maxHeight;
//               final double baseFontSize = w * 0.040;

//               return SingleChildScrollView(
//                 padding: EdgeInsets.fromLTRB(
//                   w * 0.03,
//                   h * 0.015,
//                   w * 0.03,
//                   h * 0.025,
//                 ),
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'GRAFICAS',
//                         style: TextStyle(
//                           fontSize: baseFontSize * 0.88,
//                           color: Colors.black54,
//                           fontFamily: 'Arial',
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: h * 0.006),

//                     Image.asset(
//                       'assets/images/logo_incitech.png',
//                       width: w * 0.74,
//                       fit: BoxFit.contain,
//                     ),
//                     SizedBox(height: h * 0.014),

//                     _buildTopSelector(baseFontSize),
//                     SizedBox(height: h * 0.02),

//                     ..._buildFilteredWidgets(baseFontSize, h),

//                     SizedBox(height: h * 0.03),

//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text(
//                         '¡UNIVERSIDAD DE LA AMAZONIA\nMAS CONECTADA QUE NUNCA!',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: baseFontSize * 1.08,
//                           height: 1.0,
//                           fontWeight: FontWeight.w600,
//                           color: _textColor,
//                           fontFamily: 'Times New Roman',
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: h * 0.02),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildFilteredWidgets(double fontSize, double h) {
//     switch (_selectedGraphic) {
//       case 'Incidentes por sede':
//         return [
//           _buildTotalCard(fontSize),
//           SizedBox(height: h * 0.022),
//           _buildSiteChartCard(fontSize),
//           SizedBox(height: h * 0.02),
//           _buildSiteSummaryCard(fontSize),
//         ];

//       case 'Numero total de incidentes':
//         return [
//           _buildTotalCard(fontSize),
//         ];

//       case 'Numero de incidentes por estado':
//         return [
//           _buildTotalCard(fontSize),
//           SizedBox(height: h * 0.022),
//           _buildStatusSummary(fontSize),
//           SizedBox(height: h * 0.02),
//           _buildStateDistributionCard(fontSize),
//         ];

//       case 'Numero por tipo':
//         return [
//           _buildTotalCard(fontSize),
//           SizedBox(height: h * 0.022),
//           _buildTypeChartCard(fontSize),
//           SizedBox(height: h * 0.02),
//           _buildTypeSummaryCard(fontSize),
//         ];

//       case 'Resumen general':
//       default:
//         return [
//           _buildTotalCard(fontSize),
//           SizedBox(height: h * 0.022),
//           _buildStatusSummary(fontSize),
//           SizedBox(height: h * 0.02),
//           _buildStateDistributionCard(fontSize),
//           SizedBox(height: h * 0.02),
//           _buildTypeChartCard(fontSize),
//           SizedBox(height: h * 0.02),
//           _buildTypeSummaryCard(fontSize),
//         ];
//     }
//   }

//   Widget _buildTopSelector(double fontSize) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: Text(
//             'Graficas:',
//             style: TextStyle(
//               fontSize: fontSize,
//               fontFamily: 'Times New Roman',
//               color: _textColor,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: StatisticsExpandableDropdown(
//             value: _selectedGraphic,
//             items: _graphicOptions,
//             isExpanded: _isGraphicExpanded,
//             onTap: _toggleGraphicDropdown,
//             onSelected: _selectGraphic,
//             fontSize: fontSize * 0.92,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTotalCard(double fontSize) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 18),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: [
//           Text(
//             'Total de incidentes:',
//             style: TextStyle(
//               fontSize: fontSize * 1.02,
//               fontFamily: 'Times New Roman',
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             '$_totalIncidents',
//             style: TextStyle(
//               fontSize: fontSize * 1.20,
//               fontFamily: 'Times New Roman',
//               color: _textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusSummary(double fontSize) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Expanded(
//           child: _StatusMiniCard(
//             count: _statusCounts['Reportado'] ?? 0,
//             label: 'Reportados',
//             circleColor: const Color(0xFFF47E7E),
//             fontSize: fontSize,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: _StatusMiniCard(
//             count: _statusCounts['En proceso'] ?? 0,
//             label: 'En proceso',
//             circleColor: const Color(0xFFF2C45E),
//             fontSize: fontSize,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: _StatusMiniCard(
//             count: _statusCounts['Resuelto'] ?? 0,
//             label: 'Resueltos',
//             circleColor: const Color(0xFF7BE48E),
//             fontSize: fontSize,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStateDistributionCard(double fontSize) {
//     final items = [
//       _ChartDatum(
//         label: 'Reportado',
//         value: _statusCounts['Reportado'] ?? 0,
//         color: const Color(0xFFF23D3D),
//       ),
//       _ChartDatum(
//         label: 'En proceso',
//         value: _statusCounts['En proceso'] ?? 0,
//         color: const Color(0xFFF5A400),
//       ),
//       _ChartDatum(
//         label: 'Resuelto',
//         value: _statusCounts['Resuelto'] ?? 0,
//         color: const Color(0xFF12833A),
//       ),
//     ];

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Distribución por estado',
//             style: TextStyle(
//               fontSize: fontSize,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 10),
//           SizedBox(
//             height: 150,
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 5,
//                   child: Center(
//                     child: SizedBox(
//                       width: 125,
//                       height: 125,
//                       child: CustomPaint(
//                         painter: _PieChartPainter(items: items),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   flex: 4,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: items.map((item) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10),
//                         child: _LegendTile(
//                           color: item.color,
//                           label: item.label,
//                           valueText: '${item.value}',
//                           fontSize: fontSize,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypeChartCard(double fontSize) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Incidentes por tipo',
//             style: TextStyle(
//               fontSize: fontSize,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 10),
//           _InteractiveBarChart(
//             values: _positiveTypeCounts,
//             fontSize: fontSize,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypeSummaryCard(double fontSize) {
//     final orderedKeys = _allTypeCounts.keys.toList();

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: orderedKeys.map((key) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     '$key:',
//                     style: TextStyle(
//                       fontSize: fontSize * 0.96,
//                       fontFamily: 'Times New Roman',
//                       color: _textColor,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${_allTypeCounts[key] ?? 0}',
//                   style: TextStyle(
//                     fontSize: fontSize * 0.96,
//                     fontFamily: 'Times New Roman',
//                     color: _textColor,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildSiteChartCard(double fontSize) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Incidentes por sede',
//             style: TextStyle(
//               fontSize: fontSize,
//               fontFamily: 'Times New Roman',
//               fontWeight: FontWeight.w700,
//               color: _textColor,
//             ),
//           ),
//           const SizedBox(height: 10),
//           _InteractiveBarChart(
//             values: _positiveSiteCounts,
//             fontSize: fontSize,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSiteSummaryCard(double fontSize) {
//     final orderedKeys = _siteCounts.keys.toList();

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//       decoration: BoxDecoration(
//         color: _cardColor,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: orderedKeys.map((key) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     '$key:',
//                     style: TextStyle(
//                       fontSize: fontSize * 0.96,
//                       fontFamily: 'Times New Roman',
//                       color: _textColor,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${_siteCounts[key] ?? 0}',
//                   style: TextStyle(
//                     fontSize: fontSize * 0.96,
//                     fontFamily: 'Times New Roman',
//                     color: _textColor,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// class _ChartDatum {
//   const _ChartDatum({
//     required this.label,
//     required this.value,
//     required this.color,
//   });

//   final String label;
//   final int value;
//   final Color color;
// }

// class _StatusMiniCard extends StatelessWidget {
//   const _StatusMiniCard({
//     required this.count,
//     required this.label,
//     required this.circleColor,
//     required this.fontSize,
//   });

//   final int count;
//   final String label;
//   final Color circleColor;
//   final double fontSize;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF1F1F1),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFF6B6B6B), width: 1),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               color: circleColor,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.black54, width: 0.8),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               '$count',
//               style: TextStyle(
//                 fontSize: fontSize * 0.82,
//                 fontFamily: 'Times New Roman',
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: fontSize * 0.72,
//               fontFamily: 'Times New Roman',
//               color: const Color(0xFF222222),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LegendTile extends StatelessWidget {
//   const _LegendTile({
//     required this.color,
//     required this.label,
//     required this.valueText,
//     required this.fontSize,
//   });

//   final Color color;
//   final String label;
//   final String valueText;
//   final double fontSize;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: fontSize * 0.78,
//               fontFamily: 'Times New Roman',
//               color: _StatisticsScreenState._textColor,
//             ),
//           ),
//         ),
//         Text(
//           valueText,
//           style: TextStyle(
//             fontSize: fontSize * 0.78,
//             fontFamily: 'Times New Roman',
//             color: _StatisticsScreenState._textColor,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _InteractiveBarChart extends StatefulWidget {
//   const _InteractiveBarChart({
//     required this.values,
//     required this.fontSize,
//   });

//   final Map<String, int> values;
//   final double fontSize;

//   @override
//   State<_InteractiveBarChart> createState() => _InteractiveBarChartState();
// }

// class _InteractiveBarChartState extends State<_InteractiveBarChart> {
//   int? _activeIndex;

//   @override
//   Widget build(BuildContext context) {
//     if (widget.values.isEmpty) {
//       return SizedBox(
//         height: 160,
//         child: Center(
//           child: Text(
//             'No hay datos para mostrar',
//             style: TextStyle(
//               fontSize: widget.fontSize,
//               fontFamily: 'Times New Roman',
//             ),
//           ),
//         ),
//       );
//     }

//     final entries = widget.values.entries.toList();
//     final maxValue = entries.map((e) => e.value).reduce(math.max);

//     return Container(
//       height: 210,
//       padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F3F3),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           SizedBox(
//             width: 20,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(maxValue + 1, (index) {
//                 final value = maxValue - index;
//                 return Text(
//                   '$value',
//                   style: TextStyle(
//                     fontSize: widget.fontSize * 0.58,
//                     fontFamily: 'Times New Roman',
//                     color: Colors.grey.shade700,
//                   ),
//                 );
//               }),
//             ),
//           ),
//           const SizedBox(width: 6),
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: List.generate(entries.length, (index) {
//                   final entry = entries[index];
//                   final barHeight = maxValue == 0
//                       ? 0.0
//                       : (entry.value / maxValue) * 110.0;
//                   final isActive = _activeIndex == index;

//                   return MouseRegion(
//                     onEnter: (_) {
//                       setState(() {
//                         _activeIndex = index;
//                       });
//                     },
//                     onExit: (_) {
//                       setState(() {
//                         _activeIndex = null;
//                       });
//                     },
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _activeIndex = _activeIndex == index ? null : index;
//                         });
//                       },
//                       child: Container(
//                         width: 56,
//                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             SizedBox(
//                               height: 38,
//                               child: isActive
//                                   ? Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 6,
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.black87,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Text(
//                                         '${entry.key}\nCantidad: ${entry.value}',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontSize: widget.fontSize * 0.52,
//                                           fontFamily: 'Times New Roman',
//                                           color: Colors.white,
//                                           height: 1.0,
//                                         ),
//                                       ),
//                                     )
//                                   : const SizedBox.shrink(),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               height: 110,
//                               alignment: Alignment.bottomCenter,
//                               child: AnimatedContainer(
//                                 duration: const Duration(milliseconds: 180),
//                                 height: barHeight,
//                                 width: isActive ? 28 : 24,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF138534),
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               entry.key,
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: widget.fontSize * 0.54,
//                                 fontFamily: 'Times New Roman',
//                                 color: const Color(0xFF222222),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PieChartPainter extends CustomPainter {
//   _PieChartPainter({
//     required this.items,
//   });

//   final List<_ChartDatum> items;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final total = items.fold<int>(0, (sum, item) => sum + item.value);
//     if (total == 0) return;

//     final rect = Rect.fromCircle(
//       center: Offset(size.width / 2, size.height / 2),
//       radius: size.width / 2,
//     );

//     double startAngle = -math.pi / 2;

//     for (final item in items) {
//       final sweepAngle = (item.value / total) * 2 * math.pi;

//       final paint = Paint()
//         ..color = item.color
//         ..style = PaintingStyle.fill;

//       canvas.drawArc(
//         rect,
//         startAngle,
//         sweepAngle,
//         true,
//         paint,
//       );

//       startAngle += sweepAngle;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

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
  static const Color _cardColor = Color(0xFFF2F2F2);
  static const Color _primaryGreen = Color(0xFF0C7A27);
  static const Color _shadowGreen = Color(0x664FA96A);
  static const Color _textColor = Color(0xFF222222);
  static const Color _borderColor = Color(0xFF6A6A6A);

  bool _isGraphicExpanded = false;

  String _selectedGraphic = 'Incidentes por sede';

  final List<String> _graphicOptions = const [
    'Resumen general',
    'Incidentes por sede',
    'Numero total de incidentes',
    'Numero de incidentes por estado',
    'Numero por tipo',
  ];

  // Datos simulados por ahora
  final Map<String, int> _statusCounts = const {
    'Reportado': 2,
    'En proceso': 1,
    'Resuelto': 1,
  };

  final Map<String, int> _siteCounts = const {
    'Sede Porvenir': 2,
    'Sede Juan XXIII': 1,
    'Sede Social': 1,
    'Sede Santo Domingo': 0,
    'Sede Macagual': 0,
  };

  final Map<String, int> _allTypeCounts = const {
    'Infraestructura': 0,
    'Electricidad': 3,
    'Hidráulico / agua': 0,
    'Baños / saneamiento': 4,
    'Seguridad': 2,
    'Aseo y limpieza': 0,
    'Mobiliario': 0,
    'Tecnología / equipos': 0,
    'Conectividad / red': 1,
    'Zonas verdes / exteriores': 0,
    'Señalización / accesibilidad': 0,
    'Riesgo biológico o ambiental': 0,
    'Emergencia': 0,
    'Convivencia / comportamiento': 0,
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
      _allTypeCounts.entries.where((entry) => entry.value > 0),
    );
  }

  Map<String, int> get _positiveSiteCounts {
    return Map.fromEntries(
      _siteCounts.entries.where((entry) => entry.value > 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_isGraphicExpanded) {
          setState(() {
            _isGraphicExpanded = false;
          });
        }
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'GRAFICAS',
                        style: TextStyle(
                          fontSize: baseFontSize * 0.88,
                          color: Colors.black54,
                          fontFamily: 'Arial',
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

                    ..._buildFilteredWidgets(baseFontSize, h),

                    SizedBox(height: h * 0.03),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '¡UNIVERSIDAD DE LA AMAZONIA\nMAS CONECTADA QUE NUNCA!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: baseFontSize * 1.04,
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

  List<Widget> _buildFilteredWidgets(double fontSize, double h) {
    switch (_selectedGraphic) {
      case 'Incidentes por sede':
        return [
          _buildTotalCard(fontSize),
          SizedBox(height: h * 0.02),
          _buildSiteChartCard(fontSize),
          SizedBox(height: h * 0.02),
          _buildSiteSummaryCard(fontSize),
        ];

      case 'Numero total de incidentes':
        return [
          _buildTotalCard(fontSize),
        ];

      case 'Numero de incidentes por estado':
        return [
          _buildTotalCard(fontSize),
          SizedBox(height: h * 0.02),
          _buildStatusSummary(fontSize),
          SizedBox(height: h * 0.02),
          _buildStateDistributionCard(fontSize),
        ];

      case 'Numero por tipo':
        return [
          _buildTotalCard(fontSize),
          SizedBox(height: h * 0.02),
          _buildTypeChartCard(fontSize),
          SizedBox(height: h * 0.02),
          _buildTypeSummaryCard(fontSize),
        ];

      case 'Resumen general':
      default:
        return [
          _buildSectionHeader(
            title: 'Gráficas generales',
            subtitle: 'Resumen visual de incidentes por estado, sede y tipo.',
            fontSize: fontSize,
          ),
          SizedBox(height: h * 0.018),
          _buildTotalCard(fontSize),
          SizedBox(height: h * 0.02),
          _buildStatusSummary(fontSize),
          SizedBox(height: h * 0.02),
          _buildStateDistributionCard(fontSize),
          SizedBox(height: h * 0.02),
          _buildTypeChartCard(fontSize),
          SizedBox(height: h * 0.02),
          _buildTypeSummaryCard(fontSize),
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
            'Graficas:',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Times New Roman',
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

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required double fontSize,
  }) {
    return _buildStyledContainer(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize * 1.08,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: fontSize * 0.84,
              fontFamily: 'Times New Roman',
              color: Colors.black54,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTitle(
    String title,
    double fontSize, {
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize * 1.02,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.w700,
            color: _textColor,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: fontSize * 0.80,
              fontFamily: 'Times New Roman',
              color: Colors.black54,
              height: 1.15,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTotalCard(double fontSize) {
    return _buildStyledContainer(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      child: Column(
        children: [
          Text(
            'Total de incidentes registrados',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize * 1.02,
              fontFamily: 'Times New Roman',
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
              '$_totalIncidents',
              style: TextStyle(
                fontSize: fontSize * 1.60,
                fontWeight: FontWeight.w700,
                fontFamily: 'Times New Roman',
                color: _primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSummary(double fontSize) {
    return Row(
      children: [
        Expanded(
          child: _StatusMiniCard(
            count: _statusCounts['Reportado'] ?? 0,
            label: 'Reportado',
            circleColor: const Color(0xFFF47E7E),
            fontSize: fontSize,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatusMiniCard(
            count: _statusCounts['En proceso'] ?? 0,
            label: 'En proceso',
            circleColor: const Color(0xFFF2C45E),
            fontSize: fontSize,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatusMiniCard(
            count: _statusCounts['Resuelto'] ?? 0,
            label: 'Resuelto',
            circleColor: const Color(0xFF7BE48E),
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  Widget _buildStateDistributionCard(double fontSize) {
    final items = [
      _ChartDatum(
        label: 'Reportado',
        value: _statusCounts['Reportado'] ?? 0,
        color: const Color(0xFFF23D3D),
      ),
      _ChartDatum(
        label: 'En proceso',
        value: _statusCounts['En proceso'] ?? 0,
        color: const Color(0xFFF5A400),
      ),
      _ChartDatum(
        label: 'Resuelto',
        value: _statusCounts['Resuelto'] ?? 0,
        color: const Color(0xFF12833A),
      ),
    ];

    return _buildStyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(
            'Distribución por estado',
            fontSize,
            subtitle:
                'Aquí se visualiza el peso de cada estado dentro del total.',
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(165, 165),
                        painter: _PieChartPainter(items: items),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: fontSize * 0.80,
                              fontFamily: 'Times New Roman',
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '$_totalIncidents',
                            style: TextStyle(
                              fontSize: fontSize * 1.20,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w700,
                              color: _textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: items.map((item) {
                    final percent = _totalIncidents == 0
                        ? 0
                        : ((item.value / _totalIncidents) * 100).round();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _LegendTile(
                        color: item.color,
                        label: item.label,
                        valueText: '${item.value} ($percent%)',
                        fontSize: fontSize,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChartCard(double fontSize) {
    return _buildStyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(
            'Incidentes por tipo',
            fontSize,
            subtitle:
                'La gráfica solo muestra los tipos con cantidad mayor que 0.',
          ),
          const SizedBox(height: 12),
          _InteractiveBarChart(
            values: _positiveTypeCounts,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSummaryCard(double fontSize) {
    final orderedEntries = _allTypeCounts.entries.toList();

    return _buildStyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(
            'Cantidad por cada tipo',
            fontSize,
            subtitle:
                'Aquí aparecen todos los tipos, incluso los que están en 0.',
          ),
          const SizedBox(height: 10),
          ...List.generate(orderedEntries.length, (index) {
            final entry = orderedEntries[index];
            final isEven = index.isEven;

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: isEven
                    ? const Color(0xFFF8F8F8)
                    : const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0x11000000),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: fontSize * 0.92,
                        fontFamily: 'Times New Roman',
                        color: _textColor,
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
                      color: const Color(0xFFE7F3E9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0x220C7A27),
                        width: 0.9,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontSize: fontSize * 0.88,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        color: _primaryGreen,
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

  Widget _buildSiteChartCard(double fontSize) {
    return _buildStyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(
            'Incidentes por sede',
            fontSize,
            subtitle:
                'La gráfica muestra únicamente las sedes que tienen incidentes registrados.',
          ),
          const SizedBox(height: 12),
          _InteractiveBarChart(
            values: _positiveSiteCounts,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildSiteSummaryCard(double fontSize) {
    final orderedEntries = _siteCounts.entries.toList();

    return _buildStyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(
            'Cantidad por sede',
            fontSize,
            subtitle:
                'Aquí se muestran todas las sedes, incluso las que tienen 0.',
          ),
          const SizedBox(height: 10),
          ...List.generate(orderedEntries.length, (index) {
            final entry = orderedEntries[index];
            final isEven = index.isEven;

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: isEven
                    ? const Color(0xFFF8F8F8)
                    : const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0x11000000),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: fontSize * 0.92,
                        fontFamily: 'Times New Roman',
                        color: _textColor,
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
                      color: const Color(0xFFE7F3E9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0x220C7A27),
                        width: 0.9,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontSize: fontSize * 0.88,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w700,
                        color: _primaryGreen,
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
}

class _ChartDatum {
  const _ChartDatum({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6B6B6B), width: 0.9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x224FA96A),
            offset: Offset(2, 3),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black54, width: 0.8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: fontSize * 0.78,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize * 0.72,
              fontFamily: 'Times New Roman',
              color: const Color(0xFF222222),
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendTile extends StatelessWidget {
  const _LegendTile({
    required this.color,
    required this.label,
    required this.valueText,
    required this.fontSize,
  });

  final Color color;
  final String label;
  final String valueText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x11000000),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize * 0.80,
                fontFamily: 'Times New Roman',
                color: const Color(0xFF222222),
              ),
            ),
          ),
          Text(
            valueText,
            style: TextStyle(
              fontSize: fontSize * 0.76,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.w700,
              color: const Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveBarChart extends StatefulWidget {
  const _InteractiveBarChart({
    required this.values,
    required this.fontSize,
  });

  final Map<String, int> values;
  final double fontSize;

  @override
  State<_InteractiveBarChart> createState() => _InteractiveBarChartState();
}

class _InteractiveBarChartState extends State<_InteractiveBarChart> {
  int? _activeIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.values.isEmpty) {
      return SizedBox(
        height: 190,
        child: Center(
          child: Text(
            'No hay datos para mostrar.',
            style: TextStyle(
              fontSize: widget.fontSize,
              fontFamily: 'Times New Roman',
              color: const Color(0xFF222222),
            ),
          ),
        ),
      );
    }

    final entries = widget.values.entries.toList();
    final maxValue = entries.map((e) => e.value).reduce(math.max);
    final midValue = (maxValue / 2).ceil();

    return Container(
      height: 245,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x11000000),
          width: 0.8,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minChartWidth = math.max(
            constraints.maxWidth - 34,
            entries.length * 78.0,
          ).toDouble();

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 24,
                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _axisText('$maxValue'),
                    _axisText('$midValue'),
                    _axisText('0'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: minChartWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(entries.length, (index) {
                        final entry = entries[index];
                        final isActive = _activeIndex == index;

                        return Expanded(
                          child: _InteractiveBarItem(
                            label: entry.key,
                            value: entry.value,
                            maxValue: maxValue,
                            fontSize: widget.fontSize,
                            isActive: isActive,
                            onActivate: () {
                              setState(() {
                                _activeIndex =
                                    _activeIndex == index ? null : index;
                              });
                            },
                            onHoverEnter: () {
                              setState(() {
                                _activeIndex = index;
                              });
                            },
                            onHoverExit: () {
                              setState(() {
                                if (_activeIndex == index) {
                                  _activeIndex = null;
                                }
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _axisText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: widget.fontSize * 0.64,
        fontFamily: 'Times New Roman',
        color: Colors.grey.shade700,
      ),
    );
  }
}

class _InteractiveBarItem extends StatelessWidget {
  const _InteractiveBarItem({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.fontSize,
    required this.isActive,
    required this.onActivate,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  final String label;
  final int value;
  final int maxValue;
  final double fontSize;
  final bool isActive;
  final VoidCallback onActivate;
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;

  @override
  Widget build(BuildContext context) {
    final double barMaxHeight = 118;
    final double barHeight =
        maxValue == 0 ? 0 : (value / maxValue) * barMaxHeight;

    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: GestureDetector(
        onTap: onActivate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 50,
                child: isActive
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$label\nCantidad: $value',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSize * 0.66,
                            fontFamily: 'Times New Roman',
                            color: Colors.white,
                            height: 1.05,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 6),
              Container(
                height: 124,
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: isActive ? 30 : 24,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF0C7A27)
                        : const Color(0xFF1A8C39),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isActive
                        ? const [
                            BoxShadow(
                              color: Color(0x334FA96A),
                              blurRadius: 6,
                              offset: Offset(1, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize * 0.62,
                  fontFamily: 'Times New Roman',
                  color: const Color(0xFF222222),
                  height: 1.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.items,
  });

  final List<_ChartDatum> items;

  @override
  void paint(Canvas canvas, Size size) {
    final total = items.fold<int>(0, (sum, item) => sum + item.value);
    if (total == 0) return;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    double startAngle = -math.pi / 2;

    for (final item in items) {
      final sweepAngle = (item.value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = item.color
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

    final holePaint = Paint()
      ..color = const Color(0xFFF2F2F2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.24,
      holePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.items != items;
  }
}