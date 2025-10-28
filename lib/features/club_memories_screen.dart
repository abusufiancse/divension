// src/screens/club_memories_screen.dart
import 'package:flutter/material.dart';
import '../widgets/section_header.dart';

class ClubMemoriesScreen extends StatelessWidget {
  const ClubMemoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final photos = List.generate(18, (i) => 'Memory ${i+1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Club Memories')),
      body: ListView(
        children: [
          const SectionHeader(title: 'Activity Photos'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemBuilder: (_, i) => Container(
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text(photos[i])),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
