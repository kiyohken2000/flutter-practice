import 'package:flutter/material.dart';
import 'package:flutter_application_1/TestPage3.dart';
class TestPage2 extends StatelessWidget {
  const TestPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test2"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => {
                Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                  return const TestPage3();
                }))
              },
              child: const Text("進む", style: TextStyle(fontSize: 80))),
            TextButton(
              onPressed: () => {Navigator.of(context).pop()},
              child: const Text("戻る", style: TextStyle(fontSize: 80)))
          ]
        )
      )
    );
  }
}