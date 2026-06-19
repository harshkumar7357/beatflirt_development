import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:get_thumbnail_video/src/image_format.dart';
import 'package:image_picker/image_picker.dart';

class VideoThumbnailUtils {
  static Future<String?> generateThumbnail(String videoPath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      
      final XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        quality: 75,
      );
      
      return thumbnailFile.path;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }
}
