import 'package:flutter/material.dart';
import 'photoview.dart';

class GaleryScreen extends StatelessWidget {
  const GaleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageList = List.filled(41, true);

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
            var image = "https://kiyohken2000.web.fc2.com/abeshinzo/" + imageIndex.toString() + ".jpg";
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