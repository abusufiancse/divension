// src/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late final TabController _tabs;
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }
  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'My Club'),
            Tab(text: 'Members'),
            Tab(text: 'Activities'),
            Tab(text: 'Gallery'),
          ],
        ),
        actions: [
          IconButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _myClub(cs),
          _members(),
          _activities(),
          _gallery(),
        ],
      ),
    );
  }

  Widget _myClub(ColorScheme cs) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(child: ListTile(
          leading: const Icon(Icons.apartment_rounded),
          title: const Text('Divention Science Club'),
          subtitle: const Text('Established on research & world-class publications'),
          trailing: Chip(label: Text('Member: 1,240', style: TextStyle(color: cs.onPrimaryContainer))),
        )),
        const SizedBox(height: 10),
        GlassCard(child: ListTile(
          leading: const Icon(Icons.menu_book_rounded),
          title: const Text('Science Magazines'),
          subtitle: const Text('Access latest issues from TRSP'),
          trailing: const Icon(Icons.arrow_forward_rounded),
          onTap: () => Navigator.pushNamed(context, '/magazine'),
        )),
        const SizedBox(height: 10),
        GlassCard(child: ListTile(
          leading: const Icon(Icons.event_available_rounded),
          title: const Text('Events'),
          subtitle: const Text('Workshops, seminars & meetups'),
          trailing: const Icon(Icons.arrow_forward_rounded),
          onTap: () => Navigator.pushNamed(context, '/events'),
        )),
      ],
    );
  }

  Widget _members() {
    final items = List.generate(12, (i) => ('Member ${i+1}', 'Activity ${(i%4)+1}'));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => GlassCard(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(items[i].$1, style: const TextStyle(fontWeight: FontWeight.w900)),
          subtitle: Text(items[i].$2),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _activities() {
    final acts = List.generate(8, (i) => 'Activity #${i+1} • Lab/Field/Meet');
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: acts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => GlassCard(child: ListTile(
        leading: const Icon(Icons.science_outlined),
        title: Text(acts[i], style: const TextStyle(fontWeight: FontWeight.w900)),
        trailing: const Icon(Icons.open_in_new),
      )),
    );
  }

  Widget _gallery() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemBuilder: (_, i) => Container(
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text('Photo ${i+1}')),
      ),
    );
  }
}
