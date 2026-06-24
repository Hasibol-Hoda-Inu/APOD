import 'package:apod/apod_video_controller.dart';
import 'package:apod/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

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
    return Scaffold(
      body: GetBuilder<GetController>(
        builder: (controller) {
          if (controller.inProgress) {
            return Center(child: CircularProgressIndicator());
          }
          final data = controller.apodModel;
          return Column(
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
                            vController.vpController != null) {
                          return AspectRatio(
                            aspectRatio:
                                vController.vpController!.value.aspectRatio,
                            child: VideoPlayer(vController.vpController!),
                          );
                        }
                        return Container(
                          color: Colors.grey.shade300,
                          height: 300,
                        );
                      },
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      data?.title ?? "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text("Date: ${data?.date}"),
                    const SizedBox(height: 20),
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
          );
        },
      ),
    );
  }

  Future<void> getApod() async {
    bool isSuccess = await callData.getData();
    if (isSuccess) {
      if(callData.apodModel!.mediaType == "video"){
        Uri url = Uri.parse(callData.apodModel!.url!);
        await callVideo.initializedPlayer(url);
      }
      debugPrint("✅ Success");
    } else {
      debugPrint("❎ Fail");
    }
  }
}
