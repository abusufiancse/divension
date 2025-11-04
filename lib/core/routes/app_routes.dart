import 'package:get/get.dart';
import '../../features/blogs_screen.dart';
import '../../features/books/divensions_megazine.dart';
import '../../features/club_memories_screen.dart';
import '../../features/dashboard_screen.dart';
import '../../features/divention_names_screen.dart';
import '../../features/events_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/login_screen.dart';
import '../../features/magazine_screen.dart';
import '../../features/member_activity_gallery_screen.dart';
import '../../features/members_screen.dart';
import '../../features/splash_screen.dart';
import 'route_name.dart';
import 'package:flutter/widgets.dart' show RouteSettings, Curves;

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // TODO: আপনার রিয়েল টোকেন/লজিক বসান
    final bool isLoggedIn = false;
    if (!isLoggedIn && route == RouteName.dashboard) {
      return const RouteSettings(name: RouteName.login);
    }
    return null;
  }
}

class AppRoutes {
  static List<GetPage> appRoutes() => [
    // Splash
    GetPage(
      name: RouteName.splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),

    // Home
    GetPage(
      name: RouteName.homeScreen,
      page: () => const HomeScreen(),
      transition: Transition.cupertino,
    ),

    // Content sections
    GetPage(
      name: RouteName.magazine,
      // page: () => const MagazineScreen(),
      page: () => const DivensionMagazine(),
      transition: Transition.rightToLeftWithFade,
      curve: Curves.easeOutCubic,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: RouteName.events,
      page: () => const EventsScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.clubMemories,
      page: () => const ClubMemoriesScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.members,
      page: () => const MembersScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.blogs,
      page: () => const BlogsScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.diventionNames,
      page: () => const DiventionNamesScreen(),
      transition: Transition.zoom,
    ),

    // Auth + user
    GetPage(
      name: RouteName.login,
      page: () => const LoginScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: RouteName.dashboard,
      page: () => const DashboardScreen(),
      middlewares: [AuthMiddleware()],
      transition: Transition.leftToRightWithFade,
    ),

    // Gallery
    GetPage(
      name: RouteName.memberActivityGallery,
      page: () => const MemberActivityGalleryScreen(),
      transition: Transition.cupertinoDialog,
    ),
  ];
}
