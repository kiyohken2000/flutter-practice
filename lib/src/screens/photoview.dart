import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoviewScreen extends StatefulWidget {
  final int index;
  final List photoList;

  const PhotoviewScreen({
    Key? key,
    required this.index,
    required this.photoList
  }) : super(key: key);
  
  @override
  _PhotoviewScreenState createState() => _PhotoviewScreenState();
}

class _PhotoviewScreenState extends State<PhotoviewScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('写真'),
        toolbarHeight: 40,
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.photoList.length,
        pageController: _pageController,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.photoList[index]),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}
