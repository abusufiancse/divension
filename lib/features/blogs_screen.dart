// src/screens/blogs_screen.dart
import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../widgets/glass_card.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      ('Why Research Matters', 'Insights for students'),
      ('Policy & Science', 'Bridging the gap'),
      ('The New Space Race', 'Beyond orbit'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Blogs')),
      body: ListView(
        children: [
          const SectionHeader(title: 'Latest Blogs'),
          ...posts.map((p) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: GlassCard(
              child: ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(p.$2),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {},
              ),
            ),
          )),
        ],
      ),
    );
  }
}
