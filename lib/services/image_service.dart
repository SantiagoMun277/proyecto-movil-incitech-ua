

import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> takePhoto() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
      );
    } catch (e) {
      throw Exception('No se pudo tomar la fotografía: $e');
    }
  }

  Future<XFile?> pickFromGallery() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
      );
    } catch (e) {
      throw Exception('No se pudo seleccionar la imagen: $e');
    }
  }

  Future<List<XFile>> retrieveLostImages() async {
    try {
      final lostData = await _picker.retrieveLostData();
      if (lostData.isEmpty || lostData.file == null) return [];
      return [lostData.file!];
    } catch (e) {
      throw Exception('No se pudieron recuperar imágenes perdidas: $e');
    }
  }

  bool hasImage(XFile? file) {
    return file != null && file.path.trim().isNotEmpty;
  }
}
