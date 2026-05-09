import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
import 'package:my_app_incitech_ua/features/incidents/models/incident_item.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/incident_card.dart';
import 'package:my_app_incitech_ua/services/incident_service.dart';
import 'package:my_app_incitech_ua/shared/widgets/app_bottom_nav.dart';

class IncidentListBaseScreen extends StatefulWidget {
  const IncidentListBaseScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.headerIcon,
    required this.bottomNavIndex,
    required this.detailRouteName,
    required this.onlyCurrentUser,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyButtonText,
  });

  final String title;
  final String subtitle;
  final IconData headerIcon;
  final int bottomNavIndex;
  final String detailRouteName;
  final bool onlyCurrentUser;
  final String emptyTitle;
  final String emptyMessage;
  final String emptyButtonText;

  @override
  State<IncidentListBaseScreen> createState() => _IncidentListBaseScreenState();
}

class _IncidentListBaseScreenState extends State<IncidentListBaseScreen> {
  static const Color _backgroundColor = AppColors.backgroundGreen;
  static const Color _cardColor = AppColors.softWhite;
  static const Color _primaryGreen = AppColors.primaryGreen;
  static const Color _primaryGreenDark = AppColors.primaryGreenDark;
  static const Color _textColor = AppColors.textDark;
  static const Color _searchHintColor = AppColors.textMuted;
  static const Color _borderColor = AppColors.borderColor;

  final TextEditingController _searchController = TextEditingController();
  final IncidentService _incidentService = IncidentService();

  IncidentListFilter _selectedFilter = IncidentListFilter.todos;

  Stream<List<IncidentItem>>? _incidentsStream;
  String? _currentStreamKey;
  int _refreshVersion = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<IncidentItem>> _getIncidentsStream(String? uid) {
    final streamKey = widget.onlyCurrentUser ? uid : 'all-incidents';

    if (_incidentsStream == null || _currentStreamKey != streamKey) {
      _currentStreamKey = streamKey;

      if (widget.onlyCurrentUser) {
        _incidentsStream = _incidentService.streamMyIncidents(uid!);
      } else {
        _incidentsStream = _incidentService.streamIncidents();
      }
    }

    return _incidentsStream!;
  }

  void _forceRefreshList() {
    setState(() {
      _incidentsStream = null;
      _currentStreamKey = null;
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
        IncidentListFilter.todos => true,
        IncidentListFilter.reportado =>
          incident.status == IncidentStatus.reportado,
        IncidentListFilter.enProceso =>
          incident.status == IncidentStatus.enProceso,
        IncidentListFilter.resuelto =>
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
      widget.detailRouteName,
      arguments: {
        'incident': incident,
        'canEditStatus': false,
      },
    );

    if (!mounted) return;
    _forceRefreshList();
  }

  String _filterLabel(IncidentListFilter filter) {
    switch (filter) {
      case IncidentListFilter.todos:
        return 'Todos';
      case IncidentListFilter.reportado:
        return 'Reportado';
      case IncidentListFilter.enProceso:
        return 'En Proceso';
      case IncidentListFilter.resuelto:
        return 'Resuelto';
    }
  }

  IconData _filterIcon(IncidentListFilter filter) {
    switch (filter) {
      case IncidentListFilter.todos:
        return Icons.list_alt_rounded;
      case IncidentListFilter.reportado:
        return Icons.error_outline_rounded;
      case IncidentListFilter.enProceso:
        return Icons.pending_actions_rounded;
      case IncidentListFilter.resuelto:
        return Icons.check_circle_outline_rounded;
    }
  }

  Color _filterColor(IncidentListFilter filter) {
    switch (filter) {
      case IncidentListFilter.todos:
        return AppColors.chipGreen;
      case IncidentListFilter.reportado:
        return AppColors.chipRed;
      case IncidentListFilter.enProceso:
        return AppColors.chipYellow;
      case IncidentListFilter.resuelto:
        return AppColors.chipGreen;
    }
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
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.white,
          size: 34,
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: widget.bottomNavIndex),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            final fontSize = (w * 0.038).clamp(13.0, 16.0).toDouble();
            final logoWidth = (w * 0.58).clamp(190.0, 270.0).toDouble();

            if (widget.onlyCurrentUser && uid == null) {
              return _buildStateMessage(
                icon: Icons.lock_outline_rounded,
                title: 'Sesión no encontrada',
                message: 'Debes iniciar sesión para ver tus incidentes.',
                fontSize: fontSize,
              );
            }

            return Column(
              children: [
                SizedBox(height: h * 0.012),
                Image.asset(
                  'assets/images/logo_incitech.png',
                  width: logoWidth,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: h * 0.012),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: _buildHeaderCard(
                    title: widget.title,
                    subtitle: widget.subtitle,
                    icon: widget.headerIcon,
                    fontSize: fontSize,
                  ),
                ),
                SizedBox(height: h * 0.014),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: _buildSearchBox(fontSize),
                ),
                SizedBox(height: h * 0.014),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: _buildFilterCard(fontSize),
                ),
                SizedBox(height: h * 0.014),
                Expanded(
                  child: StreamBuilder<List<IncidentItem>>(
                    key: ValueKey(
                      'incident-list-${widget.onlyCurrentUser}-$uid-$_refreshVersion',
                    ),
                    stream: _getIncidentsStream(uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildStateMessage(
                          icon: Icons.error_outline_rounded,
                          title: 'Error al cargar los incidentes',
                          message:
                              'Intenta nuevamente más tarde o revisa tu conexión.',
                          fontSize: fontSize,
                        );
                      }

                      final allIncidents = snapshot.data ?? [];
                      final incidents = _applyFilters(allIncidents);

                      if (allIncidents.isEmpty) {
                        return _buildEmptyState(
                          title: widget.emptyTitle,
                          message: widget.emptyMessage,
                          buttonText: widget.emptyButtonText,
                          fontSize: fontSize,
                          onPressed: _goToCreateIncident,
                        );
                      }

                      if (incidents.isEmpty) {
                        return _buildStateMessage(
                          icon: Icons.filter_alt_off_outlined,
                          title: 'Sin coincidencias',
                          message:
                              'No hay incidentes que coincidan con la búsqueda o el filtro aplicado.',
                          fontSize: fontSize,
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          w * 0.04,
                          0,
                          w * 0.04,
                          h * 0.02,
                        ),
                        itemCount: incidents.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: h * 0.014),
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

  Widget _buildHeaderCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required double fontSize,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowGreen.withValues(alpha: 0.18),
            offset: const Offset(0, 6),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _primaryGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: _primaryGreenDark,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.extraBold(
                    fontSize * 1.18,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.regular(
                    fontSize * 0.88,
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

  Widget _buildSearchBox(double fontSize) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowGreen.withValues(alpha: 0.10),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: AppTextStyles.regular(
          fontSize,
          color: _textColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _primaryGreenDark,
          ),
          suffixIcon: _searchController.text.trim().isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
          hintText: 'Buscar incidente',
          hintStyle: AppTextStyles.regular(
            fontSize,
            color: _searchHintColor,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }

  Widget _buildFilterCard(double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowGreen.withValues(alpha: 0.10),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterTitle(fontSize),
          const SizedBox(height: 9),
          _buildFilterDropdown(fontSize),
        ],
      ),
    );
  }

  Widget _buildFilterTitle(double fontSize) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: _primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.filter_alt_outlined,
            size: 18,
            color: _primaryGreenDark,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          'Filtrar por estado',
          style: AppTextStyles.extraBold(
            fontSize * 1.02,
            color: _textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(double fontSize) {
    return PopupMenuButton<IncidentListFilter>(
      onSelected: (filter) {
        setState(() {
          _selectedFilter = filter;
        });
      },
      color: _cardColor,
      elevation: 4,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _borderColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      itemBuilder: (context) {
        return IncidentListFilter.values.map((filter) {
          final selected = _selectedFilter == filter;

          return PopupMenuItem<IncidentListFilter>(
            value: filter,
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: _filterColor(filter),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.borderDark,
                      width: 0.7,
                    ),
                  ),
                  child: Icon(
                    _filterIcon(filter),
                    size: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    _filterLabel(filter),
                    style: AppTextStyles.semiBold(
                      fontSize * 0.95,
                      color: _textColor,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: _primaryGreenDark,
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 42),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.panelInput,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _borderColor.withValues(alpha: 0.38),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _filterIcon(_selectedFilter),
              size: 18,
              color: _primaryGreenDark,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                _filterLabel(_selectedFilter),
                style: AppTextStyles.semiBold(
                  fontSize,
                  color: _textColor,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _primaryGreenDark,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String message,
    required String buttonText,
    required double fontSize,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _borderColor.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _primaryGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.report_problem_outlined,
                  size: 32,
                  color: _primaryGreenDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.extraBold(
                  fontSize * 1.05,
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
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    buttonText,
                    style: AppTextStyles.button(fontSize),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _borderColor.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
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

enum IncidentListFilter {
  todos,
  reportado,
  enProceso,
  resuelto,
}