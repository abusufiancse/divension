import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';


class AppTextStyles {
  static TextStyle h1(BuildContext ctx) => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: Theme.of(ctx).colorScheme.onBackground,
  );


  static TextStyle h2(BuildContext ctx) => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: Theme.of(ctx).colorScheme.onBackground,
  );


  static TextStyle body(BuildContext ctx) => TextStyle(
    fontSize: 14.sp,
    height: 1.35,
    color: Theme.of(ctx).brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight,
  );


  static TextStyle chip(BuildContext ctx) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Theme.of(ctx).colorScheme.onPrimary,
  );


  static TextStyle badge(BuildContext ctx) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: Theme.of(ctx).colorScheme.onSecondary,
  );
}