import 'package:apod/api_service.dart';
import 'package:apod/urls.dart';
import 'package:get/get.dart';

class GetController extends GetxController{
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMassage;
  String? get errorMassage => _errorMassage;

  Future<bool> getData()async{
    bool isSuccess = false;
    _inProgress = true;
    update();
    
    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      Urls.url,
      // accessToken: token,
    );

    if(response.isSuccess){
      isSuccess = true;
      _errorMassage = null;

    }else{
      _errorMassage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}