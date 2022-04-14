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
          const Center(
            child: Image(image: AssetImage('assets/images/avatar.jpg'))
          ),
    );
  }
}