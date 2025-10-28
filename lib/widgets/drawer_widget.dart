import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A0F24), Color(0xFF1B86C9)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // avatar + name + email/login hint
                  Row(
                    children: [
                      Container(
                        width: 56.w, height: 56.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                          boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8)],
                          gradient: LinearGradient(
                            colors: [AppColors.primary.withOpacity(0.7), AppColors.primary],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 30.w),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Divention Science Club',
                                style: AppTextStyles.h2(context)),
                            SizedBox(height: 2.h),
                            Text('Tap to login for personal dashboard',
                                style: AppTextStyles.chip(context)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.toNamed('/login'),
                        icon: Icon(Icons.login_rounded, color: Colors.white, size: 24.w),
                        tooltip: 'Login',
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // small stats chips
                  SizedBox(
                    height: 38.h, // Explicit height for the ListView
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _StatPill(icon: Icons.groups_rounded, label: 'Members', value: '1,240'),
                        SizedBox(width: 8),
                        _StatPill(icon: Icons.menu_book_rounded, label: 'Magazines', value: '48'),
                        SizedBox(width: 8),
                        _StatPill(icon: Icons.event_available_rounded, label: 'Events', value: '23'),
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
                  _SectionLabel('Browse'),
                  _NavTile(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () => Get.offAllNamed('/home'),
                  ),
                  _NavTile(
                    icon: Icons.menu_book_rounded,
                    label: 'Science Magazines',
                    onTap: () => Get.toNamed('/magazine'),
                  ),
                  _NavTile(
                    icon: Icons.event_rounded,
                    label: 'Events',
                    onTap: () => Get.toNamed('/events'),
                  ),
                  _NavTile(
                    icon: Icons.article_outlined,
                    label: 'Blogs',
                    onTap: () => Get.toNamed('/blogs'),
                  ),
                  _NavTile(
                    icon: Icons.apartment_rounded,
                    label: 'Divention Names',
                    onTap: () => Get.toNamed('/divention-names'),
                  ),
                  _NavTile(
                    icon: Icons.photo_library_outlined,
                    label: 'Activity Gallery',
                    onTap: () => Get.toNamed('/activity-gallery'),
                  ),
                  Divider(height: 24.h),

                  _SectionLabel('Club'),
                  _NavTile(
                    icon: Icons.badge_rounded,
                    label: 'Members',
                    onTap: () => Get.toNamed('/members'),
                  ),
                  _NavTile(
                    icon: Icons.workspace_premium_rounded,
                    label: 'Club Achievements',
                    onTap: () => Get.toNamed('/achievements'),
                  ),
                  Divider(height: 24.h),

                  _SectionLabel('Utilities'),
                  // Theme toggle using GetX
                  SwitchListTile.adaptive(
                    secondary: Icon(Icons.brightness_6_rounded, size: 24.w),
                    title: Text('Dark Mode', style: AppTextStyles.body(context)),
                    value: Get.isDarkMode,
                    onChanged: (v) {
                      Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                  _NavTile(
                    icon: Icons.translate_rounded,
                    label: 'Language',
                    trailing: Text('EN', style: AppTextStyles.chip(context)),
                    onTap: () => Get.toNamed('/language'),
                  ),
                  _NavTile(
                    icon: Icons.settings_rounded,
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
                    icon: Icon(Icons.info_outline_rounded, size: 20.w),
                    label: Text('About', style: AppTextStyles.body(context)),
                  ),
                  const Spacer(),
                  Text(
                    'v1.0.0',
                    style: AppTextStyles.body(context)
                  ),
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
      title: Text(label, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700)),
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, size: 24.w),
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
          Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12.sp)),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 10.sp, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}