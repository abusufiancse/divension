import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool expanded;
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.expanded = true});


  @override
  Widget build(BuildContext context) {
    final child = FilledButton(
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );


    return expanded ? SizedBox(width: double.infinity, height: 44.h, child: child) : child;
  }
}