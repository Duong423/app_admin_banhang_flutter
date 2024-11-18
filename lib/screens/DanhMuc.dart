// ignore_for_file: avoid_unnecessary_containers

import '../controllers/suaDanhMuc.dart';
import '/models/categories_model.dart';
import '/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import 'themDanhMuc.dart';
import 'suaDanhMuc.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppConstant.appTextColor,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Tất cả danh mục",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () => Get.to(() => const AddCategoriesScreen()),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
            // .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: const Center(
                child: Text('Error occurred while fetching category!'),
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
                child: Text('No category found!'),
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

                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: data['categoryId'],
                  categoryName: data['categoryName'],
                  categoryImg: data['categoryImg'],
                  createdAt: data['createdAt'],
                  updatedAt: data['updatedAt'],
                );

                return SwipeActionCell(
                  key: ObjectKey(categoriesModel.categoryId),

                  /// XOA
                  trailingActions: <SwipeAction>[
                    // SwipeAction(
                    //     title: "Xóa",
                    //     onTap: (CompletionHandler handler) async {
                    //       await Get.defaultDialog(
                    //         title: "Xóa danh mục",
                    //         content: const Text(
                    //             "Bạn có muốn xóa không"),
                    //         textCancel: "Hủy",
                    //         textConfirm: "Xóa",
                    //         contentPadding: const EdgeInsets.all(10.0),
                    //         confirmTextColor: Colors.white,
                    //         onCancel: () {},
                    //         onConfirm: () async {
                    //           Get.back(); // Close the dialog
                    //           EasyLoading.show(status: 'Vùi lòng đợi..');
                    //           EditCategoryController editCategoryController =
                    //               Get.put(EditCategoryController(
                    //                   categoriesModel: categoriesModel));

                    //           await editCategoryController
                    //               .deleteImagesFromStorage(
                    //                   categoriesModel.categoryImg);

                    //           await editCategoryController
                    //               .deleteWholeCategoryFromFireStore(
                    //                   categoriesModel.categoryId);

                    //           EasyLoading.dismiss();
                    //         },
                    //         buttonColor: Colors.red,
                    //         cancelTextColor: Colors.black,
                    //       );
                    //     },
                    //     color: Colors.red),
                    SwipeAction(
                      title: "Xóa",
                      onTap: (CompletionHandler handler) async {
                        await Get.defaultDialog(
                          title: "Xóa danh mục",
                          content: const Text("Bạn có muốn xóa không"),
                          textCancel: "Hủy",
                          textConfirm: "Xóa",
                          contentPadding: const EdgeInsets.all(10.0),
                          confirmTextColor: Colors.white,
                          onCancel: () {},
                          onConfirm: () async {
                            Get.back(); // Đóng dialog
                            EasyLoading.show(status: 'Vui lòng đợi...');

                            EditCategoryController editCategoryController =
                                Get.put(EditCategoryController(
                                    categoriesModel: categoriesModel));

                            // Xóa ảnh danh mục từ Storage
                            await editCategoryController
                                .deleteImagesFromStorage(
                                    categoriesModel.categoryImg);

                            // Xóa danh mục và sản phẩm liên quan
                            await editCategoryController
                                .deleteWholeCategoryFromFireStore(
                                    categoriesModel.categoryId);

                            EasyLoading.dismiss();
                          },
                          buttonColor: Colors.red,
                          cancelTextColor: Colors.black,
                        );
                      },
                      color: Colors.red,
                    ),
                  ],
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appScendoryColor,
                        backgroundImage: CachedNetworkImageProvider(
                          categoriesModel.categoryImg.toString(),
                          errorListener: (err) {
                            // Handle the error here
                            const Icon(Icons.error);
                          },
                        ),
                      ),

                      ////SUA
                      title: Text(categoriesModel.categoryName),
                      subtitle: Text(categoriesModel.categoryId),
                      trailing: GestureDetector(
                          onTap: () => Get.to(
                                () => EditCategoryScreen(
                                    categoriesModel: categoriesModel),
                              ),
                          child: const Icon(Icons.edit)),
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
}
