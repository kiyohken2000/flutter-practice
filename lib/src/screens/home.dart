import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {  

  //　変数定義すると、UIのところから"widget.変数名" で呼ぶことができる。
  final String title;

  const HomeScreen({
    Key? key,
    required this.title,
  }) : super(key: key);
  
   // createState()　で"State"（Stateを継承したクラス）を返す
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  
  // providerのモデルで定義していたmethodをここかく。
  void _incrementCounter() {
    // 変更したらUIも変わる操作をsetStateで包む。
    //(providerのchangeNotifier()みたいな役割)　
    setState(() {
      _counter++;
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),

      // ボタン操作に応じて_counterを増やす
      floatingActionButton: FloatingActionButton(
        // onPressedされると、_counter++され、setState()によってUIが再描画される。
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
