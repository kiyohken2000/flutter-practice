import 'package:flutter/material.dart';
import 'detail.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void sayHello(String name) {
    debugPrint("Hello! $name");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        toolbarHeight: 40,
      ),
      body: SizedBox(
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map'),
              onTap: () {
                sayHello('map');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(context) {
                      return DetailScreen(title: '詳細', myname: 'map');
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Album'),
              onTap: () {
                sayHello('album');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(context) {
                      return DetailScreen(title: '詳細', myname: 'album!');
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              onTap: () {
                sayHello('phone');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(context) {
                      return DetailScreen(title: '詳細', myname: 'phone!!!');
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
