// src/widgets/stat_chip.dart
import 'package:flutter/material.dart';
class StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const StatChip({super.key, required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffdedede)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xffeef6ff),
            child: Icon(
              icon,
              color: const Color(0xff2972ff),
            )),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            Text(label, style: const TextStyle(color: Color(0xff6a7187))),
          ])
        ],
      ),
    );
  }
}
