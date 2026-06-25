import 'dart:io';

import 'package:apod/apod_video_controller.dart';
import 'package:apod/get_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

import 'package:get/get.dart';import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                          ElevatedButton.icon(
                              onPressed: (){
                                final String? mediaUrl = data?.hdurl ?? data?.url;
                                bool isVideo = false;

                                if(data?.mediaType == "video") {
                                  isVideo = true;
                                }
                                if(mediaUrl != null){
                                  downLoadMedia(mediaUrl, isVideo);
                                }
                              },
                              icon: Icon(Icons.download),
                              label: Text("Download Media")
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              text: "Explanation: ",
                              children: <TextSpan>[
                                TextSpan(
                                  style: TextStyle(fontWeight: FontWeight.normal),
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

  Future<void> getApod() async {
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

  Future<void> downLoadMedia(String url, bool isVideo)async{
    try{
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
      
      Get.snackbar("Success", "Saved to gallery successfully!");
    }catch(e){
      Get.snackbar("Error", "Failed to save media: $e");
    }
  }
}
