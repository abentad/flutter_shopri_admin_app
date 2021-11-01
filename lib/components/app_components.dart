import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:zion_shopping_admin/constants/api_const.dart';
import 'package:zion_shopping_admin/controller/api_controller.dart';
import 'package:zion_shopping_admin/controller/theme_controller.dart';
import 'package:zion_shopping_admin/utils/app_utils.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key, required this.controller, required this.onApprovePressed, required this.themeController, required this.index, required this.size, this.radiusDouble = 15.0})
      : super(key: key);
  final ApiController controller;
  final int index;
  final Size size;
  final double radiusDouble;
  final ThemeController themeController;
  final Function() onApprovePressed;
  double doubleInRange(Random source, num start, num end) => source.nextDouble() * (end - start) + start;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: const Color(0xfff2f2f2),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
              child: CachedNetworkImage(
                imageUrl: '$kbaseUrl/${controller.products[index].image}',
                placeholder: (context, url) => Container(
                  height: size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              color: themeController.defaultTheme['greyishColor'],
              // color: Colors.black,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radiusDouble), bottomRight: Radius.circular(radiusDouble)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.01),
                    Text(controller.products[index].name.capitalize.toString(),
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: themeController.defaultTheme['blackColor'])),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      '${formatPrice(controller.products[index].price)} birr',
                      style: TextStyle(fontSize: 15.0, color: themeController.defaultTheme['greyColor']),
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
                MaterialButton(
                  onPressed: onApprovePressed,
                  child: const Icon(Icons.post_add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
