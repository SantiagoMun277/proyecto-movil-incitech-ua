import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageUploadResult {
  const StorageUploadResult({
    required this.downloadUrl,
    required this.storagePath,
    required this.fileName,
  });

  final String downloadUrl;
  final String storagePath;
  final String fileName;
}

class StorageService {
  StorageService();

  static const String _bucket =
      'gs://proyecto-movil-incitech-ua.firebasestorage.app';

  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: _bucket,
  );

  Future<StorageUploadResult> uploadIncidentImage({
    required XFile file,
    required String uid,
  }) async {
    final Uint8List bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw Exception('La imagen está vacía o no se pudo leer.');
    }

    final extension = _extractExtension(file.name.isNotEmpty ? file.name : file.path);
    final fileName = 'inc_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final storagePath = 'incidentes/$uid/$fileName';

    final ref = _storage.ref().child(storagePath);

    final metadata = SettableMetadata(
      contentType: _resolveContentType(extension),
    );

    final taskSnapshot = await ref.putData(bytes, metadata);
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return StorageUploadResult(
      downloadUrl: downloadUrl,
      storagePath: storagePath,
      fileName: fileName,
    );
  }

  String _extractExtension(String path) {
    final lowerPath = path.toLowerCase();

    if (lowerPath.endsWith('.png')) return 'png';
    if (lowerPath.endsWith('.webp')) return 'webp';
    if (lowerPath.endsWith('.jpeg')) return 'jpeg';
    if (lowerPath.endsWith('.jpg')) return 'jpg';

    return 'jpg';
  }

  String _resolveContentType(String extension) {
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'jpeg':
        return 'image/jpeg';
      case 'jpg':
      default:
        return 'image/jpeg';
    }
  }
}
