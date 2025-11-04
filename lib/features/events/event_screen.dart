// lib/screens/events_screen.dart
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

/// Events screen with Upcoming & Previous events, registration & interested toggles,
/// detail page with gallery, activities and media (Drive/YouTube) box.
/// Replace sample data with your real API calls.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _q = '';

  // Track saved/interested and registration per event id.
  final Map<int, bool> _interested = {};
  final Map<int, bool> _registered = {};
  final Map<int, bool> _expanded = {};

  // Sample events (replace with API)
  final List<EventModel> _events = [
    EventModel(
      id: 1,
      title: 'Interstellar Physics Seminar',
      summary: 'A seminar about dark matter, gravitational waves and observational astrophysics.',
      details:
      'Join experts to discuss the latest in gravitational wave detections, dark matter searches and observational techniques. This seminar includes lightning talks, Q&A, and a poster session.',
      coverImage: 'https://picsum.photos/seed/event1/900/500',
      date: DateTime.now().add(const Duration(days: 6)),
      location: 'Auditorium A',
      isUpcoming: true,
      photos: [
        'https://picsum.photos/seed/event1-1/800/600',
        'https://picsum.photos/seed/event1-2/800/600',
      ],
      activities: ['Keynote: Prof. X', 'Student lightning talks', 'Poster session', 'Networking'],
      driveLink: 'https://drive.google.com/example-event1',
      youtubeLink: 'https://youtube.com/watch?v=example1',
    ),
    EventModel(
      id: 2,
      title: 'Chemistry Lab Safety Workshop',
      summary: 'Hands-on workshop covering modern lab safety protocols and emergency responses.',
      details: 'Practical demos, PPE usage, chemical handling, waste disposal and emergency drills.',
      coverImage: 'https://picsum.photos/seed/event2/900/500',
      date: DateTime.now().add(const Duration(days: 20)),
      location: 'Chem Lab 3',
      isUpcoming: true,
      photos: [],
      activities: ['PPE demo', 'Spill management', 'Fire extinguisher demo'],
      driveLink: '',
      youtubeLink: '',
    ),
    EventModel(
      id: 3,
      title: 'Biology Field Trip — Wetland Survey',
      summary: 'Student-led wetland biodiversity survey and species identification workshop.',
      details:
      'Students surveyed biodiversity, performed water quality tests, and documented species. The event included team presentations and data uploads to the department portal.',
      coverImage: 'https://picsum.photos/seed/event3/900/500',
      date: DateTime.now().subtract(const Duration(days: 40)),
      location: 'Riverside Wetlands',
      isUpcoming: false,
      photos: [
        'https://picsum.photos/seed/event3-1/900/600',
        'https://picsum.photos/seed/event3-2/900/600',
        'https://picsum.photos/seed/event3-3/900/600',
      ],
      activities: ['Water sampling', 'Species ID', 'Student presentations', 'Data upload'],
      driveLink: 'https://drive.google.com/example-event3',
      youtubeLink: 'https://youtube.com/watch?v=example3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _q = _searchController.text.trim().toLowerCase()));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EventModel> get _upcoming => _events.where((e) => e.isUpcoming && _matchesQuery(e)).toList()..sort((a,b)=>a.date.compareTo(b.date));
  List<EventModel> get _previous => _events.where((e) => !e.isUpcoming && _matchesQuery(e)).toList()..sort((a,b)=>b.date.compareTo(a.date));

  bool _matchesQuery(EventModel e) {
    if (_q.isEmpty) return true;
    final q = _q;
    return e.title.toLowerCase().contains(q) || e.summary.toLowerCase().contains(q) || e.location.toLowerCase().contains(q);
  }

  Future<void> _onRegister(int id) async {
    // Simulate server call / validation before marking registered
    setState(() => _registered[id] = true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered successfully')));
  }

  void _toggleInterested(int id) {
    setState(() => _interested[id] = !(_interested[id] ?? false));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text((_interested[id] ?? false) ? 'Marked Interested' : 'Removed from Interested')),
    );
  }

  void _openDetail(EventModel event) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventDetailPage(
      event: event,
      isInterested: _interested[event.id] ?? false,
      isRegistered: _registered[event.id] ?? false,
      onToggleInterested: () => _toggleInterested(event.id),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (ctx, child) {
        final theme = Theme.of(ctx);
        final upcoming = _upcoming;
        final previous = _previous;

        return Scaffold(
          appBar: AppBar(
            title: Text('Events', style: AppTextStyles.h2(ctx)),
            backgroundColor: theme.cardColor,
            elevation: 0,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                children: [
                  // Search
                  Material(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search events, locations...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Expanded(
                    child: ListView(
                      children: [
                        // Upcoming
                        _SectionHeader(title: 'Upcoming Events', actionLabel: 'See all', onAction: () {/* navigate to all upcoming */}),
                        SizedBox(
                          height: 315.h,
                          child: upcoming.isEmpty
                              ? Center(child: Text('No upcoming events', style: AppTextStyles.body(ctx)))
                              : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcoming.length,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            separatorBuilder: (_,__) => SizedBox(width: 12.w),
                            itemBuilder: (c,i) {
                              final e = upcoming[i];
                              final hero = 'event-cover-${e.id}';
                              final expanded = _expanded[e.id] ?? false;
                              return Container(
                                width: 320.w,
                                decoration: BoxDecoration(color: theme.cardColor,
                                borderRadius: BorderRadius.circular(16)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Cover image with hero
                                    GestureDetector(
                                      onTap: () => _openDetail(e),
                                      child: Hero(
                                        tag: hero,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                                          child: CachedNetworkImage(
                                            imageUrl: e.coverImage,
                                            height: 120.h,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (_,__) => Container(height: 120.h, color: theme.colorScheme.surface),
                                            errorWidget: (_,__,___) => Container(height: 120.h, color: theme.colorScheme.surface, child: Icon(Icons.broken_image)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                                          SizedBox(height: 6.h),
                                          Row(children: [
                                            Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
                                            SizedBox(width: 6.w),
                                            Text(_formatDate(e.date), style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                                            SizedBox(width: 12.w),
                                            Icon(Icons.place, size: 14.sp, color: Colors.grey),
                                            SizedBox(width: 6.w),
                                            Expanded(child: Text(e.location, style: TextStyle(fontSize: 12.sp, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                          ]),
                                          SizedBox(height: 8.h),
                                          Text(expanded ? e.details : e.summary, style: TextStyle(fontSize: 13.sp, height: 1.35), maxLines: expanded ? null : 3, overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis),
                                          SizedBox(height: 8.h),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(children: [
                                                IconButton(
                                                  onPressed: () => _toggleInterested(e.id),
                                                  icon: Icon(_interested[e.id] ?? false ? Icons.bookmark : Icons.bookmark_outline),
                                                ),
                                                SizedBox(width: 8.w),
                                                InkWell(
                                                  onTap: _registered[e.id] == true ? null : () => _onRegister(e.id),
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                                                    decoration:BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      color: Colors.grey,
                                                    ),
                                                      child: Text(_registered[e.id] == true ? 'Registered' : 'Register')),
                                                ),
                                              ]),
                                              // TextButton(onPressed: () => setState(()=> _expanded[e.id] = !( _expanded[e.id] ?? false)), child: Text(expanded ? 'See less' : 'See more')),
                                              Text("See more", style: AppTextStyles.body(context),),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 14.h),

                        // Previous
                        _SectionHeader(title: 'Previous Events', actionLabel: null, onAction: null),
                        previous.isEmpty
                            ? Center(child: Text('No previous events', style: AppTextStyles.body(ctx)))
                            : Column(
                          children: previous.map((e) {
                            final hero = 'event-cover-${e.id}';
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Card(
                                color: theme.cardColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                child: InkWell(
                                  onTap: () => _openDetail(e),
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: hero,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                                          child: CachedNetworkImage(
                                            imageUrl: e.coverImage,
                                            height: 160.h,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (_,__) => Container(height: 160.h, color: theme.colorScheme.surface),
                                            errorWidget: (_,__,___) => Container(height: 160.h, color: theme.colorScheme.surface, child: Icon(Icons.broken_image)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(12.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(e.title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
                                            SizedBox(height: 6.h),
                                            Row(children: [
                                              Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
                                              SizedBox(width: 6.w),
                                              Text(_formatDate(e.date), style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                                              SizedBox(width: 12.w),
                                              Icon(Icons.place, size: 14.sp, color: Colors.grey),
                                              SizedBox(width: 6.w),
                                              Expanded(child: Text(e.location, style: TextStyle(fontSize: 12.sp, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                            ]),
                                            SizedBox(height: 8.h),
                                            Text(e.summary, style: TextStyle(fontSize: 13.sp, height: 1.35), maxLines: 3, overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

/// Event detail page: gallery, activities, and media box for drive/youtube.
class EventDetailPage extends StatelessWidget {
  final EventModel event;
  final bool isInterested;
  final bool isRegistered;
  final VoidCallback onToggleInterested;

  const EventDetailPage({
    super.key,
    required this.event,
    required this.isInterested,
    required this.isRegistered,
    required this.onToggleInterested,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title, style: AppTextStyles.h3(context)),
        backgroundColor: theme.cardColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: onToggleInterested,
            icon: Icon(isInterested ? Icons.bookmark : Icons.bookmark_outline),
            tooltip: isInterested ? 'Saved (Interested)' : 'Mark as Interested',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: ListView(
            children: [
              Hero(
                tag: 'event-cover-${event.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: event.coverImage,
                    height: 220.h,
                    fit: BoxFit.cover,
                    placeholder: (_,__) => Container(height: 220.h, color: theme.colorScheme.surface),
                    errorWidget: (_,__,___) => Container(height: 220.h, color: theme.colorScheme.surface, child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(event.title, style: AppTextStyles.h2(context)),
                  SizedBox(height: 6.h),
                  Text('${_formatDate(event.date)} • ${event.location}', style: AppTextStyles.body(context)),
                ]),
                Column(children: [
                  ElevatedButton(
                    onPressed: event.isUpcoming ? (isRegistered ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered (demo)')));
                    }) : null,
                    child: Text(event.isUpcoming ? (isRegistered ? 'Registered' : 'Register') : 'Past event'),
                  ),
                ]),
              ]),
              SizedBox(height: 12.h),
              Text(event.details, style: AppTextStyles.body(context)),

              SizedBox(height: 16.h),
              Text('Activities', style: AppTextStyles.h3(context)),
              SizedBox(height: 8.h),
              ...event.activities.map((a) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(children: [
                  Icon(Icons.check_circle_outline, size: 18.sp, color: Colors.green),
                  SizedBox(width: 8.w),
                  Expanded(child: Text(a, style: TextStyle(fontSize: 14.sp))),
                ]),
              )),

              SizedBox(height: 16.h),
              if (event.photos.isNotEmpty) ...[
                Text('Gallery', style: AppTextStyles.h3(context)),
                SizedBox(height: 8.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: event.photos.length,
                  itemBuilder: (c,i) {
                    final url = event.photos[i];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (_,__) => Container(color: theme.colorScheme.surface),
                        errorWidget: (_,__,___) => Container(color: theme.colorScheme.surface, child: Icon(Icons.broken_image)),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12.h),
              ],

              // Media box (Drive / YouTube)
              Text('Media', style: AppTextStyles.h3(context)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _MediaTile(
                      label: 'Drive',
                      url: event.driveLink,
                      icon: Icons.folder,
                      onTap: () {
                        // TODO: launch URL with url_launcher
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.driveLink.isNotEmpty ? 'Open Drive link' : 'No Drive link available')));
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _MediaTile(
                      label: 'YouTube',
                      url: event.youtubeLink,
                      icon: Icons.play_circle_fill,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.youtubeLink.isNotEmpty ? 'Open YouTube link' : 'No YouTube link available')));
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

class _MediaTile extends StatelessWidget {
  final String label;
  final String url;
  final IconData icon;
  final VoidCallback onTap;
  const _MediaTile({required this.label, required this.url, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28.sp),
            SizedBox(width: 12.w),
            Expanded(child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700))),
            Icon(Icons.open_in_new, size: 16.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

/// Section header
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h3(context)),
          if (actionLabel != null) TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

/// Event model for demo
class EventModel {
  final int id;
  final String title;
  final String summary;
  final String details;
  final String coverImage;
  final DateTime date;
  final String location;
  final bool isUpcoming;
  final List<String> photos;
  final List<String> activities;
  final String driveLink;
  final String youtubeLink;

  EventModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.details,
    required this.coverImage,
    required this.date,
    required this.location,
    required this.isUpcoming,
    required this.photos,
    required this.activities,
    required this.driveLink,
    required this.youtubeLink,
  });
}

/// Preview app entry for testing the events screen
void main() {
  runApp(const EventsPreviewApp());
}

class EventsPreviewApp extends StatelessWidget {
  const EventsPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Events Preview',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const EventsScreen(),
      ),
    );
  }
}
