// src/screens/members_screen.dart
import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../widgets/glass_card.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final members = List.generate(20, (i) => ('Member ${i+1}', 'Dept ${i%5 + 1}'));
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: ListView(
        children: [
          const SectionHeader(title: 'Member Directory'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(decoration: const InputDecoration(hintText: 'Search members...')),
          ),
          const SizedBox(height: 8),
          ...members.map((m) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: GlassCard(
              child: Row(
                children: [
                  const CircleAvatar(radius: 24, child: Icon(Icons.person)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
                      Text(m.$2),
                    ],
                  )),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_rounded)),
                ],
              ),
            ),
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
