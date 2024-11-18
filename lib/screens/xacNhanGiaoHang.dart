// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/order-model.dart';
import '../utils/constant.dart';
import 'chiTietSanPhamOrder.dart';

class SpecificCustomerOrderScreen extends StatelessWidget {
  String docId;
  String customerName;
  SpecificCustomerOrderScreen({
    super.key,
    required this.docId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppConstant.appTextColor,
          ),
          backgroundColor: AppConstant.appMainColor,
          title: Text(
            customerName,
            style: TextStyle(color: Colors.white),
          )),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(docId)
            .collection('confirmOrders')
            .orderBy('createdAt', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: const Center(
                child: Text('Error occurred while fetching orders!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: const Center(
                child: Text('No orders found!'),
              ),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                String orderDocId = data.id;
                OrderModel orderModel = OrderModel(
                  categoryId: data['categoryId'],
                  categoryName: data['categoryName'],
                  createdAt: data['createdAt'],
                  customerAddress: data['customerAddress'],
                  customerDeviceToken: data['customerDeviceToken'],
                  customerId: data['customerId'],
                  customerName: data['customerName'],
                  customerPhone: data['customerPhone'],
                  deliveryTime: data['deliveryTime'],
                  fullPrice: data['fullPrice'],
                  isSale: data['isSale'],
                  productDescription: data['productDescription'],
                  productId: data['productId'],
                  productImages: data['productImages'],
                  productName: data['productName'],
                  productQuantity: data['productQuantity'],
                  productTotalPrice: data['productTotalPrice'],
                  salePrice: data['salePrice'],
                  status: data['status'],
                  updatedAt: data['updatedAt'],
                );

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Get.to(
                      () => CheckSingleOrderScreen(
                        /////NHẤN VÀO CHUYỂN SANG CHI TIẾT SẢN PHẨM ORDER
                        docId: snapshot.data!.docs[index].id,
                        orderModel: orderModel,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appScendoryColor,
                      child: Text(
                        orderModel.customerName[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(data['customerName']),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(orderModel.productName),
                        SizedBox(width: 10.0),
                        orderModel.status != true
                            ? Text(
                                "Chờ xác nhận",
                                style: TextStyle(color: Color.fromARGB(255, 239, 183, 69)),
                              )
                            : Text(
                                "Đã xác nhận",
                                style: TextStyle( color: Colors.green),
                              ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        showBottomSheet(
                          userDocId: docId,
                          orderModel: orderModel,
                          orderDocId: orderDocId,
                        );
                      },
                      child: Icon(Icons.more_vert),
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  void showBottomSheet({
    required String userDocId,
    required OrderModel orderModel,
    required String orderDocId,
  }) {
    /////////////XÁC NHẬN TRUE/ FALSE GIAO HÀNG HAY CHƯA?
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 238, 237),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(userDocId)
                          .collection('confirmOrders')
                          .doc(orderDocId)
                          .update(
                        {
                          'status': false,
                        },
                      );
                    },
                    child: Text(
                      'Chờ xác nhận',
                      style: TextStyle(color: Color.fromARGB(255, 239, 183, 69)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(userDocId)
                            .collection('confirmOrders')
                            .doc(orderDocId)
                            .update(
                          {
                            'status': true,
                          },
                        );
                      },
                      child: Text(
                        'Xác nhận',
                        style:
                            TextStyle(color: Color.fromARGB(255, 22, 176, 55)),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
