import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageHandler {
  static Future<File?> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        if (await _validateImage(file)) {
          return file;
        } else {
          throw Exception('Invalid file format or size. Please upload an image less than 300KB in JPG or PNG format.');
        }
      }
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
    return null;
  }

  static Future<bool> _validateImage(File file) async {
    final fileExtension = file.path.split('.').last.toLowerCase();
    final fileSize = await file.length();
    if ((fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') && fileSize <= 300 * 1024) {
      return true;
    }
    return false;
  }
}
