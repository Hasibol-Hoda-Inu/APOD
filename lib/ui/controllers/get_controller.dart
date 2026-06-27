import 'package:apod/services/api_service.dart';
import 'package:apod/data_model/apod_model.dart';
import 'package:apod/app/urls.dart';
import 'package:get/get.dart';

class GetController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMassage;
  String? get errorMassage => _errorMassage;

  ApodModel? _apodModel;
  ApodModel? get apodModel => _apodModel;

  Future<bool> getData() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await Get.find<NetworkCaller>().getRequest(
      Urls.url,
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMassage = null;
      _apodModel = ApodModel.fromJson(response.responseData);
    } else {
      _errorMassage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
