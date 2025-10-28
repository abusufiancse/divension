// src/screens/divention_names_screen.dart
import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class DiventionNamesScreen extends StatelessWidget {
  const DiventionNamesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final names = ['Divention Alpha','Divention Beta','Divention Gamma','Divention Delta','Divention Sigma'];
    return Scaffold(
      appBar: AppBar(title: const Text('Divention Names')),
      body: ListView(
        children: [
          const SectionHeader(title: 'All Divention'),
          ...names.map((n) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: GlassCard(child: ListTile(
              leading: const Icon(Icons.apartment_rounded),
              title: Text(n, style: const TextStyle(fontWeight: FontWeight.w900)),
              trailing: const Icon(Icons.arrow_forward_rounded),
              onTap: () {},
            )),
          )),
        ],
      ),
    );
  }
}
