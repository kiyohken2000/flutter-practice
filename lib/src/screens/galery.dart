import 'package:flutter/material.dart';
import 'photoview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/firebase_constants.dart';

// タブ切り替えのたびに photos コレクションを全件取得しないよう、アプリ起動中は使い回す
List<Map<String, dynamic>>? _cachedCountedTags;
Map<String, List<dynamic>>? _cachedTagIndex;

// 1つの Wrap に入れるチップ数。ListView.builder で表示範囲の分だけ組み立てる
const int _tagChunkSize = 60;

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
  List filteredPhotoList = [];
  bool _searchBoolean = false;
  bool _keywordBoolean = false;
  String selectedTag = '';
  bool tagSelected = false;
  List<Map<String, dynamic>> _searchTagList = [];
  String keyword = '';
  // タグ名 → そのタグが付いた写真の id 一覧
  Map<String, List<dynamic>> tagIndex = {};
  List<Map<String, dynamic>> addCountedTags = [];
  bool isReverse = false;

  bool get _isTagEnabled => galeryRef != FirebaseConstants.appStoreGaleryRef;

  Future<void> loadGalery() async {
    final docRef = FirebaseFirestore.instance.collection('galery').doc(FirebaseConstants.galeryDocumentId); // DocumentReference
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
    if (_cachedCountedTags == null || _cachedTagIndex == null) {
      final snapshot = await FirebaseFirestore.instance.collection('photos').get();
      final index = <String, List<dynamic>>{};
      snapshot.docs.forEach((element) {
        final data = element.data();
        for (final tag in data['tags']) {
          index.putIfAbsent(tag.toString(), () => []).add(data['id']);
        }
      });
      final List<Map<String, dynamic>> addCount = index.entries.map((e) => <String, dynamic>{
        'label': e.key,
        'count': e.value.length
      }).toList();
      addCount.sort((a,b) => b['count'].compareTo(a['count']));
      _cachedTagIndex = index;
      _cachedCountedTags = addCount;
    }
    if (!mounted) return;
    setState(() {
      tagIndex = _cachedTagIndex!;
      addCountedTags = _cachedCountedTags!;
    });
  }

  @override
  void initState() {
    super.initState();
    loadGalery().then((_) {
      if (_isTagEnabled) getTags();
    });
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
    final ids = tagIndex[tag] ?? [];
    setState(() {
      selectedTag = tag;
      tagSelected = true;
      filteredPhotoList = ids.map((imageIndex) =>
        "https://kiyohken2000.web.fc2.com/" + galeryRef + "/" + imageIndex.toString() + ".jpg"
      ).toList();
    });
  }

  void onReverse() {
    setState(() {
      isReverse = !isReverse;
    });
    print(photoCount);
  }

  Widget _tagChips() {
    if(addCountedTags.length == 0 || !_searchBoolean ) {
      return Wrap();
    }
    final tags = (_searchTagList.length != 0 || keyword.length != 0) ? _searchTagList : addCountedTags;
    // 全チップを1つの Wrap に入れると画面外の分まで一度に組み立てるため、
    // 一定数ずつの Wrap に分けて見えている範囲だけ組み立てる
    final chunkCount = (tags.length / _tagChunkSize).ceil();
    return ListView.builder(
      primary: true,
      itemCount: chunkCount,
      itemBuilder: (context, chunkIndex) {
        final start = chunkIndex * _tagChunkSize;
        final end = (start + _tagChunkSize < tags.length) ? start + _tagChunkSize : tags.length;
        return Wrap(
          spacing: 4.0,
          runSpacing: 0.0,
          children: tags.sublist(start, end).map((tag) {
            return ActionChip(
              label: Text(tag['label'] + '(' + tag['count'].toString() + ')'),
              onPressed: () {
                onSelect(tag['label']);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _filteredPhotos() {
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
        backgroundColor: Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        title: _headerTitle(),
        toolbarHeight: 40,
        actions: [
          if (_isTagEnabled) _tagButton(),
        ],
      ),
      body: _imageView(),
      floatingActionButton: _sortButton()
    );
  }
}
