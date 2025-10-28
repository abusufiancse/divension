// src/screens/events_screen.dart
import 'package:flutter/material.dart';
import '../widgets/section_header.dart';
import '../widgets/glass_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      ('Seminar: AI & Health', 'Oct 20, 2025 • Auditorium A'),
      ('Workshop: Lab Safety', 'Oct 28, 2025 • Lab 3'),
      ('Astro Night Meetup', 'Nov 03, 2025 • Rooftop'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: ListView(
        children: [
          const SectionHeader(title: 'Upcoming'),
          ...events.map((e) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: GlassCard(
              child: Row(
                children: [
                  const Icon(Icons.event_available_rounded, size: 28),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(e.$2),
                    ],
                  )),
                  FilledButton.tonal(onPressed: () {}, child: const Text('Details')),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
