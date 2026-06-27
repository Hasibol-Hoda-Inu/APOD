import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadMediaController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  Future<bool> downLoadMedia(String? url, bool isVideo)async{
    bool isSuccess = false;
    _inProgress = true;
    update();

    try{
      if(url == null) {
        return isSuccess;
      }
      final response = await http.get(Uri.parse(url));
      final tempDir = await getTemporaryDirectory();
      final fileName = url.split("/").last;
      final file = File("${tempDir.path}/$fileName");
      await file.writeAsBytes(response.bodyBytes);

      if(isVideo){
        await Gal.putVideo(file.path);
      }else{
        await Gal.putImage(file.path);
      }

      _inProgress = false;
      isSuccess = true;
      update();

      return isSuccess;
    }catch(e){
      debugPrint("Error: $e");
      return isSuccess;
    }
  }
}