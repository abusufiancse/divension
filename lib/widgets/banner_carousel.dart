import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BannerItem {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  const BannerItem({required this.title, required this.subtitle, required this.gradient});
}


class BannerCarousel extends StatelessWidget {
  final List<BannerItem> items;
  const BannerCarousel({super.key, required this.items});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.92),
        itemCount: items.length,
        itemBuilder: (_, i) => _BannerCard(item: items[i]),
      ),
    );
  }
}


class _BannerCard extends StatelessWidget {
  final BannerItem item;
  const _BannerCard({required this.item});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(colors: item.gradient),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(item.title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white)),
            SizedBox(height: 4.h),
            Text(item.subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(.9))),
          ],
        ),
      ),
    );
  }
}