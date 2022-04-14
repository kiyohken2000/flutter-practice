import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {

  const BookmarkScreen({
    Key? key,
  }) : super(key: key);
  
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お気に入り'),
        toolbarHeight: 40,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('this is text'),
            Text('this is second text'),
          ],
        ),
      ),
    );
  }
}
