import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/controllers/theme_controller.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/bottom_nav.dart';
import 'home_controller.dart';
import '../books/books_view.dart';
import '../activities/activities_view.dart';
import '../blog/blog_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    final themeC = Get.find<ThemeController>();

    final pages = [
      // ✅ Blank Home screen with AppBar
      Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Image.asset('assets/images/logo.png', width: 100.w,),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text('Divention', style: AppTextStyles.h2(context),),
          //     Text('Divention Science Club', style: AppTextStyles.body(context)),
          //   ],
          // ),
          actions: [
            IconButton(
              tooltip: 'Toggle theme',
              onPressed: themeC.toggleTheme,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedBulb,
                size: 25.sp,
              ),
            ),
            IconButton(
              tooltip: 'Notifications',
              onPressed: (){},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedNotification01,
                size: 25.sp,
              ),
            ),
            Padding(
               padding: EdgeInsets.only(right: 20),
              child: CircleAvatar(
                child: Icon(Icons.account_circle),
              ),
            )
          ],
        ),
        body: const Center(
          child: Text(
            'HomeScreen',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),

      // ✅ Other tabs
      const BooksView(),
      const ActivitiesView(),
      const BlogView(),
    ];

    return Obx(() => Scaffold(
      body: IndexedStack(index: c.tabIndex.value, children: pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: c.tabIndex.value,
        onTabChange: c.changeTab,
      ),
    ));
  }
}
