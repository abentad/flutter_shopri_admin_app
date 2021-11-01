import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zion_shopping_admin/components/app_components.dart';
import 'package:zion_shopping_admin/controller/api_controller.dart';
import 'package:zion_shopping_admin/controller/theme_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zion Mart Admin'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: const BoxDecoration(),
        child: GetBuilder<ApiController>(
          builder: (controller) => ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ProductCard(
                onApprovePressed: () {
                  controller.approveProduct(controller.products[index].id);
                },
                controller: controller,
                themeController: Get.find<ThemeController>(),
                index: index,
                size: size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
