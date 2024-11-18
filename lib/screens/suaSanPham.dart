// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unused_import

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../controllers/Sale.dart';
import '../controllers/selectDanhMuc_controller.dart';
import '../controllers/suaSanPham.dart';
import '../controllers/upAnhSanPham.dart';
import '/models/product-model.dart';
import '/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EditProductScreen extends StatefulWidget {
  ProductModel productModel;
  EditProductScreen({super.key, required this.productModel});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

AddProductImagesController addProductImagesController =
    Get.put(AddProductImagesController());

class _EditProductScreenState extends State<EditProductScreen> {
  IsSaleController isSaleController = Get.put(IsSaleController());
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());
  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.productModel.productName;
    salePriceController.text = widget.productModel.salePrice;
    fullPriceController.text = widget.productModel.fullPrice;
    deliveryTimeController.text = widget.productModel.deliveryTime;
    productDescriptionController.text = widget.productModel.productDescription;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: widget.productModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppConstant.appTextColor,
            ),
            backgroundColor: AppConstant.appMainColor,
            title: Text(
              "${widget.productModel.productName}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SingleChildScrollView(
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
                                    addProductImagesController
                                        .showImagesPickerDialog();
                                    addProductImagesController.selectedImages
                                        .clear();
                                    addProductImagesController.update();
                                  },
                                  child: Text("Chọn ảnh"),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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
                                itemCount:
                                    imageController.selectedImages.length,
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

                  //drop down
                  GetBuilder<CategoryDropDownController>(
                    init: CategoryDropDownController(),
                    builder: (categoriesDropDownController) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: categoriesDropDownController
                                      .selectedCategoryId?.value,
                                  items: categoriesDropDownController.categories
                                      .map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category['categoryId'],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              category['categoryImg']
                                                  .toString(),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(category['categoryName']),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? selectedValue) async {
                                    categoriesDropDownController
                                        .setSelectedCategory(selectedValue);
                                    String? categoryName =
                                        await categoriesDropDownController
                                            .getCategoryName(selectedValue);
                                    categoriesDropDownController
                                        .setSelectedCategoryName(categoryName);
                                  },
                                  hint: const Text(
                                    'Chọn danh mục',
                                  ),
                                  isExpanded: true,
                                  elevation: 10,
                                  underline: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  //isSale
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
                              Text("Sale ?"),
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

                  //form
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

                  GetBuilder<IsSaleController>(
                    init: IsSaleController(),
                    builder: (isSaleController) {
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
                    },
                  ),

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
                        hintText: "Thời gian giao hàng",
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
                        hintText: "Mô tả",
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
                      try {
                        EasyLoading.show();

                        // Bước 1: Lấy danh sách ảnh hiện tại, ép kiểu sang List<String>
                        List<String> currentImages = List<String>.from(
                            widget.productModel.productImages ?? []);

                        // Bước 2: Kiểm tra nếu người dùng không chọn ảnh mới
                        List<String> newImagesUrl = currentImages;

                        // Nếu người dùng đã chọn ảnh mới, tiến hành xóa ảnh cũ và tải ảnh mới lên
                        if (addProductImagesController
                            .selectedImages.isNotEmpty) {
                          // Xóa ảnh cũ khỏi Firebase Storage nếu có ảnh cũ
                          for (String imageUrl in currentImages) {
                            await FirebaseStorage.instance
                                .refFromURL(imageUrl)
                                .delete();
                          }

                          // Tải ảnh mới lên Firebase Storage và lấy đường dẫn ảnh
                          await addProductImagesController.uploadFunction(
                              addProductImagesController.selectedImages);
                          newImagesUrl = addProductImagesController
                              .arrImagesUrl; // Cập nhật list ảnh mới
                        }

                        // Bước 3: Tạo đối tượng `ProductModel` mới với thông tin đã thay đổi và ảnh mới (nếu có)
                        ProductModel updatedProductModel = ProductModel(
                          productId: widget.productModel.productId,
                          categoryId: categoryDropDownController
                              .selectedCategoryId
                              .toString(),
                          productName: productNameController.text.trim(),
                          categoryName: widget.productModel.categoryName,
                          salePrice: salePriceController.text != ''
                              ? salePriceController.text.trim()
                              : '',
                          fullPrice: fullPriceController.text.trim(),
                          productImages:
                              newImagesUrl, // Sử dụng ảnh mới hoặc giữ ảnh cũ
                          deliveryTime: deliveryTimeController.text.trim(),
                          isSale: isSaleController.isSale.value,
                          productDescription:
                              productDescriptionController.text.trim(),
                          createdAt: widget.productModel.createdAt,
                          updatedAt: DateTime.now(),
                        );

                        // Bước 4: Cập nhật sản phẩm trong Firestore
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(widget.productModel.productId)
                            .update(updatedProductModel.toMap());

                        EasyLoading.dismiss();
                      } catch (e) {
                        EasyLoading.dismiss();
                        print("Error updating product: $e");
                      }
                    },
                    child: Text("Update"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
