//import 'package:cloudinary_client/cloudinary_client.dart';
//import 'package:cloudinary_client/models/CloudinaryResponse.dart';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ImagesProvider with ChangeNotifier {
  var logger = Logger();
  Future<String> uploadPhoto(String _imagePath, String name) async {
    String res;
    try {
      logger.d("Trying to update student photo:");

      CloudinaryPublic client =
          new CloudinaryPublic('mym', 'mymPicture', cache: false);
      CloudinaryResponse response = await client.uploadFile(
          CloudinaryFile.fromFile(_imagePath,
              resourceType: CloudinaryResourceType.Image));
      res = response.url;
    } catch (err) {
      logger.e("Error AutoLogin 203: " + err.toString());
      res = null;
    }
    return res;
  }
}
