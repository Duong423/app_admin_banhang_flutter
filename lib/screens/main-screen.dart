// ignore_for_file: prefer_const_constructors

import 'package:admin_app/controllers/chart_order_controller.dart';
import 'package:admin_app/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/chart_order_model.dart';
import '../widgets/drawer-widget.dart';
import 'dangNhap.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

   /// Hàm xử lý đăng xuất
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id'); // Xóa thông tin đăng nhập khỏi SharedPreferences

    // Điều hướng đến màn hình đăng nhập và xóa stack
    Get.offAll(() => SignInScreen());
  }

  @override
  Widget build(BuildContext context) {
    final GetAllOrdersChart getAllOrdersChart = Get.put(GetAllOrdersChart());

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "Admin Panel",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: _logout, // Gọi hàm đăng xuất khi nhấn nút logout
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: Container(
        child: Column(
          children: [
            Obx(() {
              final monthlyData = getAllOrdersChart.monthlyOrderData;
              if (monthlyData.isEmpty) {
                return Container(
                  height: Get.height / 2,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              } else {
                return SizedBox(
                  height: Get.height / 2,
                  child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: CategoryAxis(arrangeByIndex: true),
                    series: <LineSeries<ChartData, String>>[
                      LineSeries<ChartData, String>(
                        dataSource: monthlyData,
                        width: 2.5,
                        color: AppConstant.appMainColor,
                        xValueMapper: (ChartData data, _) => data.month,
                        yValueMapper: (ChartData data, _) => data.value,
                        name: "Monthly Orders",
                        markerSettings: MarkerSettings(isVisible: true),
                      )
                    ],
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
