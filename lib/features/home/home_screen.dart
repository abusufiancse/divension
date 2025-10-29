// src/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/controllers/theme_controller.dart';
// Other necessary imports
import '../../core/theme/app_text_styles.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/deshboard_header/CosmicZoomHeader.dart';
import '../../widgets/deshboard_header/CosmicZoomHeader2.dart';
import '../../widgets/deshboard_header/DNAScienceHeader.dart';
import '../../widgets/deshboard_header/HistoryTimelineHeader.dart';
import '../../widgets/deshboard_header/PlanetaryLandingHeader.dart';
import '../../widgets/deshboard_header/SpaceLaunchHeader.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_chip.dart';
import '../blogs_screen.dart';
import '../books/books_view.dart';
import '../member_activity_gallery_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    final themeC = Get.find<ThemeController>();

    // ---- Mock data (replace with API) ----
    final memories = [
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1200&auto=format&fit:crop',
      'https://images.unsplash.com/photo-1523978591478-c753949ff840?q=80&w=1200&auto=format&fit:crop',
      'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?q=80&w=1200&auto=format&fit:crop',
    ];
    final magazines = [
      ('Quantum Edition', 'https://images.unsplash.com/photo-1520975661595-6453be3f7070?q=80&w=1400&auto=format&fit:crop'),
      ('Climate Issue', 'https://images.unsplash.com/photo-1502303756782-5eeea00dcdc0?q=80&w=1400&auto=format&fit:crop'),
      ('Neuro Focus', 'https://images.unsplash.com/photo-1559757175-08c9c3f5f2d7?q=80&w=1400&auto=format&fit:crop'),
    ];
    final events = [
      ('Seminar: AI & Health', 'Oct 20, 2025 • Auditorium A', 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?q=80&w=1200&auto=format&fit:crop'),
      ('Workshop: Lab Safety', 'Oct 28, 2025 • Lab 3', 'https://images.unsplash.com/photo-1581092921461-eab62e97a780?q=80&w=1200&auto=format&fit:crop'),
      ('Meetup: Astro Night', 'Nov 03, 2025 • Rooftop', 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?q=80&w=1200&auto=format&fit:crop'),
    ];
    final blogs = [
      ('Why Research Matters', 'https://images.unsplash.com/photo-1513258496099-48168024aec0?q=80&w=1200&auto=format&fit:crop'),
      ('Policy & Science', 'https://images.unsplash.com/photo-1520697222860-7b52b39a3e31?q=80&w=1200&auto=format&fit:crop'),
      ('The New Space Race', 'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?q=80&w=1200&auto=format&fit:crop'),
    ];
    final diventionItems = <Map<String, String>>[
      {'name': 'Divention Alpha', 'img': 'https://images.unsplash.com/photo-1581093588401-16f8c8d1f3a0?q=80&w=800&auto=format&fit:crop'},
      {'name': 'Divention Beta', 'img': 'https://images.unsplash.com/photo-1559757175-08fda9f6f2b0?q=80&w=800&auto=format&fit:crop'},
      {'name': 'Divention Gamma', 'img': 'https://images.unsplash.com/photo-1507413245164-6160d8298b31?q=80&w=800&auto=format&fit:crop'},
      {'name': 'Divention Delta', 'img': 'https://images.unsplash.com/photo-1559757178-5c350d0d3d4e?q=80&w=800&auto=format&fit:crop'},
      {'name': 'Divention Sigma', 'img': 'https://images.unsplash.com/photo-1559757175-09a5b9a1b3b2?q=80&w=800&auto=format&fit:crop'},
      {'name': 'Divention Orion', 'img': 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?q=80&w=800&auto=format&fit:crop'},
      {'name': 'Divention Nova', 'img': 'https://images.unsplash.com/photo-1535930749574-1399327ce78f?q=80&w=800&auto=format&fit:crop'},
      {'name': 'Divention Zenith', 'img': 'https://images.unsplash.com/photo-1518779578993-ec3579fee39f?q=80&w=800&auto=format&fit:crop'},
    ];
    // ------------------------------------------
    final pages = [
      // ✅ Home screen with AppBar
      Scaffold(
        drawer: const AppDrawer(),
        body: CustomScrollView(
          slivers: [
            // ---------- Hero Banner ----------
            SliverAppBar(
              // Core Behavior
              pinned: true,
              expandedHeight: 280.h,
              backgroundColor: Theme.of(context).cardColor,

              // CRITICAL: Set title here, wrapped in the custom logic
              title: CollapsedContentVisibility(
                child: Text(
                  'Divention Science Club',
                  style: AppTextStyles.h2(context),
                ),
              ),

              // CRITICAL: Set actions here, wrapped in the custom logic
              actions: [
                CollapsedContentVisibility(
                  child: IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    icon: const Icon(Icons.login_rounded),
                  ),
                ),
              ],

              // Ensure leading icon is hidden when expanded (usually this is automatic if title/actions are hidden)
              // You might need to adjust the color of the icons depending on your background.
              // automaticallyImplyLeading: true, // Keep this default if you want a back button

              flexibleSpace: FlexibleSpaceBar(
                // IMPORTANT: Set FlexibleSpaceBar.title to null
                title: null,
                // background: CosmicZoomHeader(),
                // background: PlanetaryLandingHeader(),
                // background: DNAScienceHeader(),
                //  background: SpaceLaunchHeader(),
                //  background: PlanetaryLandingHeader(),// 2
                 background: HistoryTimelineHeader(),// 2
              ),
            ),

            // ---------- Stats (No text style change needed in StatChip for this update) ----------
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 72.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  children: [
                    StatChip(icon: Icons.apartment_rounded, value: 'Divention', label: 'Club Name'),
                    SizedBox(width: 5.w),
                    StatChip(icon: Icons.groups_rounded, value: '1,240', label: 'Total Members'),
                    SizedBox(width: 5.w),
                    StatChip(icon: Icons.menu_book_rounded, value: '48', label: 'Science Magazines'),
                    SizedBox(width: 5.w),
                    StatChip(icon: Icons.event_available_rounded, value: '23', label: 'Events'),
                  ],
                ),
              ),
            ),

            // ---------- Club Memories ----------
            const SliverToBoxAdapter(child: SectionHeader(title: 'Club Memories')),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 170.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: memories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (_, i) => _MemoryCard(imageUrl: memories[i]),
                ),
              ),
            ),

            // ---------- Science Magazine (Carousel) ----------
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Science Magazine',
                onSeeAll: () => Navigator.pushNamed(context, '/magazine'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220.h,
                child: PageView.builder(
                  controller: PageController(viewportFraction: .86),
                  itemCount: magazines.length,
                  itemBuilder: (_, i) {
                    final (title, cover) = magazines[i];
                    return _MagazineHeroCard(title: title, imageUrl: cover);
                  },
                ),
              ),
            ),

            // ---------- Upcoming Events ----------
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Upcoming Events',
                onSeeAll: () => Navigator.pushNamed(context, '/events'),
              ),
            ),
            SliverList.separated(
              itemCount: events.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (_, i) {
                final (title, meta, img) = events[i];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GlassCard(
                    child: Row(
                      children: [
                        _Thumb(url: img, size: 64.w),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: AppTextStyles.h2(context).copyWith(fontSize: 16.sp), // <--- Use AppTextStyles.h2 base
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                meta,
                                style: AppTextStyles.body(context), // <--- Use AppTextStyles.body
                              ),
                            ],
                          ),
                        ),
                        FilledButton.tonal(onPressed: () {}, child: const Text('Details')),
                      ],
                    ),
                  ),
                );
              },
            ),

            // ---------- Blogs ----------
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Blogs',
                onSeeAll: () => Navigator.pushNamed(context, '/blogs'),
              ),
            ),
            SliverList.separated(
              itemCount: blogs.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (_, i) {
                final (title, img) = blogs[i];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GlassCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.w),
                      leading: _Thumb(url: img, size: 56.w, radius: 12.w),
                      title: Text(
                        title,
                        style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w900), // <--- Use AppTextStyles.body base
                      ),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      onTap: () {},
                    ),
                  ),
                );
              },
            ),

            // ---------- Divention Names ----------
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Divention Names',
                onSeeAll: () => Navigator.pushNamed(context, '/divention-names'),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: 0.h),
            ),

            SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final cols = width >= 1100 ? 4 : width >= 800 ? 3 : 2;
                final gap = 12.w;

                final items = diventionItems;
                final rowCount = (items.length / cols).ceil();

                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 24.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, rowIndex) {
                        final start = rowIndex * cols;
                        final end = (start + cols).clamp(0, items.length);
                        final rowItems = items.sublist(start, end);

                        return Padding(
                          padding: EdgeInsets.only(bottom: rowIndex == rowCount - 1 ? 0 : gap),
                          child: Row(
                            children: List.generate(cols, (i) {
                              final hasData = i < rowItems.length;
                              final card = hasData
                                  ? _DiventionCard(
                                name: rowItems[i]['name']!,
                                imageUrl: rowItems[i]['img']!,
                                onTap: () {},
                              )
                                  : const SizedBox.shrink();

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: i == cols - 1 ? 0 : gap),
                                  child: AspectRatio(
                                    aspectRatio: 1.18,
                                    child: card,
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                      childCount: rowCount,
                    ),
                  ),
                );
              },
            ),

          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () => Navigator.pushNamed(context, '/activity-gallery'),
        //   icon: const Icon(Icons.photo_library_outlined),
        //   label: const Text('Activity Gallery'),
        // ),
      ),
      // ✅ Other tabs
      const BooksView(),
      const MemberActivityGalleryScreen(),
      const BlogsScreen(),
    ];
    return Obx(() => Scaffold(
      body: IndexedStack(index: c.tabIndex.value, children: pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: c.tabIndex.value,
        onTabChange: c.changeTab,
      ),
    ));
  }
}

/// ============== Small, reusable widgets (styles also updated here) ==============

class _NetImage extends StatelessWidget {
  final String url;
  final double? radius;
  const _NetImage({required this.url, this.radius});

  @override
  Widget build(BuildContext context) {
    final child = Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (c, w, progress) {
        if (progress == null) return w;
        return Container(
          color: Colors.black12.withOpacity(.05),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.w)),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: Colors.black12.withOpacity(.08),
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined),
      ),
    );

    return radius == null
        ? child
        : ClipRRect(borderRadius: BorderRadius.circular(radius!), child: child);
  }
}

class _MemoryCard extends StatelessWidget {
  final String imageUrl;
  const _MemoryCard({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GlassCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.w),
          child: _NetImage(url: imageUrl),
        ),
      ),
    );
  }
}

class _MagazineHeroCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  const _MagazineHeroCard({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22.w),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _NetImage(url: imageUrl),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.black.withOpacity(.65), Colors.transparent],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h1(context).copyWith(color: Colors.white, fontSize: 18.sp), // <--- Use AppTextStyles.h1 base
                  ),
                ),
                SizedBox(width: 10.w),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: cs.primary),
                  onPressed: () {},
                  child: const Text('Open'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  final double size;
  final double radius;
  const _Thumb({required this.url, this.size = 64, this.radius = 14});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: _NetImage(url: url),
      ),
    );
  }
}

class _DiventionCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;
  const _DiventionCard({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.w),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
          // Note: AppColors aren't used directly here, but AppTheme's colorScheme is
          gradient: LinearGradient(
            colors: [
              cs.surface.withOpacity(.30),
              (cs.surfaceTint ?? cs.primary).withOpacity(.16),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(.12)),
          boxShadow: const [
            BoxShadow(blurRadius: 12, color: Colors.black26, offset: Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.w),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return const _ShimmerPlaceholder();
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: cs.surfaceVariant.withOpacity(.35),
                    child: Center(
                      child: Icon(Icons.broken_image_outlined, size: 28.w, color: Colors.white70),
                    ),
                  ),
                ),
              ),

              // bottom gradient overlay
              Positioned(
                left: 0, right: 0, bottom: 0, height: 90.h,
                child: const IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xCC000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ),
              ),

              // name
              Positioned(
                left: 12.w, right: 12.w, bottom: 12.h,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5.sp,
                    letterSpacing: .2,
                    shadows: const [Shadow(blurRadius: 10, color: Colors.black54, offset: Offset(0, 2))],
                  ), // <--- Use AppTextStyles.body base
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatefulWidget {
  const _ShimmerPlaceholder();
  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1, 0),
              end: Alignment(1, 0),
              colors: [
                Color(0x22222222),
                Color(0x44222222),
                Color(0x22222222),
              ],
              stops: [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}

//? Sliver Appbar code
// Custom Widget to control visibility based on collapse state
class CollapsedContentVisibility extends StatelessWidget {
  const CollapsedContentVisibility({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Access the current collapse settings of the FlexibleSpaceBar
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();

    // Check if the current extent is equal to the minimum extent (i.e., fully collapsed)
    final isCollapsed = settings != null && settings.currentExtent <= settings.minExtent;

    // Use an AnimatedOpacity for a smooth transition
    return AnimatedOpacity(
      opacity: isCollapsed ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }
}