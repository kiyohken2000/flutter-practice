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
  List filteredPhotoList = [];
  List<dynamic> documentList = [];
  bool _searchBoolean = false;
  bool _keywordBoolean = false;
  String selectedTag = '';
  bool tagSelected = false;
  List filteredPhotos = [];
  List<Map<String, dynamic>> _searchTagList = [];
  String keyword = '';
  var tagMap = <dynamic, dynamic>{};
  List<Map<String, dynamic>> addCountedTags = [];
  bool isReverse = false;

  void loadGalery() async {
    final docRef = FirebaseFirestore.instance.collection('galery').doc('7Un7h8FMiveCWJzp4mLX'); // DocumentReference
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
    final snapshot = await FirebaseFirestore.instance.collection('photos').get();
    var photoArray = [];
    var tagArray = [];
    snapshot.docs.forEach((element) {
      photoArray.add(element.data());
      tagArray.addAll(element.data()['tags']);
    });
    var map = Map();
    tagArray.forEach((element) {
      if(!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] +=1;
      }
    });
    setState(() {
      documentList = photoArray;
      tagList = tagArray.toSet().toList();
      tagMap = map;
    });
    var tags = tagArray.toSet().toList();
    final List<Map<String, dynamic>> addCount = tags.map((e) => {
      'label': e,
      'count': tagMap[e]
    }).toList();
    addCount.sort((a,b) => b['count'].compareTo(a['count']));
    setState(() {
      addCountedTags = addCount;
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
            _keywordBoolean = false;
            _searchTagList = [];
            keyword = '';
          });
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.tag_sharp),
        onPressed: () {
          setState(() {
            _searchBoolean = true;
            _keywordBoolean = true;
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

  void onReverse() {
    setState(() {
      isReverse = !isReverse;
    });
    print(photoCount);
  }

  Widget _tagChips() {
    if(tagList.length == 0 || !_searchBoolean ) {
      return Wrap();
    } else if(_searchTagList.length != 0 || keyword.length != 0) {
      return ListView(
       primary: true,
       shrinkWrap: true,
       children: <Widget>[
         Wrap(
           spacing: 4.0,
           runSpacing: 0.0,
           children: List<Widget>.generate(
             _searchTagList.length, // place the length of the array here
             (int index) {
                return ActionChip(
                  label: Text(_searchTagList[index]['label'] + '(' + _searchTagList[index]['count'].toString() + ')'),
                  onPressed: () {
                    onSelect(_searchTagList[index]['label']);
                  },
                );
             }
           ).toList(),
         ),
       ],
     );
    } else {
      return ListView(
       primary: true,
       shrinkWrap: true,
       children: <Widget>[
         Wrap(
           spacing: 4.0,
           runSpacing: 0.0,
           children: List<Widget>.generate(
             addCountedTags.length, // place the length of the array here
             (int index) {
               return ActionChip(
                 label: Text(addCountedTags[index]['label'] + '(' + addCountedTags[index]['count'].toString() + ')'),
                 onPressed: () {
                  onSelect(addCountedTags[index]['label']);
                 },
               );
             }
           ).toList(),
         ),
       ],
     );
    }
  }

  Widget _filteredPhotos() {
    var photoArray = [];
    filteredPhotos.forEach((imageIndex) {
      var image = "https://kiyohken2000.web.fc2.com/" + galeryRef + "/" + imageIndex.toString() + ".jpg";
      photoArray.add(image);
    },);
    setState(() {
      filteredPhotoList = photoArray;
    });
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //カラム数
        ),
        itemCount: filteredPhotoList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: filteredPhotoList[index],
            ),
            onTap: () {
              Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
                  return PhotoviewScreen(index: index, photoList: filteredPhotoList, galeryRef: galeryRef);
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
              var imageIndex = !isReverse? index: photoCount - index - 1;
              var image = "https://kiyohken2000.web.fc2.com/" + galeryRef + "/" + imageIndex.toString() + ".jpg";
              return GestureDetector(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: image,
                ),
                onTap: () {
                  Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                      return PhotoviewScreen(index: imageIndex, photoList: photoList, galeryRef: galeryRef);
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

  Widget _searchTextField() { //追加
    return TextField(
      autofocus: false, //TextFieldが表示されるときにフォーカスする（キーボードを表示する）
      cursorColor: Colors.white, //カーソルの色
      style: TextStyle( //テキストのスタイル
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search, //キーボードのアクションボタンを指定
      decoration: InputDecoration( //TextFiledのスタイル
        enabledBorder: UnderlineInputBorder( //デフォルトのTextFieldの枠線
          borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: UnderlineInputBorder( //TextFieldにフォーカス時の枠線
          borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'タグを検索', //何も入力してないときに表示されるテキスト
        hintStyle: TextStyle( //hintTextのスタイル
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
      onChanged: (String s) { //追加
        setState(() {
          keyword = s;
        });
        if(s.length == 0) {
          setState(() {
            _searchTagList = [];
          });
        } else {
          setState(() {
            _searchTagList = [];
            for (int i = 0; i < addCountedTags.length; i++) {
              if (addCountedTags[i]['label'].contains(s)) {
                _searchTagList.add(addCountedTags[i]);
              }
            }
          });
        }
      },
    );
  }

  Widget _headerTitle() {
    if(tagSelected) {
      return Text(selectedTag);
    } else if(_keywordBoolean) {
      return _searchTextField();
    } else {
      return Text('ギャラリー');
    }
  }

  Widget _sortButton() {
    if(!_searchBoolean) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              heroTag: 'speech',
              child: Icon(Icons.sort),
              backgroundColor: isReverse?Colors.pinkAccent:Colors.blueAccent,
              onPressed: () => onReverse(),
            ),
          ),
        ],
      );
    } else {
      return Wrap();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: _headerTitle(),
        toolbarHeight: 40,
        actions: [
          _tagButton(),
        ],
      ),
      body: _imageView(),
      floatingActionButton: _sortButton()
    );
  }
}
