import 'package:aarogyamswadeshi/Admin/orders/change_status.dart';
import 'package:aarogyamswadeshi/Admin/widget/drawer.dart';
import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_status_controller.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key key}) : super(key: key);

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  OrdersController ordersController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      drawer: Drawerbar(),
      body: Obx(() {
        if (ordersController.orderslist.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: ordersController.orderslist.length,
            itemBuilder: (BuildContext context, int index) {
              var orderId = ordersController.orderslist[index];

              return Container(
                height: Get.height * 0.1,
                width: Get.width,
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      15,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10),
                      child: Container(
                        width: Get.width * 0.4,
                        child: Text(
                          "OrderId : $orderId",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10),
                      child: InkWell(
                        onTap: () {
                          Get.to(ChangeStatus(
                            orderid: orderId,
                          ));
                        },
                        child: Icon(
                          Icons.edit,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (!ordersController.isOrdererror.value) {
          return Center(
            child: Text("Something Went Wrong!"),
          );
        } else if (!ordersController.isOrderLoading.value) {
          return Center(child: Text("Sorry ! You have not any order"));
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: kPrimaryColor,
          ));
        }
      }),
    );
  }
}
