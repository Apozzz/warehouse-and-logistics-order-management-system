import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String> uploadImage(File image, String path) async {
    Reference ref = _storage.ref().child(path);
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() => {});
    return await ref.getDownloadURL();
  }
}
