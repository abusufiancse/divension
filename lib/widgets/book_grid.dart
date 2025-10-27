import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookGrid extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  const BookGrid({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: books.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: .74,
      ),
      itemBuilder: (_, i) => _BookCard(book: books[i]),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).cardColor;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover with badge
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: (book['image'] as String).isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: book['image'],
                      fit: BoxFit.cover,
                    )
                        : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.15),
                            Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (book['badge'] != null && (book['badge'] as String).isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        book['badge'],
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 8.h),

            // Book title
            Text(
              book['title'] ?? 'Untitled Book',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 4.h),

            // Author
            Text(
              book['author'] ?? 'Unknown Author',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: Theme.of(context).hintColor,
              ),
            ),

            const Spacer(),

            // Price / Free label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  book['price'] == 0
                      ? 'Free'
                      : '\$${book['price'].toString()}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: book['price'] == 0
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
