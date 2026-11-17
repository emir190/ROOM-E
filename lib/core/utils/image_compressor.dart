import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageCompressor {
  ImageCompressor._();

  /// Compresses an image file to max 1080px dimension with 80% JPEG quality.
  static Future<File?> compressImageFile(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/${const Uuid().v4()}_compressed.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
        minWidth: 1080,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );

      if (result == null) return null;
      return File(result.path);
    } catch (_) {
      // Fallback to original file if compression native channel fails in tests/desktop
      return file;
    }
  }

  /// Compresses raw image bytes to max 1080px dimension with 80% JPEG quality.
  static Future<Uint8List> compressBytes(Uint8List list) async {
    try {
      final result = await FlutterImageCompress.compressWithList(
        list,
        quality: 80,
        minWidth: 1080,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );
      return result;
    } catch (_) {
      return list;
    }
  }
}
