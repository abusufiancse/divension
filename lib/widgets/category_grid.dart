import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: .9,
      ),
      itemCount: categories.length,
      itemBuilder: (_, i) {
        final item = categories[i];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 65.w,
              width: 65.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                item['icon'],             // ✅ use string asset path
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              item['label'],
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
