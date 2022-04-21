import 'package:flutter/material.dart';

import 'screens/account.dart';
import 'screens/speech.dart';
import 'screens/galery.dart';
import 'screens/notification.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const _screens = [
    SpeechScreen(),
    GaleryScreen(),
    AccountScreen(),
    NotificationScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '発言'),
          BottomNavigationBarItem(icon: Icon(Icons.image_aspect_ratio), label: 'ギャラリー'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '通知'),
        ],
        type: BottomNavigationBarType.fixed,
      )
    );
  }
}