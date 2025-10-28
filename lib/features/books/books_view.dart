import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/section_title.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/category_grid.dart';
import '../../widgets/book_grid.dart';
import '../home/home_controller.dart';

class BooksView extends StatelessWidget {
  const BooksView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>(); // ✅ controller available here

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
            const SectionTitle(title: 'Categories'),
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

    return Scaffold(
      appBar: AppBar(title: const Text('E-Books')),
      body: homeTab(),
    );
  }
}
