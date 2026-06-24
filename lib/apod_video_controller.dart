import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ApodVideoController extends GetxController{
  bool isInitialized = false;
  VideoPlayerController? vpController;

  Future<void> initializedPlayer(Uri url)async{
    vpController = VideoPlayerController.networkUrl(url);
    try{
      await vpController!.initialize();
      vpController!.setLooping(true);
      vpController!.play();
      isInitialized = true;
      update();
    }catch(e){
      debugPrint("Error loading video $e");
    }
  }

  @override
  void onClose() {
    vpController?.dispose();
    super.onClose();
  }
}