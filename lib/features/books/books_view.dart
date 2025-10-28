import 'package:flutter/material.dart';

class BooksView extends StatelessWidget {
  const BooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-Books')),
      body: const Center(child: Text('E-Book screen (static for now)')),
    );
  }
}
