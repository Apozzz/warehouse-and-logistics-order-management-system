// shared/utils/image_capture.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> captureImage(BuildContext context,
      {ImageSource source = ImageSource.camera}) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } catch (e) {
      print(e);
      // Handle any errors that occur during image capture
      // Optionally, you can display an error message to the user using a dialog or a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image capture failed: $e')),
      );
      return null;
    }
  }
}
