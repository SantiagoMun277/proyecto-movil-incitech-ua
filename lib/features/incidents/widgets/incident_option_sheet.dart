import 'package:flutter/material.dart';

class IncidentOptionSheet {
  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String selectedValue,
    required List<String> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _IncidentOptionSheetView(
          title: title,
          selectedValue: selectedValue,
          options: options,
        );
      },
    );
  }
}

class _IncidentOptionSheetView extends StatelessWidget {
  const _IncidentOptionSheetView({
    required this.title,
    required this.selectedValue,
    required this.options,
  });

  final String title;
  final String selectedValue;
  final List<String> options;

  static const Color _sheetColor = Color(0xFFEDEDED);
  static const Color _fieldColor = Color(0xFFF7F7F7);
  static const Color _textColor = Color(0xFF222222);
  static const Color _borderColor = Color(0xFF606060);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontSize = w * 0.040;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
        decoration: BoxDecoration(
          color: _sheetColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: fontSize * 1.05,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w700,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _fieldColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedValue,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'Times New Roman',
                        color: _textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 28),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 360),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              decoration: BoxDecoration(
                color: _sheetColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2196F3), width: 2),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final item = options[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context, item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: _fieldColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _borderColor, width: 1),
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
        ),
      ),
    );
  }
}