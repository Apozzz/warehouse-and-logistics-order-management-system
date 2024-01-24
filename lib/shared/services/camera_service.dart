import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> captureImage({ImageSource source = ImageSource.camera}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> captureVideo({ImageSource source = ImageSource.camera}) async {
    final pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
