import 'package:apod/api_service.dart';
import 'package:apod/apod_video_controller.dart';
import 'package:apod/get_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(GetController());
    Get.put(NetworkCaller());
    Get.put(ApodVideoController());
  }

}