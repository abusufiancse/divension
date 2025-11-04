import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart'; // <-- add this
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      elevation: 0,
      child: SafeArea(
        child: Column(
          children: [
            // ===== Header =====
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A0F24), Color(0xFF1B86C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // avatar + name + email/login hint
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: 56.w,
                  //       height: 56.h,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border: Border.all(color: Colors.white24),
                  //         boxShadow: const [
                  //           BoxShadow(color: Colors.black38, blurRadius: 8)
                  //         ],
                  //         gradient: LinearGradient(
                  //           colors: [
                  //             AppColors.primary.withOpacity(0.7),
                  //             AppColors.primary
                  //           ],
                  //           begin: Alignment.topLeft,
                  //           end: Alignment.bottomRight,
                  //         ),
                  //       ),
                  //       child: Icon(Bootstrap.rocket_takeoff, // icons_plus
                  //           color: Colors.white, size: 30.w),
                  //     ),
                  //     SizedBox(width: 12.w),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text('Divention Science Club',
                  //               style: AppTextStyles.h2(context).copyWith(color: Colors.white),),
                  //           SizedBox(height: 2.h),
                  //           Text('Tap to login for personal dashboard',
                  //               style: AppTextStyles.chip(context).copyWith(color: Colors.white)),
                  //         ],
                  //       ),
                  //     ),
                  //     IconButton(
                  //       onPressed: () => Get.toNamed('/login'),
                  //       icon: Icon(Bootstrap.box_arrow_in_right, // icons_plus
                  //           color: Colors.white, size: 24.w),
                  //       tooltip: 'Login',
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                    child: Image.asset('assets/images/logo.png',),
                  ),
                  SizedBox(height: 16.h),
                  // small stats chips
                  SizedBox(
                    height: 38.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _StatPill(
                          icon: Bootstrap.people, // icons_plus
                          label: 'Members',
                          value: '1,240',
                        ),
                        SizedBox(width: 8),
                        _StatPill(
                          icon: Bootstrap.journal, // icons_plus
                          label: 'Magazines',
                          value: '48',
                        ),
                        SizedBox(width: 8),
                        _StatPill(
                          icon: Bootstrap.calendar_event, // icons_plus
                          label: 'Events',
                          value: '23',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== Menu =====
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 6.h),
                  const _SectionLabel('Browse'),
                  // _NavTile(
                  //   icon: Bootstrap.house, // icons_plus
                  //   label: 'Home',
                  //   onTap: () => Get.offAllNamed('/home'),
                  // ),
                  _NavTile(
                    icon: Bootstrap.book, // icons_plus
                    label: 'Science Magazines',
                    onTap: () => Get.toNamed('/magazine'),
                  ),
                  _NavTile(
                    icon: Bootstrap.calendar2_event, // icons_plus
                    label: 'Events',
                    onTap: () => Get.toNamed('/events'),
                  ),
                  _NavTile(
                    icon: Bootstrap.file_text, // icons_plus
                    label: 'Blogs',
                    onTap: () => Get.toNamed('/blogs'),
                  ),
                  _NavTile(
                    icon: Bootstrap.building, // icons_plus
                    label: 'Divention Names',
                    onTap: () => Get.toNamed('/divention-names'),
                  ),
                  _NavTile(
                    icon: Bootstrap.images, // icons_plus
                    label: 'Activity Gallery',
                    onTap: () => Get.toNamed('/activity-gallery'),
                  ),
                  Divider(height: 24.h),

                  const _SectionLabel('Club'),
                  _NavTile(
                    icon: Bootstrap.badge_wc, // icons_plus
                    label: 'Members',
                    onTap: () => Get.toNamed('/members'),
                  ),
                  _NavTile(
                    icon: Bootstrap.trophy, // icons_plus
                    label: 'Club Achievements',
                    onTap: () => Get.toNamed('/achievements'),
                  ),
                  Divider(height: 24.h),

                  const _SectionLabel('Utilities'),
                  // Theme toggle using GetX
                  SwitchListTile.adaptive(
                      secondary: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Get.isDarkMode ? Bootstrap.sun_fill : Bootstrap.moon_stars_fill,
                          key: ValueKey(Get.isDarkMode),
                          size: 24.w,
                            color: Get.isDarkMode ? Colors.amber: Colors.grey.shade900,

                        ),
                      ),
                    title:
                    Get.isDarkMode ? Text(
                      'Light Mode',
                      style: AppTextStyles.body(context),
                    ) :Text(
                      'Dark Mode',
                      style: AppTextStyles.body(context),
                    ),
                    value: Get.isDarkMode,
                    onChanged: (v) {
                      Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                  _NavTile(
                    icon: Bootstrap.translate, // icons_plus
                    label: 'Language',
                    trailing: Text('EN', style: AppTextStyles.chip(context)),
                    onTap: () => Get.toNamed('/language'),
                  ),
                  _NavTile(
                    icon: Bootstrap.gear, // icons_plus
                    label: 'Settings',
                    onTap: () => Get.toNamed('/settings'),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),

            // ===== Footer =====
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Get.toNamed('/about'),
                    icon: Icon(Bootstrap.info_circle, size: 20.w),
                    label: Text('About', style: AppTextStyles.body(context)),
                  ),
                  const Spacer(),
                  Text('v1.0.0', style: AppTextStyles.body(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
      child: Text(
        text,
        style: AppTextStyles.h2(context).copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
          letterSpacing: .3,
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.primary, size: 24.w),
      title: Text(
        label,
        style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700),
      ),
      trailing:
      trailing ?? Icon(Bootstrap.chevron_right, size: 24.w), // icons_plus
      onTap: () {
        Navigator.of(context).pop(); // close drawer first
        onTap();
      },
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatPill({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: Colors.white),
          SizedBox(width: 6.w),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.sp)),
          SizedBox(width: 6.w),
          Text(label,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
