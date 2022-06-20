import 'dart:convert';

import 'package:aarogyamswadeshi/Admin/Slider/slider_controller.dart';
import 'package:aarogyamswadeshi/Admin/orders/order_status_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyamswadeshi/Services/api_services.dart';
import 'dart:io' as Io;
import 'api_services.dart';
import 'pref_manager.dart';

SliderController sliderController = Get.put(SliderController());
OrdersController ordersController = Get.put(OrdersController());

Future sendAdminverification(String email) async {
  final response = await http.get(
    Uri.parse(baseUrl + '/api/User/SendAdminVerificationEmail/$email'),
    headers: {
      "Content-Type": "application/json",
    },
  );
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      // setisAdmin(true);
      setadminEmail(email);
      return "Please Check your email";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Admin not found");
      return "Admin not found";
    }
  } catch (e) {
    return "Something went wrong!";
  }
}

Future forgotPassword(Map data) async {
  try {
    final response = await http.post(
        Uri.parse(baseUrl + '/api/User/ForgotPassword'),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: json.encode({
          "id": data["id"],
          "otp": data["otp"],
          "newPassword": data["password"]
        }),
        encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("password updated");
      print(data);
      return "password updated successfully";
    } else {
      var data = jsonDecode(response.body);
      print("password not updated");
      print(data);
      return data["Message"];
    }
  } catch (e) {
    print("error");
    return "Something went wrong!";
  }
}

Future<String> addGalleryImage(img) async {
  var token = await getToken();
  final bytes = Io.File(img).readAsBytesSync();
  String base64Image = base64Encode(bytes);
  // print(base64Image);
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Gallery/InsertGalleryImages'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode([
              {"galleryImage": base64Image}
            ]),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      print("gallery image add");
      return "Gallery image added";
    } else {
      var data = jsonDecode(response.body);
      // print(data);
      print("gallery image not add");
      return "gallery image already exists";
    }
  } catch (e) {
    print("error");
    // print(e);
    return "Something went wrong!";
  }
}

Future getImages() async {
  var token = await getToken();
  sliderController.isSliderLoading.value = true;
  sliderController.isSlidererror.value = true;
  print(token);
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/Gallery/GetGalleryImage'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      sliderController.imgList.clear();
      sliderController.imgList.value = data["data"];
      if (sliderController.imgList.isEmpty) {
        sliderController.isSliderLoading.value = false;
      }
      print(data["data"]);
      print("data get");
    } else {
      var data = jsonDecode(response.body);
      sliderController.isSlidererror.value = false;
      print(data);
      print("data not get");
    }
  } catch (e) {
    sliderController.isSlidererror.value = false;
  }
}

Future deletetGalleryImage(imgId) async {
  var token = await getToken();
  final response = await http.post(
    Uri.parse(baseUrl + '/api/Gallery/DeletetGalleryImage/$imgId'),
    headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getImages();
      return "Deleted sucessfully!";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      return "Not Found Image";
    }
  } catch (e) {
    return "Something went wrong!";
  }
}

Future getOrders() async {
  var token = await getToken();
  ordersController.isOrderLoading.value = true;
  ordersController.isOrdererror.value = true;
  print(token);
  try {
    final response = await http.get(
      Uri.parse(baseUrl + "/api/Order/GetOrderIds?OrderType=All"),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ordersController.orderslist.clear();
      ordersController.orderslist.value = data["data"];
      if (ordersController.orderslist.isEmpty) {
        ordersController.isOrderLoading.value = false;
      }
      print(data["data"]);
      print("order data get");
    } else {
      var data = jsonDecode(response.body);
      ordersController.isOrdererror.value = false;
      print(data);
      print("order data not get");
    }
  } catch (e) {
    ordersController.isOrdererror.value = false;
  }
}

Future<String> updateOrderStatus(orderid, status) async {
  var token = await getToken();
  // print(base64Image);
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Order/UpdateOrderStatus'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              "orderId": orderid,
              "status": status,
            }),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      print("Order Update");
      return "Order Status Updated";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Order not update");
      return "Order Id not exists";
    }
  } catch (e) {
    print("error");
    // print(e);
    return "Something went wrong!";
  }
}
