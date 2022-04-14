import 'package:flutter/material.dart';
import 'photoview.dart';

class GaleryScreen extends StatelessWidget {
  const GaleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageList = [
      _imageItem("1"),
      _imageItem("2"),
      _imageItem("3"),
      _imageItem("4"),
      _imageItem("5"),
      _imageItem("6"),
      _imageItem("7"),
      _imageItem("8"),
      _imageItem("9"),
      _imageItem("10"),
      _imageItem("11"),
      _imageItem("12"),
      _imageItem("13"),
      _imageItem("14"),
      _imageItem("15"),
      _imageItem("16"),
      _imageItem("17"),
      _imageItem("18"),
      _imageItem("19"),
      _imageItem("20"),
      _imageItem("21"),
      _imageItem("22"),
      _imageItem("23"),
      _imageItem("24"),
      _imageItem("25"),
      _imageItem("26"),
      _imageItem("27"),
      _imageItem("28"),
      _imageItem("29"),
      _imageItem("30"),
      _imageItem("31"),
      _imageItem("32"),
      _imageItem("33"),
      _imageItem("34"),
      _imageItem("35"),
      _imageItem("36"),
      _imageItem("37"),
      _imageItem("38"),
      _imageItem("39"),
    ];

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
            var image = "assets/images/abeshinzo/" + imageIndex.toString() + ".jpg";
            return GestureDetector(
              child: Image.asset(image, fit: BoxFit.cover,),
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

  Widget _imageItem(String name) {
    var image = "assets/images/abeshinzo/" + name + ".jpg";
    return Container(
      child: GestureDetector(
        child: Image.asset(image, fit: BoxFit.cover,),
        onTap: () {
          print('on press');
        },
      ),
    );
  }
}