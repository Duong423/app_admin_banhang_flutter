// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable, sized_box_for_whitespace, prefer_is_empty, avoid_print, await_only_futures

import 'dart:io';
import '../controllers/upAnhSanPham.dart';
import '../services/generate-ids-service.dart';
import '../utils/constant.dart';
import '../widgets/selectDanhMuc-widget.dart';
import '/models/product-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../controllers/selectDanhMuc_controller.dart';
import '../controllers/Sale.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  AddProductImagesController addProductImagesController =
      Get.put(AddProductImagesController());

  //
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  IsSaleController isSaleController = Get.put(IsSaleController());

  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppConstant.appTextColor,
          ),
          backgroundColor: AppConstant.appMainColor,
          title: Text(
            "Thêm sản phẩm",
            style: TextStyle(color: Colors.white),
          )),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Chọn ảnh"),
                    ElevatedButton(
                      onPressed: () {
                        addProductImagesController.showImagesPickerDialog();
                      },
                      child: Text("Chọn ảnh"),
                    )
                  ],
                ),
              ),

              //show ảnh
              GetBuilder<AddProductImagesController>(
                init: AddProductImagesController(),
                builder: (imageController) {
                  return imageController.selectedImages.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                            itemCount: imageController.selectedImages.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(addProductImagesController
                                        .selectedImages[index].path),
                                    fit: BoxFit.cover,
                                    height: Get.height / 4,
                                    width: Get.width / 2,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        imageController.removeImages(index);
                                        print(imageController
                                            .selectedImages.length);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            AppConstant.appScendoryColor,
                                        child: Icon(
                                          Icons.close,
                                          color: AppConstant.appTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),

              //show categories drop down
              DropDownCategoriesWidget(),

              //sale?
              GetBuilder<IsSaleController>(
                init: IsSaleController(),
                builder: (isSaleController) {
                  return Card(
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Giảm giá ?"),
                          Switch(
                            value: isSaleController.isSale.value,
                            activeColor: AppConstant.appMainColor,
                            onChanged: (value) {
                              isSaleController.toggleIsSale(value);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              //form điền sản phẩm
              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Tên sản phẩm",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              Obx(() {
                return isSaleController.isSale.value
                    ? Container(
                        height: 65,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          cursorColor: AppConstant.appMainColor,
                          textInputAction: TextInputAction.next,
                          controller: salePriceController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            hintText: "Giá sale",
                            hintStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Giá gốc",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: deliveryTimeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Thời gian giao hàng (ngày)",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Chi tiết sản phẩm",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  // print(productId);

                  try {
                    EasyLoading.show();
                    await addProductImagesController.uploadFunction(
                        addProductImagesController.selectedImages);
                    print(addProductImagesController.arrImagesUrl);

                    String productId = await GenerateIds().generateProductId();

                    ProductModel productModel = ProductModel(
                      productId: productId,
                      categoryId: categoryDropDownController.selectedCategoryId
                          .toString(),
                      productName: productNameController.text.trim(),
                      categoryName: categoryDropDownController
                          .selectedCategoryName
                          .toString(),
                      salePrice: salePriceController.text != ''
                          ? salePriceController.text.trim()
                          : '',
                      fullPrice: fullPriceController.text.trim(),
                      productImages: addProductImagesController.arrImagesUrl,
                      deliveryTime: deliveryTimeController.text.trim(),
                      isSale: isSaleController.isSale.value,
                      productDescription:
                          productDescriptionController.text.trim(),
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    await FirebaseFirestore.instance
                        .collection('products')
                        .doc(productId)
                        .set(productModel.toMap());
                    EasyLoading.dismiss();
                  } catch (e) {
                    print("error : $e");
                  }
                },
                child: Text("Upload"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
