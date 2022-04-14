import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ArticleScreen extends StatefulWidget {  

  final String title;
  final String nameOfHouse;
  final String nameOfMeeting;
  final String date;
  final String speaker;
  final String speakerYomi;
  final String speech;
  final String speechUrl;
  final String meetingUrl;

  const ArticleScreen({
    Key? key,
    required this.title,
    required this.nameOfHouse,
    required this.nameOfMeeting,
    required this.date,
    required this.speaker,
    required this.speakerYomi,
    required this.speech,
    required this.meetingUrl,
    required this.speechUrl
  }) : super(key: key);
  
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  FlutterTts flutterTts = FlutterTts();

  void _speak(item) async {
    await flutterTts.setLanguage("ja-JP");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(0.6);
    await flutterTts.speak(item);
  }

  void _stop() async {
    await flutterTts.stop();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        toolbarHeight: 40,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(widget.nameOfHouse),
                            Text(widget.nameOfMeeting),
                          ],
                        ),
                        Column(
                          children: [
                            Text(widget.speaker),
                            Text(widget.speakerYomi)
                          ]
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Text(widget.speech)
            ]
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              heroTag: 'speech',
              child: Icon(Icons.play_arrow),
              backgroundColor: Colors.pinkAccent,
              onPressed: () => _speak(widget.speech),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              heroTag: 'stop',
              child: Icon(Icons.stop),
              backgroundColor: Colors.blueAccent,
              onPressed: () => _stop(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: FloatingActionButton(
              heroTag: 'web',
              child: Icon(Icons.web, color: Colors.black,),
              backgroundColor: Colors.greenAccent,
              onPressed: () async {
                String url = Uri.encodeFull(widget.speechUrl);
                await launch(url);
              },
            ),
          ),
        ],
      ),
    );
  }
}
