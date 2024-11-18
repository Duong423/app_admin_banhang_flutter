// ignore_for_file: must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, dead_code_catch_following_catch

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../controllers/suaDanhMuc.dart';
import '../controllers/upAnhSanPham.dart';
import '../models/categories_model.dart';
import '../utils/constant.dart';

class EditCategoryScreen extends StatefulWidget {
  CategoriesModel categoriesModel;
  EditCategoryScreen({super.key, required this.categoriesModel});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

AddProductImagesController addProductImagesController =
    Get.put(AddProductImagesController());

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryNameController.text = widget.categoriesModel.categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConstant.appTextColor,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Sửa danh mục",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
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
                              addProductImagesController.selectedImages.clear();
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
            //
            const SizedBox(height: 10.0),
            Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                cursorColor: AppConstant.appMainColor,
                textInputAction: TextInputAction.next,
                controller: categoryNameController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  hintText: "Tên danh mục",
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

                  // Bước 1: Lấy đường dẫn ảnh hiện tại
                  String? currentImage = widget.categoriesModel.categoryImg;

                  // Biến để lưu ảnh mới (mặc định là ảnh hiện tại)
                  String newImageUrl = currentImage ?? "";

                  // Nếu người dùng đã chọn ảnh mới, tiến hành xóa ảnh cũ và tải ảnh mới lên
                  if (addProductImagesController.selectedImages.isNotEmpty) {
                    // Xóa ảnh cũ khỏi Firebase Storage nếu có ảnh cũ
                    if (currentImage != null && currentImage.isNotEmpty) {
                      await FirebaseStorage.instance
                          .refFromURL(currentImage)
                          .delete();
                    }

                    // Tải ảnh mới lên Firebase Storage và lấy đường dẫn ảnh
                    await addProductImagesController.uploadFunction(
                        addProductImagesController.selectedImages);

                    // Lấy đường dẫn ảnh mới từ controller
                    if (addProductImagesController.arrImagesUrl.isNotEmpty) {
                      newImageUrl =
                          addProductImagesController.arrImagesUrl.first;
                    }
                  }

                  // Tạo model cập nhật
                  CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: widget.categoriesModel.categoryId,
                    categoryName: categoryNameController.text.trim(),
                    categoryImg: newImageUrl, // Cập nhật ảnh mới
                    createdAt: widget.categoriesModel.createdAt,
                    updatedAt: DateTime.now(),
                  );

                  // Cập nhật Firestore
                  await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(categoriesModel.categoryId)
                      .update(categoriesModel.toJson());

                  EasyLoading.dismiss();
                } catch (e) {
                  EasyLoading.dismiss();
                  print("Error updating product: $e");
                } catch (e) {
                  EasyLoading.dismiss();
                  print("Error updating product: $e");
                }
              },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
