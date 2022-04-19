import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'article.dart';

class SpeechScreen extends StatefulWidget {

  const SpeechScreen({
    Key? key,
  }) : super(key: key);
  
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  List _items = [];

  void loadJson() async {
    final String response = await rootBundle.loadString('assets/json/abeshinzo.json');
    final data = await jsonDecode(response);
    setState(() {
      _items = data["items"];
    });
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }
  void onPress(item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:(context) {
          return ArticleScreen(
            title: item["Date"],
            nameOfHouse: item["NameOfHouse"],
            nameOfMeeting: item['NameOfMeeting'],
            date: item['Date'],
            speaker: item['Speaker'],
            speakerYomi: item['SpeakerYomi'],
            speech: item['Speech'],
            speechUrl: item['SpeechUrl'],
            meetingUrl: item['MeetingUrl'],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('議会発言一覧'),
        toolbarHeight: 40,
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(_items[index]["Speech"], maxLines: 1,),
                subtitle: Text(_items[index]["Date"]),
                onTap: () => {onPress(_items[index])},
              ),
            );
          },
        )
      )
    );
  }
}
