import 'dart:io';

import 'package:flutter/material.dart';

class IncidentImage extends StatelessWidget {
  const IncidentImage({
    super.key,
    required this.imagePath,
    this.width = 108,
    this.height = 118,
    this.borderRadius = 18,
  });

  final String? imagePath;
  final double width;
  final double height;
  final double borderRadius;

  static const String _errorAsset = 'assets/images/ErrorImagen.png';

  bool _isLocalFilePath(String path) {
    return path.startsWith('/') || path.startsWith('file://');
  }

  Widget _buildFallback() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFFE4E4E4),
        child: Image.asset(
          _errorAsset,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.white70,
                size: 34,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.trim().isEmpty) {
      return _buildFallback();
    }

    final path = imagePath!.trim();

    final imageWidget = _isLocalFilePath(path)
        ? Image.file(
            File(path),
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFallback(),
          )
        : Image.asset(
            path,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFallback(),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFFE4E4E4),
        child: imageWidget,
      ),
    );
  }
}