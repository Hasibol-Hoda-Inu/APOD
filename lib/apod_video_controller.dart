import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ApodVideoController extends GetxController{
  bool isInitialized = false;
  VideoPlayerController? vpController;
  ChewieController? chewieController;

  Future<void> initializedPlayer(Uri url)async{
    await _disposeControllers();

    vpController = VideoPlayerController.networkUrl(url);

    try{
      await vpController!.initialize();

      chewieController = ChewieController(videoPlayerController: vpController!,
      autoPlay: true,
        looping: false,
        aspectRatio: vpController!.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
      );
      isInitialized = true;
      update();
    }catch(e){
      debugPrint("Error loading video $e");
    }
  }

  Future<void> _disposeControllers()async{
    chewieController?.dispose();
    await vpController?.dispose();
    isInitialized = false;
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }
}