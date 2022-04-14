import 'package:flutter/material.dart';

class PhotoviewScreen extends StatefulWidget {
  final String image;

  const PhotoviewScreen({
    Key? key,
    required this.image
  }) : super(key: key);
  
  @override
  _PhotoviewScreenState createState() => _PhotoviewScreenState();
}

class _PhotoviewScreenState extends State<PhotoviewScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('写真'),
        toolbarHeight: 40,
      ),
      body: Center(child: Image.asset(widget.image)),
    );
  }
}
