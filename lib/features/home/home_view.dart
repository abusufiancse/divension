import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/controllers/theme_controller.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/section_title.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/category_grid.dart';
import '../../widgets/book_grid.dart';
import '../../widgets/bottom_nav.dart';
import 'home_controller.dart';
import '../books/books_view.dart';
import '../activities/activities_view.dart';
import '../blog/blog_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();
    final c = Get.put(HomeController());

    Widget homeTab() => SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerCarousel(
              items: const [
                BannerItem(
                  title: 'New Physics Magazine',
                  subtitle: 'Quantum Mechanics Explained',
                  gradient: [Color(0xFF2563EB), Color(0xFF60A5FA)],
                ),
                BannerItem(
                  title: 'Biology Journal',
                  subtitle: 'Life & Ecosystems',
                  gradient: [Color(0xFF059669), Color(0xFF34D399)],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SectionTitle(title: 'Categories'),
            SizedBox(height: 8.h),
            CategoryGrid(categories: c.categories),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle(title: 'Science ePub Library'),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            SizedBox(height: 8.h),
            BookGrid(books: c.books),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );

    final pages = [
      Scaffold(
        appBar: AppBar(
          title: Text('Divention Science Club', style: AppTextStyles.h2(context)),
          actions: [
            IconButton(
              tooltip: 'Toggle theme',
              onPressed: themeC.toggleTheme,
              icon: const Icon(Icons.brightness_6_rounded),
            ),
          ],
        ),
        body: homeTab(),
      ),
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
