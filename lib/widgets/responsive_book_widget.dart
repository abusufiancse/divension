import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BookWidget extends StatelessWidget {

  final String image;


  const BookWidget({
    super.key,
    required this.image,

  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(0.4),
      child: Center(
        child: SizedBox(
          height: 220,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                height: 140.h,
                width: 118.w, // Reduced width
                decoration: BoxDecoration(
                  color: Color(0xFFF8F6EA),
                  border: Border(left:BorderSide(color: Color(0xFF194038),width: 3),right: BorderSide(color: Color(0xFF194038),width: 5),top: BorderSide(color: Color(0xFF194038),width: 3,)),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),

              Positioned(
                top: 3,
                child: Container(
                  height: 133,
                  width: 113, // Reduced width
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F6EA),
                    border: BorderDirectional(start: BorderSide(color: Color(0xFF194038),width: 14)),
                    borderRadius: BorderRadius.only( topLeft: Radius.circular(8),topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                child: Container(
                  height: 130,
                  width: 110, // Reduced width
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F6EA),
                    border: BorderDirectional(start: BorderSide(color: Color(0xFF194038),width: 13)),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 7,
                child: Container(
                  height: 128,
                  width: 107, // Reduced width
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F6EA),
                    border: BorderDirectional(start: BorderSide(color: Color(0xFF194038),width: 12)),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 9,
                child: Container(
                  height: 126,
                  width: 105, // Reduced width
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F6EA),
                    border: BorderDirectional(start: BorderSide(color: Color(0xFF194038),width: 11)),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 11,
                child: Container(
                  height: 124,
                  width: 102, // Reduced width
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F6EA),
                    border: BorderDirectional(start: BorderSide(color: Color(0xFF194038),width: 10)),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 13,
                child: Container(
                  height: 122,
                  width: 105, // Reduced width
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F6EA),
                    border: BorderDirectional(start: BorderSide(color: Color(0xFF194038),width: 9)),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 10,
                child: Container(
                  height: 140,
                  width: 115, // Reduced width
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      )
                    ],
                  ),

                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        width: double.infinity, // Added this line
                        fit: BoxFit.fill,
                        imageUrl: image,
                        errorWidget: (context,_,__)=>Container(),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 1,
                          color: Colors.black12.withOpacity(0.05),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 6,
                        child: Container(
                          width: 1.5,
                          color: Colors.black12.withOpacity(0.05),
                        ),
                      ),

                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 10,
                        child: Container(
                          width: 4,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
