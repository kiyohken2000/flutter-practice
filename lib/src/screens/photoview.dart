import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  int _currentIndex = 0;
  String infoMessage = '';

  void _saveImage({image}) async {
    try {
      var response = await Dio()
        .get(image, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "messageImage");

      if (result.containsKey('isSuccess')) {
        this.infoMessage = '写真の保存に成功しました';
        Fluttertoast.showToast(
          msg: '保存しました',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    } catch (e) {
      this.infoMessage = '保存に失敗しました';
        Fluttertoast.showToast(msg: '保存に失敗しました');
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    setState(() {
      _currentIndex = widget.index;
    });
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
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () {
          _saveImage(image: widget.photoList[_currentIndex]);
        },
      ),
    );
  }
}
