import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/controllers/theme_controller.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController());


  runApp(const DiventionApp());
}


class DiventionApp extends StatelessWidget {
  const DiventionApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();


    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => Obx(
            () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Divention Science Club',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeC.themeMode.value,
          initialRoute: AppRoutes.home,
          getPages: [
            GetPage(name: AppRoutes.home, page: () => const HomeView()),
          ],
        ),
      ),
    );
  }
}