import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxList productlist = [].obs;
  RxList dropdownsubcategory = [].obs;
  RxBool isalldataerror = true.obs;
  RxBool isalldataload = true.obs;

  RxInt pageNumber = 1.obs;
  RxInt limit = 3.obs;

  RxBool hasNextPage = true.obs;
  ScrollController scontroller = ScrollController();

  RxBool isFirstLoadRunning = false.obs;

  RxBool isLoadMoreRunning = false.obs;
}
