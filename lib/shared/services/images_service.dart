import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String path) async {
    Reference ref = _storage.ref().child(path);
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() => {});
    return await ref.getDownloadURL();
  }

  Future<String> saveImage(Uint8List imageBytes, String storagePath) async {
    // Save the image to a temporary file
    File tempImageFile = File(
        '${(await getTemporaryDirectory()).path}/temp_map_${DateTime.now().millisecondsSinceEpoch}.png');
    await tempImageFile.writeAsBytes(imageBytes);

    // Upload image to Firebase Storage and return the download URL
    return await uploadImage(tempImageFile, storagePath);
  }
}
