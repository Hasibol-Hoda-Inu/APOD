import 'package:apod/services/api_service.dart';
import 'package:apod/ui/controllers/apod_video_controller.dart';
import 'package:apod/ui/controllers/get_controller.dart';
import 'package:get/get.dart';

import '../ui/controllers/download_media_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(GetController());
    Get.put(NetworkCaller());
    Get.put(ApodVideoController());
    Get.put(DownloadMediaController());
  }

}