import 'package:flutter/material.dart';
import 'package:flutter_application_1/TestPage2.dart';
class TestPage1 extends StatelessWidget {
  const TestPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test1"),
      ),
      body: Row(children: [
        TextButton(
          onPressed: () => {
            Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
                return const TestPage2();
              }))
          },
          child: const Text("進む", style: TextStyle(fontSize: 80))
        )
      ],),
    );
  }
}