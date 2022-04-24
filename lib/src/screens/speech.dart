import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

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
  bool _searchBoolean = false; //追加
  List _searchIndexList = []; //追加
  String selectedDate = '';
  bool _isMonthPick = false;

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

  Future _getDate(BuildContext context) async {
    final initialDate = DateTime.now();

    final newDate =
        await showMonthPicker(context: context, initialDate: initialDate);

    if (newDate != null) {
      DateFormat outputFormat = DateFormat('yyyy-MM');
      String date = outputFormat.format(newDate);
      setState(() {
        _isMonthPick = true;
        _searchIndexList = [];
        for (int i = 0; i < _items.length; i++) {
          if (_items[i]["Date"].contains(date)) {
            _searchIndexList.add(_items[i]);
          }
        }
      });
    } else {
      return;
    }
  }

  Widget _searchTextField() { //追加
    return TextField(
      autofocus: true, //TextFieldが表示されるときにフォーカスする（キーボードを表示する）
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
        hintText: '発言を検索', //何も入力してないときに表示されるテキスト
        hintStyle: TextStyle( //hintTextのスタイル
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
      onChanged: (String s) { //追加
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < _items.length; i++) {
            if (_items[i]["Speech"].contains(s)) {
              _searchIndexList.add(_items[i]);
            }
          }
        });
      },
    );
  }

  Widget _defaultListView() {
    return Scrollbar(
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
      );
  }

  Widget _searchListView() {
    if(_searchIndexList.length == 0) {
      return Text('結果はありません');
    } else {
      return Scrollbar(
          child: ListView.builder(
            itemCount: _searchIndexList.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(_searchIndexList[index]["Speech"], maxLines: 1,),
                  subtitle: Text(_searchIndexList[index]["Date"]),
                  onTap: () => {onPress(_searchIndexList[index])},
                ),
              );
            },
          )
        );
      }
  }

  Widget _pickerButton() {
    if(!_isMonthPick) {
      return FloatingActionButton(
        child: Icon(Icons.calendar_month_outlined),
        onPressed: () {
          _getDate(context);
        },
      );
    } else {
      return FloatingActionButton(
        child: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _isMonthPick = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_searchBoolean ? Text('議会発言一覧') : _searchTextField(),
        toolbarHeight: 40,
        actions: !_searchBoolean?
          [
            IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchBoolean = true;
                _isMonthPick = false;
                _searchIndexList = []; //追加
              });
            })
          ] 
          :
          [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _isMonthPick = false;
                  _searchBoolean = false;
                });
              }
            )
          ]
      ),
      body: !_searchBoolean && !_isMonthPick ? _defaultListView() : _searchListView(),
      floatingActionButton: _pickerButton()
    );
  }
}
