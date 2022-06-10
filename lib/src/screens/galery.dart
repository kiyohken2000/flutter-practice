import 'package:flutter/material.dart';
import 'photoview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GaleryScreen extends StatefulWidget {

  const GaleryScreen({
    Key? key,
  }) : super(key: key);
  
  @override
  _GaleryScreenState createState() => _GaleryScreenState();
}

class _GaleryScreenState extends State<GaleryScreen> {
  var galery = <String, dynamic>{};
  int photoCount = 0;
  String galeryRef = 'appstore';
  List photoList = [];
  List tagList = [];
  List<dynamic> documentList = [];
  bool _searchBoolean = false;
  String selectedTag = '';
  bool tagSelected = false;
  List filteredPhotos = [];

  void loadGalery() async {
    final docRef = FirebaseFirestore.instance.collection('galery').doc('xcpa16TZ6IlV65I2D7KF'); // DocumentReference
    final docSnapshot = await docRef.get(); // DocumentSnapshot
    final data = docSnapshot.exists ? docSnapshot.data() : null; // `data()`で中身を取り出す
    setState(() {
      galery = data!;
    });
    setState(() {
      photoCount = galery['count'];
      galeryRef = galery['ref'];
    });
    setState(() {
      photoList = [];
      for (int i = 0; i < photoCount; i++) {
        photoList.add("https://kiyohken2000.web.fc2.com/" + galeryRef + "/" + i.toString() + ".jpg");
      }
    });
  }

  void getTags() async{
    DocumentReference docRef = FirebaseFirestore.instance.collection('galery').doc('tags');
    final docSnapshop = await docRef.get();
    setState(() {
      tagList = docSnapshop['tags'];
    });
    final snapshot = await FirebaseFirestore.instance.collection('photos').get();
    var array = [];
    snapshot.docs.forEach((element) {array.add(element.data());});
    setState(() {
      documentList = array;
    });
  }

  @override
  void initState() {
    super.initState();
    loadGalery();
    getTags();
  }

  Widget _tagButton() {
    if(_searchBoolean) {
      return IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _searchBoolean = false;
            selectedTag = '';
            tagSelected = false;
          });
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.tag_sharp),
        onPressed: () {
          setState(() {
            _searchBoolean = true;
          });
        },
      );
    }
  }

  void onSelect(String tag) {
    setState(() {
      selectedTag = tag;
      tagSelected = true;
    });
    var array = [];
    documentList.forEach((element) {
      if(element['tags'].contains(tag)) {
        array.add(element['id']);
      }
      setState(() {
        filteredPhotos = array;
      });
    });
  }

  Widget _tagChips() {
    if(tagList.length == 0 || !_searchBoolean ) {
      return Wrap();
    } else {
      return Wrap(
        spacing: 5,
        children: List.generate(
          tagList.length,
          (index) {
            return GestureDetector(
              onTap: () {
                onSelect(tagList[index]);
              },
              child: Chip(label: Text(tagList[index])),
            );
          },
        ),
      );
    }
  }

  Widget _filteredPhotos() {
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //カラム数
        ),
        itemCount: filteredPhotos.length,
        itemBuilder: (context, index) {
          var imageIndex = filteredPhotos[index];
          var image = "https://kiyohken2000.web.fc2.com/" + galeryRef + "/" + imageIndex.toString() + ".jpg";
          return GestureDetector(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: image,
            ),
            onTap: () {
              Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
                  return PhotoviewScreen(index: imageIndex, photoList: photoList);
              }));
            },
          );
        },
        shrinkWrap: true,
      )
    );
  }

  Widget _imageView() {
    var imageList = List.filled(photoCount, true);
    if(!_searchBoolean) {
      return Scrollbar(
        child: Center(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //カラム数
            ),
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              var imageIndex = index;
              var image = "https://kiyohken2000.web.fc2.com/" + galeryRef + "/" + imageIndex.toString() + ".jpg";
              return GestureDetector(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: image,
                ),
                onTap: () {
                  Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                      return PhotoviewScreen(index: index, photoList: photoList);
                  }));
                },
              );
            },
            shrinkWrap: true,
          )
        ),
      );
    } else if(tagSelected) {
      return Scrollbar(
        child: _filteredPhotos()
      );
    } else {
      return Scrollbar(
        child: _tagChips()
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(!tagSelected? 'ギャラリー': selectedTag),
        toolbarHeight: 40,
        actions: [
          _tagButton(),
        ],
      ),
      body: _imageView()
    );
  }
}
