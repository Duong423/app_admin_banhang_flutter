// ignore_for_file: must_be_immutable, file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:get/get.dart';

import '../models/order-model.dart';
import 'Order.dart';
import '/utils/constant.dart';
import 'package:flutter/material.dart';

class CheckSingleOrderScreen extends StatelessWidget {
  String docId;
  OrderModel orderModel;
  CheckSingleOrderScreen({
    super.key,
    required this.docId,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConstant.appTextColor,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text("Order", style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color.fromARGB(255, 255, 238, 237),
            elevation: 5,
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên sản phẩm: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            orderModel.productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Giá sản phẩm: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            orderModel.productTotalPrice.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số lượng: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            orderModel.productQuantity.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mô tả: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            orderModel.productDescription,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        foregroundImage: NetworkImage(
                            orderModel.productImages.isNotEmpty
                                ? orderModel.productImages[0]
                                : ''),
                      ),
                      if (orderModel.productImages.length > 1)
                        CircleAvatar(
                          radius: 50.0,
                          foregroundImage:
                              NetworkImage(orderModel.productImages[1]),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên khách hàng: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            orderModel.customerName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số điện thoại: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            orderModel.customerPhone,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Địa chỉ: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            orderModel.customerAddress,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ID Khách hàng: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            orderModel.customerId,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
