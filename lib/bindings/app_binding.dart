import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<NewsController>(NewsController(), permanent: true);
  }
}