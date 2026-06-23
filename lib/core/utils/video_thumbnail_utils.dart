import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:get_thumbnail_video/src/image_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class VideoThumbnailUtils {
  static Future<String?> generateThumbnail(String videoPath) async {
    File? tempVideoFile;
    try {
      final tempDir = await getTemporaryDirectory();
      String resolvedPath = videoPath;

      // If it is a network URL, download the file first to bypass seek/MediaHTTPConnection issues
      if (videoPath.startsWith('http://') || videoPath.startsWith('https://')) {
        final response = await http.get(Uri.parse(videoPath));
        if (response.statusCode == 200) {
          final tempFile = File('${tempDir.path}/temp_video_${DateTime.now().millisecondsSinceEpoch}.mp4');
          await tempFile.writeAsBytes(response.bodyBytes);
          tempVideoFile = tempFile;
          resolvedPath = tempFile.path;
        } else {
          print('Failed to download video for thumbnail: HTTP ${response.statusCode}');
          return null;
        }
      }

      final XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
        video: resolvedPath,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        quality: 75,
      );

      // Clean up the temporary video file if downloaded
      if (tempVideoFile != null && await tempVideoFile.exists()) {
        await tempVideoFile.delete();
      }

      return thumbnailFile.path;
    } catch (e) {
      print('Error generating thumbnail: $e');
      // Clean up the temporary video file if downloaded in case of error
      if (tempVideoFile != null && await tempVideoFile.exists()) {
        try {
          await tempVideoFile.delete();
        } catch (_) {}
      }
      return null;
    }
  }
}
