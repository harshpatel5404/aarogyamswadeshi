import 'dart:convert';
import 'dart:typed_data';

import 'package:aarogyamswadeshi/Screens/Home/search_page.dart';
import 'package:aarogyamswadeshi/Screens/cart/cart.dart';
import 'package:aarogyamswadeshi/Screens/desc/buynow_bottom.dart';
import 'package:aarogyamswadeshi/Services/admin_services.dart';
import 'package:aarogyamswadeshi/Services/cart_service.dart';
import 'package:aarogyamswadeshi/Services/category_service.dart';
import 'package:aarogyamswadeshi/Services/controller.dart';
import 'package:aarogyamswadeshi/Services/login_services.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:aarogyamswadeshi/Services/product_services.dart';
import 'package:aarogyamswadeshi/Services/subcategory_service.dart';
import 'package:flutter/material.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_page.dart';
import 'package:aarogyamswadeshi/Screens/account/account_screen.dart';
import 'package:aarogyamswadeshi/Screens/category/category_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class MainController extends GetxController {
  RxInt currentIndex = 0.obs;
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

MainController MainHomeController = Get.put(MainController());

class _MainHomeState extends State<MainScreen> {
  Controller controller = Get.put(Controller());
  Homecontroller homecontroller = Get.put(Homecontroller());
  List pageList = [
    HomePage(),
    CategoryScreen(),
    Cart(),
    AccountScreen(),
  ];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
    ));
    super.initState();
    // removeToken();
    // removeisAdmin();
    // removelogin();
    // removeuserid();

    controller.getConnect();
     getImages().then((value) {
        homecontroller.scrollableImages.clear();
        for (var i = 0; i < sliderController.imgList.length; i++) {
          String imgString = sliderController.imgList[i]["galleryImage"];
          Uint8List decodedbytes = base64.decode(imgString);
          homecontroller.scrollableImages.add(decodedbytes);
        }
      });
    getUserDetails();
    firstLoad();
    getsubategory();
    getCategory();
    getCart().then((value) {
      cartController.getCarttotal();
    });
   
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isIntenet.value
          ? Scaffold(
              body: Column(
                children: [
                  Obx(
                    () => Expanded(
                      child: pageList[MainHomeController.currentIndex.value],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.065,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            onTap: () {
                              MainHomeController.currentIndex.value = 0;
                            },
                            child: Obx(() => Icon(
                                  Icons.home,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                  color:
                                      MainHomeController.currentIndex.value == 0
                                          ? kPrimaryColor
                                          : Colors.black,
                                ))),
                        InkWell(
                            onTap: () {
                              MainHomeController.currentIndex.value = 1;
                            },
                            child: Obx(() => Icon(
                                  Icons.category_rounded,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                  color:
                                      MainHomeController.currentIndex.value == 1
                                          ? kPrimaryColor
                                          : Colors.black,
                                ))),
                        InkWell(
                            onTap: () {
                              MainHomeController.currentIndex.value = 2;
                            },
                            child: Obx(() => Icon(
                                  Icons.shopping_bag_outlined,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                  color:
                                      MainHomeController.currentIndex.value == 2
                                          ? kPrimaryColor
                                          : Colors.black,
                                ))),
                        InkWell(
                          onTap: () {
                            MainHomeController.currentIndex.value = 3;
                          },
                          child: Obx(() => Icon(Icons.person_rounded,
                              color: MainHomeController.currentIndex.value == 3
                                  ? kPrimaryColor
                                  : Colors.black,
                              size: MediaQuery.of(context).size.width * 0.08)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          : Scaffold(
              backgroundColor: Colors.grey,
              body: AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.error,
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Alert"),
                  ],
                ),
                content: Text(
                  "You are not connected to the Internet",
                  style: TextStyle(fontSize: 17),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        controller.getConnect();
                        Get.offAll(context);
                      },
                      child: Text("Ok"))
                ],
              ),
            ),
    );
  }
}
