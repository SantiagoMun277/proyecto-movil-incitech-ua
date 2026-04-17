import 'package:flutter/material.dart';

class StatisticsExpandableDropdown extends StatelessWidget {
  const StatisticsExpandableDropdown({
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

  static const Color _fieldColor = Color(0xFFF4F4F4);
  static const Color _borderColor = Color(0xFF6A6A6A);
  static const Color _textColor = Color(0xFF2A2A2A);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: _fieldColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'Times New Roman',
                      color: _textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = items[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelected(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _fieldColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColor, width: 0.9),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'Times New Roman',
                        color: _textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}