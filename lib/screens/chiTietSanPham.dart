// ignore_for_file: prefer_const_constructors, file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import '/models/product-model.dart';
import '/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleProductDetailScreen extends StatelessWidget {
  ProductModel productModel;
  SingleProductDetailScreen({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConstant.appTextColor,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text("Chi tiết sản phẩm", style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              color: const Color.fromARGB(255, 255, 238, 237),
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên sản phẩm:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.productName,
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
                          "Tên danh mục",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.categoryName,
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
                          "Giá sản phẩm",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.salePrice != ''
                                ? productModel.salePrice
                                : productModel.fullPrice,
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
                          "Thời gian giao hàng",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.deliveryTime,
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
                          "Sale ?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.isSale ? "True" : "false",
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
                            productModel.productImages.isNotEmpty
                                ? productModel.productImages[0]
                                : ''),
                      ),
                      if (productModel.productImages.length > 1)
                        CircleAvatar(
                          radius: 50.0,
                          foregroundImage:
                              NetworkImage(productModel.productImages[1]),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
