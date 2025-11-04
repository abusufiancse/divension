// src/screens/blogs_screen.dart
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';

/// Blogs Screen for Science Students
/// Features:
/// - Sections: Latest (horizontal), Popular (grid), All (vertical)
/// - Each post: cover image, title, avatar + author, ~250-word excerpt with See more / See less toggle
/// - Search + category chips
class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _q = '';
  String _selectedCategory = 'All';

  // Track expansion per blog id
  final Map<int, bool> _expanded = {};

  // Sample categories
  final List<String> _categories = ['All', 'Physics', 'Chemistry', 'Biology', 'Math', 'Engineering'];

  // Sample blog data (replace with your real API)
  final List<BlogPost> _posts = List.generate(12, (i) {
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final rnd = Random(i);
    final category = ['Physics','Chemistry','Biology','Math','Engineering'][i % 5];
    final author = ['Ayesha Rahman','Rafi Ahmed','Tania Islam','Shuvo Khan','Mina Akter'][i % 5];
    final title = 'Exploring ${category} topic #${i + 1}';
    final words = List.generate(300, (w) => 'word${w + 1}');
    final content = 'This is a sample blog about $category. ' + words.join(' ');
    return BlogPost(
      id: i,
      title: title,
      authorName: author,
      authorAvatar: 'https://i.pravatar.cc/150?img=${(i % 70) + 1}',
      coverImage: 'https://picsum.photos/seed/blog-$i/800/480',
      category: category,
      publishedAt: DateTime.now().subtract(Duration(days: rnd.nextInt(60))),
      content: content,
      views: rnd.nextInt(2000),
    );
  });

  List<BlogPost> get _latestPosts {
    final filtered = _filteredPosts();
    filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return filtered.take(6).toList();
  }

  List<BlogPost> get _popularPosts {
    final filtered = _filteredPosts();
    filtered.sort((a, b) => b.views.compareTo(a.views));
    return filtered.take(6).toList();
  }

  List<BlogPost> _filteredPosts() {
    return _posts.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesQuery = _q.isEmpty ||
          p.title.toLowerCase().contains(_q) ||
          p.authorName.toLowerCase().contains(_q) ||
          p.content.toLowerCase().contains(_q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

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

  // Truncate to approx 250 words (if available) — otherwise return full
  String _excerpt(String full, {int maxWords = 250}) {
    final words = full.split(RegExp(r'\s+'));
    if (words.length <= maxWords) return full;
    return words.sublist(0, maxWords).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (ctx, child) {
        final theme = Theme.of(ctx);
        final latest = _latestPosts;
        final popular = _popularPosts;
        final all = _filteredPosts();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('Science Blogs', style: AppTextStyles.h2(ctx)),
            backgroundColor: theme.cardColor,
            elevation: 0,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                children: [
                  // Search & categories
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search blogs, authors, keywords...',
                              prefixIcon: const Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      PopupMenuButton<String>(
                        initialValue: _selectedCategory,
                        onSelected: (v) => setState(() => _selectedCategory = v),
                        itemBuilder: (_) => _categories.map((c) => PopupMenuItem(value: c, child: Text(c))).toList(),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.filter_list, size: 18.sp, color: theme.iconTheme.color),
                              SizedBox(width: 6.w),
                              Text(_selectedCategory, style: TextStyle(fontSize: 14.sp)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Expanded(
                    child: ListView(
                      children: [
                        // Latest section
                        _SectionHeader(title: 'Latest Blogs', actionLabel: 'See all', onAction: () {/* scroll or nav */}),
                        SizedBox(
                          height: 370.h,
                          child: latest.isEmpty
                              ? Center(child: Text('No latest posts', style: AppTextStyles.body(ctx)))
                              : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            itemBuilder: (c, i) {
                              final p = latest[i];
                              return SizedBox(
                                width: 300.w,
                                child: _BlogCardCompact(
                                  post: p,
                                  isExpanded: _expanded[p.id] ?? false,
                                  onToggle: () => setState(() => _expanded[p.id] = !(_expanded[p.id] ?? false)),
                                  excerpt: _excerpt(p.content),
                                  onOpen: () => _openFullPost(ctx, p),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(width: 12.w),
                            itemCount: latest.length,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Popular section (grid)
                        _SectionHeader(title: 'Popular Blogs', actionLabel: 'More', onAction: () {}),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width >= 900 ? 3 : 2,
                            mainAxisSpacing: 12.h,
                            crossAxisSpacing: 12.w,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: popular.length,
                          itemBuilder: (c, i) {
                            final p = popular[i];
                            return _BlogCardSmall(
                              post: p,
                              onOpen: () => _openFullPost(ctx, p),
                            );
                          },
                        ),

                        SizedBox(height: 8.h),

                        // All blogs section
                        _SectionHeader(title: 'All Blogs', actionLabel: 'Sort', onAction: () {}),
                        ...all.map((p) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: _BlogCardFull(
                            post: p,
                            isExpanded: _expanded[p.id] ?? false,
                            onToggle: () => setState(() => _expanded[p.id] = !(_expanded[p.id] ?? false)),
                            excerpt: _excerpt(p.content),
                            onOpen: () => _openFullPost(ctx, p),
                          ),
                        )),
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

  void _openFullPost(BuildContext ctx, BlogPost p) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => BlogDetailPage(post: p)));
  }
}

/// Simple section header widget
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h3(context)),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!, style: TextStyle(fontSize: 13.sp)),
            )
        ],
      ),
    );
  }
}

/// Compact horizontal card used in Latest section
class _BlogCardCompact extends StatelessWidget {
  final BlogPost post;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onOpen;
  final String excerpt;
  const _BlogCardCompact({
    required this.post,
    required this.isExpanded,
    required this.onToggle,
    required this.excerpt,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700);
    final authorStyle = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600);

    return GestureDetector(
      onTap: onOpen,
      child: Card(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: CachedNetworkImage(
                imageUrl: post.coverImage,
                height: 110.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(height: 110.h, color: theme.colorScheme.background, child: Center(child: CircularProgressIndicator())),
                errorWidget: (_, __, ___) => Container(height: 110.h, color: theme.colorScheme.background, child: Center(child: Icon(Icons.broken_image))),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      CircleAvatar(radius: 14.r, backgroundImage: NetworkImage(post.authorAvatar)),
                      SizedBox(width: 8.w),
                      Expanded(child: Text(post.authorName, style: authorStyle)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(isExpanded ? post.content : excerpt, style: TextStyle(fontSize: 12.sp, height: 1.35), maxLines: isExpanded ? null : 6, overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis),
                  SizedBox(height: 18.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("See more...", style: AppTextStyles.body(context),),
                      // TextButton(
                      //   onPressed: onToggle,
                      //   child: Text(isExpanded ? 'See less' : 'See more'),
                      // ),
                      Text('${post.views} views', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small grid card for Popular section
class _BlogCardSmall extends StatelessWidget {
  final BlogPost post;
  final VoidCallback onOpen;
  const _BlogCardSmall({required this.post, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onOpen,
      child: Card(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
                child: CachedNetworkImage(
                  imageUrl: post.coverImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: theme.colorScheme.background),
                  errorWidget: (_, __, ___) => Container(color: theme.colorScheme.background, child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 6.h),
                  Row(children: [
                    CircleAvatar(radius: 12.r, backgroundImage: NetworkImage(post.authorAvatar)),
                    SizedBox(width: 8.w),
                    Expanded(child: Text(post.authorName, style: TextStyle(fontSize: 12.sp))),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Full vertical blog card used in "All Blogs"
class _BlogCardFull extends StatelessWidget {
  final BlogPost post;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onOpen;
  final String excerpt;
  const _BlogCardFull({
    required this.post,
    required this.isExpanded,
    required this.onToggle,
    required this.excerpt,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onOpen,
      child: Card(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(post.title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 8.h),

              // Avatar + author + meta
              Row(
                children: [
                  CircleAvatar(radius: 18.r, backgroundImage: NetworkImage(post.authorAvatar)),
                  SizedBox(width: 10.w),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(post.authorName, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 2.h),
                    Text('${post.category} • ${_formatDate(post.publishedAt)}', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                  ]),
                ],
              ),

              SizedBox(height: 12.h),

              // Cover
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  imageUrl: post.coverImage,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(height: 180.h, color: theme.colorScheme.background),
                  errorWidget: (_, __, ___) => Container(height: 180.h, color: theme.colorScheme.background, child: Icon(Icons.broken_image)),
                ),
              ),

              SizedBox(height: 12.h),

              // Excerpt and toggle
              Text(isExpanded ? post.content : excerpt, style: TextStyle(fontSize: 13.sp, height: 1.4), maxLines: isExpanded ? null : 8, overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: onToggle, child: Text(isExpanded ? 'See less' : 'See more')),
                  Row(children: [
                    Icon(Icons.visibility, size: 16.sp, color: Colors.grey),
                    SizedBox(width: 6.w),
                    Text('${post.views}', style: TextStyle(color: Colors.grey)),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

/// Basic detail page for a blog post
class BlogDetailPage extends StatelessWidget {
  final BlogPost post;
  const BlogDetailPage({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title, style: AppTextStyles.h3(context)),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: ListView(
            children: [
              Text(post.title, style: AppTextStyles.h2(context)),
              SizedBox(height: 8.h),
              Row(children: [
                CircleAvatar(radius: 20.r, backgroundImage: NetworkImage(post.authorAvatar)),
                SizedBox(width: 10.w),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(post.authorName, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 2.h),
                  Text('${post.category} • ${post.publishedAt.day}/${post.publishedAt.month}/${post.publishedAt.year}', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ])
              ]),
              SizedBox(height: 12.h),
              ClipRRect(borderRadius: BorderRadius.circular(12.r), child: CachedNetworkImage(imageUrl: post.coverImage, height: 220.h, fit: BoxFit.cover)),
              SizedBox(height: 14.h),
              Text(post.content, style: TextStyle(fontSize: 14.sp, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple model for blog posts used in this demo
class BlogPost {
  final int id;
  final String title;
  final String authorName;
  final String authorAvatar;
  final String coverImage;
  final String category;
  final DateTime publishedAt;
  final String content;
  final int views;

  BlogPost({
    required this.id,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.coverImage,
    required this.category,
    required this.publishedAt,
    required this.content,
    required this.views,
  });
}

/// Quick preview app entry so you can run this screen directly:
void main() {
  runApp(const BlogsPreviewApp());
}

class BlogsPreviewApp extends StatelessWidget {
  const BlogsPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (ctx, child) => MaterialApp(
        title: 'Science Blogs',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const BlogsScreen(),
      ),
    );
  }
}
