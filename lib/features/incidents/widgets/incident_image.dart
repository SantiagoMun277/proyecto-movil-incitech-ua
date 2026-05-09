import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';

class IncidentImage extends StatefulWidget {
  const IncidentImage({
    super.key,
    required this.imagePath,
    this.width = 82,
    this.height = 82,
    this.fit = BoxFit.cover,
  });

  final String? imagePath;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  State<IncidentImage> createState() => _IncidentImageState();
}

class _IncidentImageState extends State<IncidentImage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Map<String, Future<Uint8List>> _firebaseImageCache = {};
  final Map<String, Future<Uint8List>> _networkImageCache = {};

  bool _isNetworkImage(String path) {
    final value = path.trim();
    final uri = Uri.tryParse(value);

    return uri != null && uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  bool _isFirebaseStorageUrl(String path) {
    final value = path.toLowerCase().trim();
    return value.startsWith('gs://') ||
        value.contains('firebasestorage.googleapis.com') ||
        value.contains('storage.googleapis.com');
  }

  bool _isFirebaseStorageRelativePath(String path) {
    final value = path.trim();
    if (value.isEmpty) return false;

    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) return false;

    return !value.startsWith('/') &&
        !value.startsWith('file://') &&
        !value.startsWith('assets/') &&
        !value.startsWith('package:') &&
        !value.startsWith('data:') &&
        (value.startsWith('incidentes/') ||
            value.contains('/incidentes/'));
  }

  bool _isLocalFilePath(String path) {
    final value = path.trim();
    return value.startsWith('/') || value.startsWith('file://');
  }

  bool _isFirebaseDownloadUrl(Uri uri) {
    return uri.isAbsolute &&
        (uri.host.contains('firebasestorage.googleapis.com') ||
            uri.host.contains('storage.googleapis.com'));
  }

  String? _extractStoragePathFromDownloadUrl(Uri uri) {
    if (!_isFirebaseDownloadUrl(uri)) return null;

    final segments = uri.pathSegments;
    final index = segments.indexOf('o');
    if (index < 0 || index + 1 >= segments.length) {
      return null;
    }

    final encodedPath = segments.sublist(index + 1).join('/');
    final decodedPath = Uri.decodeFull(encodedPath);
    return decodedPath;
  }

  Future<Uint8List> _getFirebaseImageBytes(String rawPath) async {
    final value = rawPath.trim();
    final normalized = Uri.tryParse(value)?.toString() ?? value;
    final uri = Uri.tryParse(normalized);

    debugPrint('_getFirebaseImageBytes llamado con: $rawPath');

    try {
      Reference ref;

      if (_isFirebaseStorageUrl(normalized)) {
        if (uri != null && uri.scheme == 'gs') {
          ref = FirebaseStorage.instance.refFromURL(normalized);
          debugPrint('Referencia Firebase gs: ${ref.fullPath}');
        } else if (uri != null && _isFirebaseDownloadUrl(uri)) {
          final storagePath = _extractStoragePathFromDownloadUrl(uri);
          if (storagePath != null && storagePath.isNotEmpty) {
            ref = FirebaseStorage.instance.ref(storagePath);
            debugPrint('Referencia Firebase download: ${ref.fullPath}');
          } else {
            throw Exception('No se pudo extraer path de download URL');
          }
        } else {
          ref = FirebaseStorage.instance.refFromURL(normalized);
          debugPrint('Referencia Firebase other: ${ref.fullPath}');
        }
      } else {
        final targetPath = normalized.startsWith('/')
            ? normalized.substring(1)
            : normalized;
        ref = FirebaseStorage.instance.ref(targetPath);
        debugPrint('Referencia Firebase relative: ${ref.fullPath}');
      }

      final bytes = await ref.getData();
      if (bytes == null) {
        throw Exception('Bytes nulos de Firebase Storage');
      }

      debugPrint('Bytes obtenidos: ${bytes.length}');
      return bytes;
    } on FirebaseException catch (error) {
      debugPrint('ERROR Firebase: $error');
      rethrow;
    }
  }

  Future<Uint8List> _fetchNetworkImageBytes(String url) async {
    debugPrint('Descargando bytes desde: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw HttpException(
        'HTTP ${response.statusCode} for $url',
        uri: Uri.parse(url),
      );
    }

    debugPrint('Bytes descargados: ${response.bodyBytes.length} bytes');
    return response.bodyBytes;
  }

  Future<Uint8List> _getCachedFirebaseImageBytes(String path) {
    return _firebaseImageCache.putIfAbsent(path, () => _getFirebaseImageBytes(path));
  }

  Future<Uint8List> _getCachedNetworkImageBytes(String url) {
    return _networkImageCache.putIfAbsent(url, () => _fetchNetworkImageBytes(url));
  }

  Widget _box({required Widget child}) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _placeholder() {
    return _box(
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 30,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _loading() {
    return _box(
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _error() {
    return _box(
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 30,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final path = widget.imagePath?.trim();

    debugPrint('IncidentImage build: path="$path"');

    if (path == null || path.isEmpty) {
      debugPrint('IncidentImage: path vacío, mostrando placeholder');
      return _placeholder();
    }

    if (_isNetworkImage(path) && !_isFirebaseStorageUrl(path)) {
      debugPrint('IncidentImage: imagen de red no Firebase, usando CachedNetworkImage');
      return _box(
        child: CachedNetworkImage(
          imageUrl: Uri.tryParse(path)?.toString() ?? path,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          placeholder: (context, url) => _loading(),
          errorWidget: (context, url, error) => _error(),
        ),
      );
    }

    if (_isFirebaseStorageUrl(path) || _isFirebaseStorageRelativePath(path)) {
      debugPrint('IncidentImage: imagen Firebase, usando cache');
      return FutureBuilder<Uint8List>(
        future: _getCachedFirebaseImageBytes(path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loading();
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            debugPrint('IncidentImage: error en FutureBuilder: ${snapshot.error}');
            return _error();
          }

          final bytes = snapshot.data!;

          debugPrint('IncidentImage: bytes obtenidos, mostrando imagen');
          return _box(
            child: Image.memory(
              bytes,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              errorBuilder: (context, error, stackTrace) {
                return _error();
              },
            ),
          );
        },
      );
    }

    if (_isLocalFilePath(path)) {
      return _box(
        child: Image.file(
          File(path.replaceFirst('file://', '')),
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) {
            return _error();
          },
        ),
      );
    }

    return _box(
      child: Image.asset(
        path,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) {
          return _error();
        },
      ),
    );
  }
}
