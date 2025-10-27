import 'package:get/get.dart';


class HomeController extends GetxController {
  final categories = <Map<String, dynamic>>[
    {"icon": 0xe3f3, "label": "Physics"},
    {"icon": 0xe65f, "label": "Biology"},
    {"icon": 0xe3f2, "label": "Chemistry"},
    {"icon": 0xe30a, "label": "Technology"},
    {"icon": 0xf0eb, "label": "Astronomy"},
    {"icon": 0xe57a, "label": "Environment"},
  ];


  final books = [
    {
      'title': 'Quantum Physics for Beginners',
      'author': 'Dr. Sarah Chen',
      'tag': 'Physics',
      'image': '',
      'badge': 'Free',
    },
    {
      'title': 'Plant Biology & Ecology',
      'author': 'Prof. Michael Green',
      'tag': 'Biology',
      'image': '',
      'badge': 'Paid',
    },
    {
      'title': 'Modern Chemistry Lab Guide',
      'author': 'Dr. Emma Wilson',
      'tag': 'Chemistry',
      'image': '',
      'badge': 'Paid',
    },
    {
      'title': 'AI & Machine Learning',
      'author': 'Dr. James Lin',
      'tag': 'Technology',
      'image': '',
      'badge': 'Free',
    },
  ];
}