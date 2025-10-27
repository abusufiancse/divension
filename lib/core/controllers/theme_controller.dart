import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';


class ThemeController extends GetxController {
  static const _key = 'isDark';
  final box = GetStorage();
  final themeMode = ThemeMode.system.obs;


  @override
  void onInit() {
    final isDark = box.read(_key);
    if (isDark is bool) {
      themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    super.onInit();
  }


  void toggleTheme() {
    final toDark = themeMode.value != ThemeMode.dark;
    themeMode.value = toDark ? ThemeMode.dark : ThemeMode.light;
    box.write(_key, toDark);
  }
}