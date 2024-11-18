// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/categories_model.dart';

class EditCategoryController extends GetxController {
  CategoriesModel categoriesModel;
  EditCategoryController({required this.categoriesModel});
  Rx<String> categoryImg = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getRealTimeCategoryImg();
  }

  void getRealTimeCategoryImg() {
    FirebaseFirestore.instance
        .collection('categories')
        .doc(categoriesModel.categoryId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['categoryImg'] != null) {
          // Update RxString
          categoryImg.value = data['categoryImg'].toString();
          print(categoryImg);
          update();
        }
      }
    });
  }

  // //delete images
  // Future deleteImagesFromStorage(String imageUrl) async {
  //   final FirebaseStorage storage = FirebaseStorage.instance;
  //   try {
  //     Reference reference = storage.refFromURL(imageUrl);
  //     await reference.delete();
  //   } catch (e) {
  //     print("Error $e");
  //   }
  // }

  // //collection
  // Future<void> deleteImageFromFireStore(
  //     String imageUrl, String categoryId) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('categories')
  //         .doc(categoryId)
  //         .update({'categoryImg': ''});
  //     update();
  //   } catch (e) {
  //     print("Error $e");
  //   }
  // }

  // //delete whole category from firestore
  // Future<void> deleteWholeCategoryFromFireStore(String categoryId) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('categories')
  //         .doc(categoryId)
  //         .delete();
  //     update();
  //   } catch (e) {
  //     print("Error $e");
  //   }
  // }
  //Xóa danh mục từ Firestore
  Future<void> deleteWholeCategoryFromFireStore(String categoryId) async {
    // Bắt đầu transaction để xóa danh mục và sản phẩm liên quan
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Lấy danh sách sản phẩm thuộc danh mục
    QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    // Thêm các lệnh xóa sản phẩm vào batch
    for (var product in productsSnapshot.docs) {
      batch.delete(product.reference);
    }

    // Xóa danh mục
    DocumentReference categoryRef =
        FirebaseFirestore.instance.collection('categories').doc(categoryId);
    batch.delete(categoryRef);

    // Thực thi batch
    await batch.commit();
  }

  // Xóa ảnh từ storage
  Future<void> deleteImagesFromStorage(String imageUrl) async {
    try {
      // Xóa ảnh từ Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (e) {
      debugPrint('Failed to delete image: $e');
    }
  }
}
