import 'package:get/get.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;

  void changeTab(int i) => tabIndex.value = i;

  /// Category list with asset icons
  final categories = [
    {'icon': 'assets/icons/physics.png', 'label': 'Physics'},
    {'icon': 'assets/icons/biology.png', 'label': 'Biology'},
    {'icon': 'assets/icons/chemistry.png', 'label': 'Chemistry'},
    {'icon': 'assets/icons/technology.png', 'label': 'Technology'},
    {'icon': 'assets/icons/astronomy.png', 'label': 'Astronomy'},
    {'icon': 'assets/icons/enviroment.png', 'label': 'Environment'},
  ];

  /// Books with cover images
  final books = [
    {
      'title': 'Quantum Mechanics 101',
      'author': 'Dr. Ray',
      'tag': 'Physics',
      'image': 'assets/books/physics1.jpg',
      'badge': 'Free'
    },
    {
      'title': 'Modern Chemistry Lab Guide',
      'author': 'Dr. Emma Wilson',
      'tag': 'Chemistry',
      'image': 'assets/books/chemistry1.jpg',
      'badge': 'Paid'
    },
    {
      'title': 'AI & Machine Learning',
      'author': 'Dr. James Lin',
      'tag': 'Technology',
      'image': 'assets/books/tech1.jpg',
      'badge': 'Free'
    },
  ];
}
