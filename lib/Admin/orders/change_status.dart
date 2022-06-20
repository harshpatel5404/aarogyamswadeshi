import 'package:aarogyamswadeshi/Constants/constants.dart';
import 'package:aarogyamswadeshi/Services/admin_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'order_status_controller.dart';

class ChangeStatus extends StatefulWidget {
  final orderid;
  const ChangeStatus({Key key, this.orderid}) : super(key: key);

  @override
  State<ChangeStatus> createState() => _ChangeStatusState();
}

class _ChangeStatusState extends State<ChangeStatus> {
  OrdersController ordersController = Get.put(OrdersController());
  @override
  void initState() {
    super.initState();
    ordersController.orderstatusvalue.value = 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Status"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.03),
              Container(
                width: Get.width,
                padding: EdgeInsets.only(left: 30),
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 35,
                    ),
                    isExpanded: true,
                    value: ordersController.orderstatusvalue.value,
                    elevation: 5,
                    style: const TextStyle(color: Colors.black, fontSize: 19),
                    items: <String>[
                      'Pending',
                      'Approved',
                      'Delivered',
                      'Rejected',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      ordersController.orderstatusvalue.value = newValue;
                    },
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            print(ordersController.orderstatusvalue.value);
            print(widget.orderid);
            updateOrderStatus(
                    widget.orderid, ordersController.orderstatusvalue.value)
                .then((value) {
              Fluttertoast.showToast(msg: value);
            });
          },
          label: Text("Update Status")),
    );
  }
}
