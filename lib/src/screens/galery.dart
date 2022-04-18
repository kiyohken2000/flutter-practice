import 'package:flutter/material.dart';
import 'photoview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  }

  @override
  void initState() {
    super.initState();
    loadGalery();
  }

  @override
  Widget build(BuildContext context) {
    var imageList = List.filled(photoCount, true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ギャラリー'),
        toolbarHeight: 40,
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //カラム数
          ),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            var imageIndex = index + 1;
            var image = "https://kiyohken2000.web.fc2.com/" + galeryRef + "/" + imageIndex.toString() + ".jpg";
            return GestureDetector(
              child: Image.network(image, fit: BoxFit.cover,),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return PhotoviewScreen(image: image);
                }));
              },
            );
          },
          shrinkWrap: true,
        )
      )
    );
  }
}
