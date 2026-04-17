import 'package:flutter/material.dart';

class IncidentImage extends StatelessWidget {
  const IncidentImage({
    super.key,
    required this.imagePath,
  });

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 72,
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFFD1D1D1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.image_outlined,
        color: Colors.white70,
        size: 28,
      ),
    );

    if (imagePath == null || imagePath!.isEmpty) {
      return placeholder;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imagePath!,
        width: 72,
        height: 92,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      ),
    );
  }
}