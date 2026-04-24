import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> takePhoto() async {
    return _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
  }

  Future<XFile?> pickFromGallery() async {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
  }

  Future<List<XFile>> retrieveLostImages() async {
    final LostDataResponse response = await _picker.retrieveLostData();

    if (response.isEmpty) {
      return [];
    }

    if (response.files != null && response.files!.isNotEmpty) {
      return response.files!;
    }

    if (response.file != null) {
      return [response.file!];
    }

    return [];
  }
}