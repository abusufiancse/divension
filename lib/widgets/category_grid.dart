import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const CategoryGrid({super.key, required this.categories});


  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;


    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: categories.map((c) {
        return Container(
          width: 108.w,
          height: 96.h,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
            border: Border.all(color: primary.withOpacity(.12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconData(c['icon'], fontFamily: 'MaterialIcons'), size: 28.sp, color: primary),
              SizedBox(height: 8.h),
              Text(c['label'], style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }
}