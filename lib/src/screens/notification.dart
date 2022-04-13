import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お知らせ'),
        toolbarHeight: 40,
      ),
      body:
          const Center(child: Text('お知らせ画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}