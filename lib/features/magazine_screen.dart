// src/screens/magazine_screen.dart
import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../widgets/glass_card.dart';

class MagazineScreen extends StatelessWidget {
  const MagazineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10, (i) => 'Issue #${i+1}: Latest Discoveries');
    return Scaffold(
      appBar: AppBar(title: const Text('Science Magazine')),
      body: ListView(
        children: [
          const SectionHeader(title: 'Latest Issues'),
          _grid(items),
          const SectionHeader(title: 'Categories'),
          _chipWrap(['Physics','Biology','Chemistry','CS','Neuroscience','Environment']),
        ],
      ),
    );
  }

  Widget _grid(List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 170, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemBuilder: (_, i) => GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(items[i], maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const Spacer(),
              FilledButton(onPressed: () {}, child: const Text('Read')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipWrap(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8, runSpacing: 8,
        children: labels.map((e) => Chip(label: Text(e))).toList(),
      ),
    );
  }
}
