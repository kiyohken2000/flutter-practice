import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お気に入り'),
        toolbarHeight: 40,
      ),
      body: const Center(
          child: Text('お気に入り画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}