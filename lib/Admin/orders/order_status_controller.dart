import 'package:get/get.dart';

class OrdersController extends GetxController {
  RxList orderslist = [].obs;
  
   RxBool isOrderLoading = true.obs;
  RxBool isOrdererror = true.obs;
  RxString orderstatusvalue = 'Pending'.obs;

}
