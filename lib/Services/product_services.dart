import 'dart:convert';
import 'package:aarogyamswadeshi/Admin/product/product_controller.dart';
import 'package:aarogyamswadeshi/Screens/Home/home_controller.dart';
import 'package:aarogyamswadeshi/Services/pref_manager.dart';
import 'package:aarogyamswadeshi/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:aarogyamswadeshi/Services/api_services.dart';
import 'dart:io' as Io;

ProductController productController = Get.put(ProductController());
Homecontroller homecontroller = Get.put(Homecontroller());

Future<String> addProduct(Map data) async {
  var token = await getToken();
  final bytes = Io.File(data["file"]).readAsBytesSync();
  String base64Image = base64Encode(bytes);
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Product/CreatePrduct'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: data["subcategoryId"] != ""
                ? json.encode({
                    "categoryId": data["categoryId"],
                    "subcategoryId": data["subcategoryId"],
                    "englishname": data["englishname"],
                    "gujaratiname": data["gujaratiname"],
                    "productDesc": data["productDesc"],
                    "productGDesc": data["productGDesc"],
                    "productImagePath": base64Image,
                    "price": data["price"],
                  })
                : json.encode({
                    "categoryId": data["categoryId"],
                    "englishname": data["englishname"],
                    "gujaratiname": data["gujaratiname"],
                    "productDesc": data["productDesc"],
                    "productGDesc": data["productGDesc"],
                    "productImagePath": base64Image,
                    "price": data["price"],
                  }),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getAllproduct();
      print("Product add");
      return "Product created successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Product not add");
      return "Product not added";
    }
  } catch (e) {
    print("error");
    return "Something went wrong!";
  }
}

Future getAllproduct() async {
  productController.isalldataload.value = true;
  productController.isalldataerror.value = true;
  var token = await getToken();
  print(token);
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/Product/GetAllProduct'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      productController.productlist.clear();
      productController.productlist.value = data;

      if (productController.productlist.isEmpty) {
        productController.isalldataload.value = false;
      }

      print(productController.productlist);
      print("get products");
    } else {
      var data = jsonDecode(response.body);
      print(data);
      productController.isalldataerror.value = false;

      print("get not products");
    }
  } catch (e) {
    productController.isalldataerror.value = false;
  }
}

Future<String> updateProduct(Map data) async {
  var token = await getToken();
  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Product/UpdateProduct'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              // "categoryId": data["categoryId"],
              "productId": data["productId"],
              "englishname": data["englishname"],
              "gujaratiname": data["gujaratiname"],
              "productDesc": data["productDesc"],
              "productGDesc": data["productGDesc"],
              "productImagePath": data["file"],
              "price": data["price"],
            }),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getAllproduct();
      print("Product updated");
      return "Product updated successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Product not updated");
      return "Product not updated";
    }
  } catch (e) {
    print("error");
    return "Something went wrong!";
  }
}

Future deleteProduct(int id) async {
  var token = await getToken();

  try {
    final response =
        await http.post(Uri.parse(baseUrl + '/api/Product/DeleteProduct/$id'),
            headers: {
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({"id": id}),
            encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      getAllproduct();
      print("Product deleted");
      return "Product deleted successfully";
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("Product delete error");
      return "Product not deleted";
    }
  } catch (e) {
    print("error");
    print(e);
    return "Something went wrong!";
  }
}

Future getProductbycategory(int id) async {
  print(id);
  var token = await getToken();
  homecontroller.categoryviseProductlist.clear();
  try {
    final response = await http.get(
      Uri.parse(
        baseUrl + '/api/Product/GetByCategoryId/$id',
      ),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      homecontroller.categoryviseProductlist.value = data["data"];
      print(homecontroller.categoryviseProductlist);
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print(" data not get");
    }
  } catch (e) {}
}

Future getProductbysubcategory(int id) async {
  var token = await getToken();
  homecontroller.subcategoryviseProductlist.clear();

  try {
    final response = await http.get(
      Uri.parse(
        baseUrl + '/api/Product/GetBySubCategoryId/$id',
      ),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      homecontroller.subcategoryviseProductlist.value = data["data"];
      print(homecontroller.subcategoryviseProductlist);
      return homecontroller.subcategoryviseProductlist;
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print(" data not get");
    }
  } catch (e) {}
}

Future getSearch(String value) async {
  var token = await getToken();
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/Search/$value'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List searchdatalist = data;
      print(searchdatalist);
      homecontroller.searchlist.clear();
      if (searchdatalist.isEmpty) {
        return "noproduct";
      } else if (searchdatalist[0]["type"] != "Product") {
        firstLoad();
        homecontroller.searchlist.value = data;
      } else {
        productController.productlist.clear();
        getSearchProduct(value);
        return "product";
      }

      print("get search");
      print(data);
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("no search");
    }
  } catch (e) {
    // homecontroller.isalldataerror.value = false;
  }
}

Future getSearchProduct(String value) async {
  var token = await getToken();
  try {
    final response = await http.get(
      Uri.parse(baseUrl + '/api/Search/GetproductBySerach/$value'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      productController.hasNextPage.value = true;
      productController.productlist.clear();
      productController.productlist.value = data;
      print("get search productss");
      print(data);
    } else {
      var data = jsonDecode(response.body);
      print(data);
      print("get no search products");
    }
  } catch (e) {
    // homecontroller.isalldataerror.value = false;
  }
}

void firstLoad() async {
  productController.limit.value = 4;
  productController.pageNumber.value = 1;
  productController.hasNextPage.value = true;
  var token = await getToken();
  productController.productlist.clear();
  productController.isFirstLoadRunning.value = true;

  try {
    final res = await http.get(
      Uri.parse(
          "$baseUrl/api/Product?PageNumber=${productController.pageNumber.value}&PageSize=${productController.limit.value}"),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var data = json.decode(res.body);
    print(data["data"]);
    productController.productlist.value = data["data"];
  } catch (err) {
    print('Something went wrong');
    print(err);
  }

  productController.isFirstLoadRunning.value = false;
}

void loadMore() async {
  // print("load more data call");
  var token = await getToken();
  if (productController.hasNextPage.value == true &&
      productController.isFirstLoadRunning.value == false &&
      productController.isLoadMoreRunning.value == false &&
      // productController.scontroller.position.extentAfter < 300) {
      productController.scontroller.position.maxScrollExtent > 0) {
    productController.isLoadMoreRunning.value =
        true; // Display a progress indicator at the bottom
    productController.limit.value = 4;
    productController.pageNumber.value += 1;
    try {
      final res = await http.get(
        Uri.parse(
            "$baseUrl/api/Product?PageNumber=${productController.pageNumber.value}&PageSize=${productController.limit.value}"),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var data = json.decode(res.body);
      List fetchedPosts = data["data"];

      if (fetchedPosts.length > 0) {
        productController.productlist.addAll(fetchedPosts);
      } else {
        productController.hasNextPage.value = false;
      }
    } catch (err) {
      print('Something went wrong!');
    }

    productController.isLoadMoreRunning.value = false;
  }
}
