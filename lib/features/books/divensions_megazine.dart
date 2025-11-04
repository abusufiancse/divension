import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_text_styles.dart';
import '../../widgets/responsive_book_widget.dart'; // ensure this path is correct

/// The Divension Magazine screen
class DivensionMagazine extends StatefulWidget {
  const DivensionMagazine({super.key});

  @override
  State<DivensionMagazine> createState() => _DivensionMagazineState();
}

class _DivensionMagazineState extends State<DivensionMagazine> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  /// When null => no year selected (show all-year rows).
  /// When int => that year selected (show full-screen grid for that year).
  int? _selectedYear;

  // Minimal sample data: replace with your real URLs.
  final Map<int, List<Map<String, String>>> _data = {
    2025: List.generate(12, (i) {
      final monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return {
        'month': monthNames[i],
        // placeholder images — swap for real covers
        'image': 'https://picsum.photos/seed/2025-$i/400/600',
      };
    }),
    2024: List.generate(12, (i) {
      final monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return {
        'month': monthNames[i],
        'image': 'https://picsum.photos/seed/2024-$i/400/600',
      };
    }),
    2023: List.generate(12, (i) {
      final monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return {
        'month': monthNames[i],
        'image': 'https://picsum.photos/seed/2024-$i/400/600',
      };
    }),
    // add more years if you want
  };

  List<int> get sortedYears {
    final years = _data.keys.toList();
    years.sort((a, b) => b.compareTo(a)); // descending (latest first)
    return years;
  }

  @override
  void initState() {
    super.initState();
    // default: no year selected to show all-year rows
    _selectedYear = null;

    _searchController.addListener(() => setState(() {
      _query = _searchController.text.trim().toLowerCase();
    }));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// get issues for a year, optionally filtered by _query.
  List<Map<String, String>> _issuesForYear(int year) {
    final issues = _data[year] ?? [];
    if (_query.isEmpty) return issues;
    return issues.where((issue) => issue['month']!.toLowerCase().contains(_query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Divension Megazine',
          style: AppTextStyles.h2(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            // Search bar
            Material(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search month or issue...',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Year selector chips (tapping selects/unselects)
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sortedYears.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (context, idx) {
                  final y = sortedYears[idx];
                  final selected = y == _selectedYear;
                  return ChoiceChip(
                    label: Text('$y'),
                    selected: selected,
                    onSelected: (v) {
                      setState(() {
                        // toggle: select year or clear selection
                        _selectedYear = selected ? null : y;
                      });
                    },
                    selectedColor: Colors.black,
                    backgroundColor: Theme.of(context).cardColor,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    elevation: selected ? 4 : 1,
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // Main content:
            // - If no year selected => show all years as horizontal rows (latest month first in each row)
            // - If a year is selected => show full-screen grid for that year (BookWidget)
            Expanded(
              child: _selectedYear == null ? _buildAllYearsView() : _buildSelectedYearGrid(_selectedYear!),
            ),
          ],
        ),
      ),
    );
  }

  /// Build view showing every year as a horizontal row of issues.
  Widget _buildAllYearsView() {
    return ListView.separated(
      itemCount: sortedYears.length,
      separatorBuilder: (_, __) => SizedBox(height: 20.h),
      itemBuilder: (context, yIndex) {
        final year = sortedYears[yIndex];
        final issues = _issuesForYear(year).reversed.toList(); // newest first
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year header with small "View all" button
            Padding(
              padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$year Editions',
                    style: AppTextStyles.h3(context),
                  ),
                  TextButton(
                    onPressed: () {
                      // select this year to view full grid
                      setState(() => _selectedYear = year);
                    },
                    child: Text('View all', style: TextStyle(fontSize: 12.sp)),
                  )
                ],
              ),
            ),

            if (issues.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(child: Text('No editions for $year', style: AppTextStyles.h1(context)))
              )
            else
              SizedBox(
                height: 240.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: issues.length,
                  separatorBuilder: (_, __) => SizedBox(width: 14.w),
                  padding: EdgeInsets.only(right: 16.w),
                  itemBuilder: (context, i) {
                    final issue = issues[i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120.w,
                          child: BookWidget(image: issue['image'] ?? ''),
                        ),
                        SizedBox(
                          width: 120.w,
                          child: Text(
                            issue['month'] ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  /// Build full-screen grid for a single selected year using BookWidget.
  Widget _buildSelectedYearGrid(int year) {
    final issues = _issuesForYear(year).reversed.toList(); // newest first
    return Column(
      children: [
        // Header row with close/unselect action
        Padding(
          padding: EdgeInsets.only(bottom: 12.h, left: 4.w, right: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$year Editions', style: AppTextStyles.h3(context)),
              TextButton.icon(
                onPressed: () => setState(() => _selectedYear = null),
                icon: Icon(Icons.arrow_back, size: 16.sp),
                label: Text('Back', style: TextStyle(fontSize: 12.sp)),
              )
            ],
          ),
        ),

        Expanded(
          child: issues.isEmpty
              ? Center(child: Text('No editions found for $year', style: TextStyle(color: Colors.black54)))
              : GridView.builder(
            padding: EdgeInsets.only(bottom: 20.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // adjust for density/size
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.62,
            ),
            itemCount: issues.length,
            itemBuilder: (context, idx) {
              final issue = issues[idx];
              return Column(
                children: [
                  // Use BookWidget for consistent look
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: BookWidget(image: issue['image'] ?? ''),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    issue['month'] ?? '',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Example main — initializes ScreenUtil and runs the screen.
void main() {
  runApp(const DivensionApp());
}

class DivensionApp extends StatelessWidget {
  const DivensionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // optional design size; adjust to your design reference
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Divension Megazine',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF6F7F9),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
        ),
        home: const DivensionMagazine(),
      ),
    );
  }
}
