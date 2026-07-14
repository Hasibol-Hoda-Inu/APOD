import 'package:apod/data_model/apod_model.dart';
import 'package:apod/ui/controllers/apod_video_controller.dart';
import 'package:apod/ui/controllers/download_media_controller.dart';
import 'package:apod/ui/controllers/get_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getApod();
  }

  GetController callData = Get.find<GetController>();
  ApodVideoController callVideo = Get.find<ApodVideoController>();
  DownloadMediaController dmController = Get.find<DownloadMediaController>();
  ApodModel data = ApodModel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<GetController>(
          builder: (controller) {
            if (controller.inProgress) {
              return Center(child: CircularProgressIndicator());
            }
            final data = controller.apodModel;
            return RefreshIndicator(
              onRefresh: getApod,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    data?.mediaType == "image"
                        ? Image.network(
                            data?.hdurl ??
                                data?.url ??
                                "https://apod.nasa.gov/apod/image/2606/R3Tails_Kurak_960.jpg",
                          )
                        : GetBuilder<ApodVideoController>(
                            builder: (vController) {
                              if (vController.isInitialized &&
                                  vController.chewieController != null) {
                                return AspectRatio(
                                  aspectRatio:
                                      vController.vpController!.value.aspectRatio,
                                  child: Chewie(
                                    controller: vController.chewieController!,
                                  ),
                                );
                              }
                              return Container(
                                color: Colors.grey.shade300,
                                height: 300,
                              );
                            },
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            data?.title ?? "",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text("Date: ${data?.date}"),
                          const SizedBox(height: 20),
                          GetBuilder<DownloadMediaController>(
                            builder: (controller){
                              if(controller.inProgress){
                                return Center(child: CircularProgressIndicator());
                              }
                               return ElevatedButton.icon(
                                    onPressed: saveGal,
                                    icon: Icon(Icons.download),
                                    label: Text("Download Media"),
                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.black87,
                                   foregroundColor: Colors.white,
                                 ),
                                );
                            },
                          ),
                          const SizedBox(height: 10,),
                          Text.rich(
                            textAlign: TextAlign.justify,
                            TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              text: "Explanation: ",
                              children: <TextSpan>[
                                TextSpan(
                                  style: TextStyle(fontWeight: FontWeight.normal,),
                                  text: data?.explanation ?? "Explanation",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> getApod() async{
    bool isSuccess = await callData.getData();
    if (isSuccess) {
      if (callData.apodModel!.mediaType == "video") {
        Uri url = Uri.parse(callData.apodModel!.url!);
        await callVideo.initializedPlayer(url);
      }
      debugPrint("✅ Success");
    } else {
      debugPrint("❎ Fail");
    }
  }

  Future<void> saveGal()async{
    ApodModel? apodData = callData.apodModel;
    if(apodData == null){
      Get.snackbar("❌Empty: ", "No picture url found");
    }
    else{
      final String? mediaUrl = apodData.hdurl ?? apodData.url;
      bool isVideo = false;
      if (data.mediaType == "video") {
        isVideo = true;
      }

      bool isSuccess = await dmController.downLoadMedia(mediaUrl, isVideo);

      if (isSuccess) {
        Get.snackbar("✅ Success", "Saved to gallery successfully!",
            backgroundColor: Colors.white,
            duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar("❌ Error", "Failed to save media");
      }
    }
  }
}
