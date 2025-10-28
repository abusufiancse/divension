import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookGrid extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  const BookGrid({super.key, required this.books});

  bool _isNetwork(String? src) {
    if (src == null) return false;
    final s = src.trim().toLowerCase();
    return s.startsWith('http://') || s.startsWith('https://');
  }

  Widget _buildCover(String? src) {
    final path = (src == null || src.trim().isEmpty)
        ? 'assets/books/placeholder.jpg'
        : src.trim();

    final img = _isNetwork(path)
        ? Image.network(path, fit: BoxFit.cover)
        : Image.asset(path, fit: BoxFit.cover);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        color: Colors.black12,
        height: 120.h,
        width: double.infinity,
        child: img,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: .58,
      ),
      itemCount: books.length,
      itemBuilder: (_, i) {
        final b = books[i];
        return InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCover(b['image'] as String?),
              SizedBox(height: 6.h),
              Text(
                '${b['title'] ?? ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2.h),
              Text(
                '${b['author'] ?? ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
              ),
            ],
          ),
        );
      },
    );
  }
}
