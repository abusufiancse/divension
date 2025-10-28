// src/screens/member_activity_gallery_screen.dart
import 'package:flutter/material.dart';

class MemberActivityGalleryScreen extends StatelessWidget {
  const MemberActivityGalleryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final imgs = List.generate(30, (i) => 'Img ${i+1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: imgs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemBuilder: (_, i) => Container(
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(imgs[i])),
        ),
      ),
    );
  }
}
