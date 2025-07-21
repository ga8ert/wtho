import 'dart:io';
import 'package:image/image.dart' as img;

/// Compresses and resizes the image to maxWidth/maxHeight and [quality] (0-100).
/// Returns a new (temporary) file.
Future<File> compressImageFile(
  File file, {
  int maxWidth = 400,
  int maxHeight = 400,
  int quality = 70,
}) async {
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);
  if (image == null) throw Exception('Cannot decode image');

  // Resize if needed
  final resized = img.copyResize(
    image,
    width: image.width > maxWidth ? maxWidth : null,
    height: image.height > maxHeight ? maxHeight : null,
  );

  // Compress to JPEG
  final jpg = img.encodeJpg(resized, quality: quality);

  // Write to a temporary file
  final tempDir = Directory.systemTemp;
  final tempFile = await File(
    '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
  ).create();
  await tempFile.writeAsBytes(jpg);

  return tempFile;
}
