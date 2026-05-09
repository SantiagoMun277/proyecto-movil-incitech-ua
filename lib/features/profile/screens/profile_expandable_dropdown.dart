// import 'package:flutter/material.dart';
// import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
// import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

// class ProfileExpandableDropdown extends StatelessWidget {
//   const ProfileExpandableDropdown({
//     super.key,
//     required this.value,
//     required this.items,
//     required this.isExpanded,
//     required this.onTap,
//     required this.onSelected,
//     required this.fontSize,
//   });

//   final String value;
//   final List<String> items;
//   final bool isExpanded;
//   final VoidCallback onTap;
//   final ValueChanged<String> onSelected;
//   final double fontSize;

//   static const Color _fieldColor = AppColors.cardBackground;
//   static const Color _borderColor = AppColors.borderColor;
//   static const Color _textColor = AppColors.textNeutral;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(14),
//           onTap: onTap,
//           child: Container(
//             height: 40,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               color: _fieldColor,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: _borderColor, width: 1),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: fontSize,
//                       fontFamily: AppTextStyles.fontFamily,
//                       color: _textColor,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: AppColors.lightGray,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         offset: Offset(1, 2),
//                         blurRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                     color: Colors.black,
//                     size: 22,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (isExpanded) ...[
//           const SizedBox(height: 6),
//           Container(
//             width: double.infinity,
//             constraints: const BoxConstraints(maxHeight: 330),
//             padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//             decoration: BoxDecoration(
//               color: AppColors.panelNeutral,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: _borderColor, width: 1),
//             ),
//             child: ListView.separated(
//               shrinkWrap: true,
//               itemCount: items.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 6),
//               itemBuilder: (context, index) {
//                 final item = items[index];

//                 return InkWell(
//                   borderRadius: BorderRadius.circular(12),
//                   onTap: () => onSelected(item),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _fieldColor,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: _borderColor, width: 0.9),
//                     ),
//                     child: Text(
//                       item,
//                       style: TextStyle(
//                         fontSize: fontSize,
//                         fontFamily: AppTextStyles.fontFamily,
//                         color: _textColor,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';

class ProfileExpandableDropdown extends StatelessWidget {
  const ProfileExpandableDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.isExpanded,
    required this.onTap,
    required this.onSelected,
    required this.fontSize,
  });

  final String value;
  final List<String> items;
  final bool isExpanded;
  final VoidCallback onTap;
  final ValueChanged<String> onSelected;
  final double fontSize;

  static const Color _fieldColor = AppColors.panelInput;
  static const Color _optionColor = AppColors.softWhite;
  static const Color _selectedColor = AppColors.panelLight;
  static const Color _borderColor = AppColors.borderColor;
  static const Color _textColor = AppColors.textDark;
  static const Color _mutedTextColor = AppColors.textSecondary;
  static const Color _primaryGreen = AppColors.primaryGreen;
  static const Color _primaryGreenDark = AppColors.primaryGreenDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: _primaryGreen.withValues(alpha: 0.08),
          highlightColor: _primaryGreen.withValues(alpha: 0.04),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 46,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: _fieldColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _borderColor.withValues(alpha: 0.45),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowGreen.withValues(alpha: 0.08),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 19,
                    color: _primaryGreenDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.semiBold(
                      fontSize,
                      color: _textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _primaryGreenDark,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 330),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.panelNeutral.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _borderColor.withValues(alpha: 0.45),
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 7),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final selected = item == value;

                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => onSelected(item),
                          splashColor: _primaryGreen.withValues(alpha: 0.08),
                          highlightColor: _primaryGreen.withValues(alpha: 0.04),
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: 40,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected ? _selectedColor : _optionColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? _primaryGreen.withValues(alpha: 0.50)
                                    : _borderColor.withValues(alpha: 0.42),
                                width: selected ? 1.2 : 0.9,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? _primaryGreen.withValues(alpha: 0.14)
                                        : AppColors.panelLight
                                            .withValues(alpha: 0.90),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Icon(
                                    selected
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.circle_outlined,
                                    size: 15,
                                    color: selected
                                        ? _primaryGreenDark
                                        : _mutedTextColor,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: selected
                                        ? AppTextStyles.semiBold(
                                            fontSize,
                                            color: _textColor,
                                          )
                                        : AppTextStyles.regular(
                                            fontSize,
                                            color: _textColor,
                                          ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}