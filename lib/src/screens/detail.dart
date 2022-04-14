import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/sentence.dart';

class DetailScreen extends StatefulWidget {  

  //　変数定義すると、UIのところから"widget.変数名" で呼ぶことができる。
  final String title;
  final String myname;

  const DetailScreen({
    Key? key,
    required this.title,
    required this.myname,
  }) : super(key: key);
  
   // createState()　で"State"（Stateを継承したクラス）を返す
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _counter = 0;
  List<Sentence> _sentence = [];
  void fetchSentence() async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/todos'));
    if (response.statusCode == 200) {
      final List<dynamic> sentences = jsonDecode(response.body);
      setState(() {
        _sentence =
          sentences.map((sentence) => Sentence.fromJson(sentence)).toList();
      });
    } else {
      throw Exception('Failed to load sentence');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSentence();
  }
  
  // providerのモデルで定義していたmethodをここかく。
  void _incrementCounter() {
    // 変更したらUIも変わる操作をsetStateで包む。
    //(providerのchangeNotifier()みたいな役割)　
    setState(() {
      _counter++;
    });
  }
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }
  void _counterControl(int num) {
    setState(() {
      _counter = _counter + num;
    });
  }

  //　状態を使いつつ組んだWidgetを返す(build関数)    
  @override
  Widget build(BuildContext context) {
    // 　UIの部分はここに書く。　
    return Scaffold(
      appBar: AppBar(
        // このように自分(State)をcreateStateしたWidget(StatefulWidget)
        // のフィールドにアクセスできる。
        title: Text(widget.myname),
        toolbarHeight: 40,
      ),
      body: Center(
        child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final viewIndex = index + _counter;
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black38),
                    ),
                  ),
                  child: ListTile(
                    leading: Text('$viewIndex'),
                    title: Text(_sentence[index].title),
                    onTap: () { /* react to the tile being tapped */ },
                ));},
              itemCount: _sentence.length
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => _counterControl(1),
            icon: Icon(Icons.add),
            iconSize: 40,
          ),
          IconButton(
            onPressed: () => _counterControl(-1),
            icon: Icon(Icons.remove),
            iconSize: 40,
          ),
        ],
      ),

    );
  }
}
