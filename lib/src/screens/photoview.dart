import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTagDialog extends StatefulWidget {
  final int currentIndex;

  const AddTagDialog({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _AddTagDialogState createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  var _messageController = TextEditingController();
  String messageValue = '';
  bool sendEnable = false;

  addTagToPhoto(String message, int currentIndex) async{
    String idx = currentIndex.toString();
    DocumentReference docRef = FirebaseFirestore.instance.collection('photos').doc(idx);
    final docSnapshop = await docRef.get();
    if (!docSnapshop.exists) {
      DocumentReference ref = FirebaseFirestore.instance.collection('photos').doc(idx);
      ref.set({
        "id": currentIndex,
        "tags": FieldValue.arrayUnion([message])
      });
    } else {
      DocumentReference ref = FirebaseFirestore.instance.collection('photos').doc(idx);
      ref.update({
        "id": currentIndex,
        "tags": FieldValue.arrayUnion([message])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('写真にタグを追加'),
      insetPadding: EdgeInsets.all(8),
      content: TextField(
        maxLength: 8,
        controller: _messageController,
        decoration: InputDecoration(hintText: "3〜8文字"),
        inputFormatters: [
          LengthLimitingTextInputFormatter(15)
        ],
        onChanged: (String s) { //追加
          setState(() {
            messageValue = s;
          });
          if(s.length > 2 && s.length < 9) {
            setState(() {
              sendEnable = true;
            });
          } else {
            setState(() {
              sendEnable = false;
            });
          }
        },
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: GestureDetector(
            child: Text('キャンセル'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        sendEnable?
        GestureDetector(
          child: Text(
            '追加',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onTap: () {
            addTagToPhoto(messageValue, widget.currentIndex);
            Navigator.pop(context);
          },
        )
        :
        Text('追加')
      ],
    );
  }
}

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
  bool isLoading = false;
  List tags = [];
  bool _isTagView = true;

  void _saveImage({image}) async {
    try {
      setState(() {
        isLoading = true;
      });
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
    } finally {
      setState(() {
        isLoading = false;
      });
      HapticFeedback.mediumImpact();
    }
  }

  void _getTags(_currentIndex) async {
    String idx = _currentIndex.toString();
    DocumentReference documentRef = FirebaseFirestore.instance.collection('photos').doc(idx);
    final docSnapshop = await documentRef.get();
    if(docSnapshop.exists) {
      var data;
      final docRef = FirebaseFirestore.instance.collection("photos").doc(idx);
      docRef.snapshots().listen(
        (event) => {
          data = event.data()!['tags'],
          setState(() {
            tags = data;
          })
        },
        onError: (error) => print("Listen failed: $error"),
      );
    } else {
      DocumentReference ref = FirebaseFirestore.instance.collection('photos').doc(idx);
      await ref.set({
        "id": _currentIndex,
        "tags": FieldValue.arrayUnion([])
      });
      var data;
      final docRef = FirebaseFirestore.instance.collection("photos").doc(idx);
      docRef.snapshots().listen(
        (event) => {
          data = event.data()!['tags'],
          setState(() {
            tags = data;
          })
        },
        onError: (error) => print("Listen failed: $error"),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    setState(() {
      _currentIndex = widget.index;
    });
    _getTags(_currentIndex);
  }

  Widget _saveButton() {
    return FloatingActionButton(
      child: Icon(Icons.download),
      heroTag: "save",
      onPressed: () {
        _saveImage(image: widget.photoList[_currentIndex]);
      },
    );
  }

  Widget _isLoading() {
    return Container(
      padding: EdgeInsets.only(right: 10, bottom: 10),
      child: CircularProgressIndicator(),
    );
  }
  
  Widget _addTag() {
    return FloatingActionButton(
      child: Icon(Icons.edit),
      heroTag: "tag",
      backgroundColor: Colors.deepPurple,
      onPressed: () {
        showDialog<void>(
        context: context,
        builder: (_) {
          return AddTagDialog(currentIndex: _currentIndex);
        });
      }
    );
  }

  Widget _tagChips() {
    if(tags.length == 0 || !_isTagView) {
      return Wrap();
    } else {
      return Wrap(
        spacing: 5,
        children: List.generate(
          tags.length,
          (index) {
            return Chip(
              label: Text(tags[index]),
              onDeleted: () {
                String idx = _currentIndex.toString();
                DocumentReference ref = FirebaseFirestore.instance.collection('photos').doc(idx);
                ref.update({
                  "id": _currentIndex,
                  "tags": FieldValue.arrayRemove([tags[index]])
                });
              },
            );
          },
        ),
      );
    }
  }

  Widget _showTagButton() {
    return IconButton(
      icon: Icon(Icons.label_important_outline),
      onPressed: () {
        setState(() {
          _isTagView = true;
        });
      },
    );
  }

  Widget _hideTagButton() {
    return IconButton(
      icon: Icon(Icons.label_important),
      onPressed: () {
        setState(() {
          _isTagView = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('写真'),
        toolbarHeight: 40,
        actions: _isTagView?[_hideTagButton()]:[_showTagButton()],
      ),
      body: Stack(
        children: <Widget>[
          PhotoViewGallery.builder(
            itemCount: widget.photoList.length,
            pageController: _pageController,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(widget.photoList[index]),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
              _getTags(_currentIndex);
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
          Positioned(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _tagChips()
          ),
        ]
      ), 
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: !isLoading ? _saveButton() : _isLoading(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _addTag(),
          )
        ],
      )
    );
  }
}
