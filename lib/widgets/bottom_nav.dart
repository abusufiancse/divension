import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart'; // <-- use icons_plus

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Colors that adapt to theme
    final bg = theme.cardColor;                         // bar background
    final tabBg = cs.primary.withOpacity(isDark ? 0.22 : 0.18);
    final activeColor = cs.primary;                     // text/icon when active
    final iconTextActive = cs.onPrimary;                // text/icon on filled tab (older GNavs)
    final inactiveColor = theme.hintColor;              // when inactive
    final ripple = cs.primary.withOpacity(0.08);
    final hover = cs.primary.withOpacity(0.06);

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: GNav(
          gap: 8,
          selectedIndex: currentIndex,
          activeColor: iconTextActive,
          color: inactiveColor,
          iconSize: 22,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          rippleColor: ripple,
          hoverColor: hover,
          tabBackgroundColor: tabBg,
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 300),
          onTabChange: onTabChange,
          tabs: [
            GButton(
              icon: Icons.circle, // required param; visually replaced by leading
              leading: Icon(
                IonIcons.home,
                size: 22,
                color: currentIndex == 0 ? activeColor : inactiveColor,
              ),
              text: 'Home',
              textColor: currentIndex == 0 ? activeColor : inactiveColor,
            ),
            GButton(
              icon: Icons.circle,
              leading: Icon(
                IonIcons.book,
                size: 22,
                color: currentIndex == 1 ? activeColor : inactiveColor,
              ),
              text: 'Books',
              textColor: currentIndex == 1 ? activeColor : inactiveColor,
            ),
            GButton(
              icon: Icons.circle,
              leading: Icon(
                IonIcons.pulse, // Activities vibe
                size: 22,
                color: currentIndex == 2 ? activeColor : inactiveColor,
              ),
              text: 'Activities',
              textColor: currentIndex == 2 ? activeColor : inactiveColor,
            ),
            GButton(
              icon: Icons.circle,
              leading: Icon(
                IonIcons.newspaper,
                size: 22,
                color: currentIndex == 3 ? activeColor : inactiveColor,
              ),
              text: 'Blog',
              textColor: currentIndex == 3 ? activeColor : inactiveColor,
            ),
          ],
        ),
      ),
    );
  }
}
