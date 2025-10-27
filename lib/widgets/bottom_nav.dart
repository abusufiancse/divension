import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: GNav(
          gap: 8,
          activeColor: Theme.of(context).colorScheme.onPrimary,
          color: Theme.of(context).hintColor,
          tabBackgroundColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            GButton(icon: Icons.home_rounded, text: 'Home'),
            GButton(icon: Icons.menu_book_rounded, text: 'Books'),
            GButton(icon: Icons.event_rounded, text: 'Activities'),
            GButton(icon: Icons.article_rounded, text: 'Blog'),
          ],
          onTabChange: (i) {},
        ),
      ),
    );
  }
}