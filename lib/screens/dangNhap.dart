// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/dangNhap.dart';
import '../utils/constant.dart';
import 'dangKy.dart';
import 'main-screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn(); // Kiểm tra trạng thái đăng nhập khi khởi chạy
  }

  Future<void> checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id'); // Kiểm tra thông tin đã lưu

    if (userId != null && userId.isNotEmpty) {
      // Nếu đã đăng nhập, chuyển đến MainScreen
      Get.offAll(() => MainScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appScendoryColor,
          centerTitle: true,
          title: Text(
            "Đăng nhập",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextField("Email", Icons.email, userEmail,
                  isPassword: false),
              buildTextField("Password", Icons.password, userPassword,
                  isPassword: true),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Điều hướng đến màn hình quên mật khẩu (nếu có)
                  },
                  child: Text(
                    "Quên mật khẩu?",
                    style: TextStyle(
                        color: AppConstant.appScendoryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: Get.height / 20),
              Material(
                child: Container(
                  width: Get.width / 2,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: loginUser, // Gọi hàm đăng nhập
                  ),
                ),
              ),
              SizedBox(height: Get.height / 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Chưa có tài khoản? ",
                    style: TextStyle(color: AppConstant.appScendoryColor),
                  ),
                  GestureDetector(
                    onTap: () => Get.offAll(() => SignUpScreen()),
                    child: Text(
                      "Đăng ký",
                      style: TextStyle(
                          color: AppConstant.appScendoryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget buildTextField(String hint, IconData icon,
      TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword && signInController.isPasswordVisible.value,
          cursorColor: AppConstant.appScendoryColor,
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: () {
                      signInController.isPasswordVisible.toggle();
                    },
                    child: signInController.isPasswordVisible.value
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  )
                : null,
            contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    String email = userEmail.text.trim();
    String password = userPassword.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackbar(
        title: "Lỗi",
        message: "Vui lòng nhập đầy đủ thông tin",
      );
      return;
    }

    try {
      UserCredential? userCredential =
          await signInController.signInMethod(email, password);

      if (userCredential != null) {
        // Lưu thông tin đăng nhập vào SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userCredential.user!.uid);

         //Chuyển đến màn hình chính
        Get.offAll(() => MainScreen());
        showSnackbar(
          title: "Thành công",
          message: "Đăng nhập thành công!",
        );
      } else {
        showSnackbar(
          title: "Lỗi",
          message: "Đăng nhập thất bại, vui lòng thử lại",
        );
      }
    } catch (e) {
      showSnackbar(
        title: "Lỗi",
        message: "Đăng nhập không thành công: ${e.toString()}",
      );
    }
  }

  void showSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstant.appScendoryColor,
      colorText: AppConstant.appTextColor,
    );
  }
}
