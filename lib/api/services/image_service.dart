import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:cloudinary_client/models/CloudinaryResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ImagesProvider with ChangeNotifier {
  var logger = Logger();
  Future<String> uploadPhoto(String path, String name) async {
    String res;
    try {
      logger.d("Trying to update student photo:");

      CloudinaryClient client = new CloudinaryClient(
          '153744774915444', '5jmFauhiJoIhHlxa1HKD7d0vKy8', 'mym');
      CloudinaryResponse response =
          await client.uploadImage(path, filename: name, folder: 'mym/');
      res = response.url;
    } catch (err) {
      logger.e("Error AutoLogin 203: " + err.toString());
      res = null;
    }
    return res;
  }
}
