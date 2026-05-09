import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickedXFilePreview extends StatelessWidget {
  const PickedXFilePreview({
    super.key,
    this.file,
    this.assetPath,
    required this.width,
    required this.height,
    this.borderRadius = 14,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  final XFile? file;
  final String? assetPath;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return FutureBuilder<Uint8List>(
        future: file!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _wrap(
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return _fallback();
          }

          return _wrap(
            child: Image.memory(
              snapshot.data!,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (_, __, ___) => _fallback(),
            ),
          );
        },
      );
    }

    if (assetPath != null && assetPath!.trim().isNotEmpty) {
      return _wrap(
        child: Image.asset(
          assetPath!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => _fallback(),
        ),
      );
    }

    return _fallback();
  }

  Widget _wrap({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }

  Widget _fallback() {
    return _wrap(
      child: placeholder ??
          Container(
            width: width,
            height: height,
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.image_outlined,
              size: 34,
              color: Colors.white70,
            ),
          ),
    );
  }
}
