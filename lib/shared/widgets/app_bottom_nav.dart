// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
// import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
// import 'package:my_app_incitech_ua/app/routes/app_routes.dart';

// class AppBottomNav extends StatelessWidget {
//   const AppBottomNav({
//     super.key,
//     required this.currentIndex,
//   });

//   final int currentIndex;

//   static const Color _primaryGreen = AppColors.primaryGreenAlt;

//   void _onTap(BuildContext context, int index) {
//     if (index == currentIndex) return;

//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, AppRoutes.incidentsHome);
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, AppRoutes.myIncidents);
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, AppRoutes.statistics);
//         break;
//       case 3:
//         Navigator.pushReplacementNamed(context, AppRoutes.profile);
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: (index) => _onTap(context, index),
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: _primaryGreen,
//       unselectedItemColor: Colors.grey,
//       backgroundColor: AppColors.panelLight,
//       selectedLabelStyle: const TextStyle(
//         fontFamily: AppTextStyles.fontFamily,
//         fontWeight: FontWeight.w600,
//         fontSize: 12,
//       ),
//       unselectedLabelStyle: const TextStyle(
//         fontFamily: AppTextStyles.fontFamily,
//         fontSize: 12,
//       ),
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           activeIcon: Icon(Icons.home),
//           label: 'Inicio',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.description_outlined),
//           activeIcon: Icon(Icons.description),
//           label: 'Incidentes',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.bar_chart_outlined),
//           activeIcon: Icon(Icons.bar_chart),
//           label: 'Estadísticas',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           activeIcon: Icon(Icons.person),
//           label: 'Perfil',
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/app/routes/app_routes.dart';
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  static const Color _primaryGreen = AppColors.primaryGreenAlt;
  static const Color _primaryGreenDark = AppColors.primaryGreenAltDark;
  static const Color _barColor = AppColors.softWhite;
  static const Color _textColor = AppColors.textDark;
  static const Color _mutedColor = AppColors.textSecondary;
  static const Color _borderColor = AppColors.borderColor;

  static const List<_BottomNavDestination> _items = [
    _BottomNavDestination(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _BottomNavDestination(
      label: 'Incidentes',
      icon: Icons.description_outlined,
      activeIcon: Icons.description_rounded,
    ),
    _BottomNavDestination(
      label: 'Estadísticas',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
    ),
    _BottomNavDestination(
      label: 'Perfil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.incidentsHome);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.myIncidents);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.statistics);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeIndex =
        currentIndex >= 0 && currentIndex < _items.length ? currentIndex : 0;

    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = (screenWidth * 0.026).clamp(9.8, 11.2).toDouble();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        child: Container(
          height: 78,
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: _barColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: _borderColor.withValues(alpha: 0.38),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowGreen.withValues(alpha: 0.20),
                offset: const Offset(0, 6),
                blurRadius: 16,
              ),
            ],
          ),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = index == safeIndex;

              return Expanded(
                child: _BottomNavButton(
                  item: item,
                  selected: selected,
                  fontSize: fontSize,
                  onTap: () => _onTap(context, index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.fontSize,
    required this.onTap,
  });

  final _BottomNavDestination item;
  final bool selected;
  final double fontSize;
  final VoidCallback onTap;

  static const Color _primaryGreen = AppColors.primaryGreenAlt;
  static const Color _primaryGreenDark = AppColors.primaryGreenAltDark;
  static const Color _textColor = AppColors.textDark;
  static const Color _mutedColor = AppColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: _primaryGreen.withValues(alpha: 0.08),
          highlightColor: _primaryGreen.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? _primaryGreen.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: selected
                  ? Border.all(
                      color: _primaryGreen.withValues(alpha: 0.22),
                      width: 1,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: selected ? 32 : 28,
                  height: selected ? 24 : 23,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? _primaryGreen.withValues(alpha: 0.16)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    selected ? item.activeIcon : item.icon,
                    color: selected ? _primaryGreenDark : _mutedColor,
                    size: selected ? 21 : 20,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 15,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: selected
                          ? AppTextStyles.extraBold(
                              fontSize,
                              color: _textColor,
                            ).copyWith(height: 1.0)
                          : AppTextStyles.semiBold(
                              fontSize,
                              color: _mutedColor,
                            ).copyWith(height: 1.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavDestination {
  const _BottomNavDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}