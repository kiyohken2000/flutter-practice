import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';

class InquiryAlertDialog extends StatelessWidget {
  const InquiryAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('意味のない質問だよ'),
      actions: <Widget>[
        GestureDetector(
          child: Text('閉じる'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ReportAlertDialog extends StatelessWidget {
  const ReportAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('だから、すみませんって言ってるじゃないか！！'),
      actions: <Widget>[
        GestureDetector(
          child: Text('閉じる'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class LikeAlertDialog extends StatelessWidget {
  const LikeAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('非常にジューシー'),
      actions: <Widget>[
        GestureDetector(
          child: Text('閉じる'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ThumbUpAlertDialog extends StatelessWidget {
  const ThumbUpAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('非常にしつこい'),
      actions: <Widget>[
        GestureDetector(
          child: Text('閉じる'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AccountScreen extends StatefulWidget {

  const AccountScreen({
    Key? key,
  }) : super(key: key);
  
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List _postList = [];

  void loadPost() async {
    final collectionRef = FirebaseFirestore.instance.collection('posts'); // CollectionReference
    final querySnapshot = await collectionRef.get(); // QuerySnapshot
    final queryDocSnapshot = querySnapshot.docs; // List<QueryDocumentSnapshot>
    var array = [];
    for (final snapshot in queryDocSnapshot) {
      final data = snapshot.data(); // `data()`で中身を取り出す
      array.add(data);
    }
    setState(() {
      _postList = array;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
        toolbarHeight: 40,
      ),
      body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.deepOrange.shade300],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showDialog<void>(
                          context: context,
                          builder: (_) {
                            return InquiryAlertDialog();
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade300,
                          minRadius: 35.0,
                          child: Icon(
                            Icons.message,
                            size: 30.0,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              NetworkImage('https://kiyohken2000.web.fc2.com/abeshinzo/33.jpg'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog<void>(
                          context: context,
                          builder: (_) {
                            return ReportAlertDialog();
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade300,
                          minRadius: 35.0,
                          child: Icon(
                            Icons.flag,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '安倍晋三',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Abe Shinzo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.deepOrange.shade300,
                      child: ListTile(
                        title: Text(
                          '担当',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Tantou',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.red,
                      child: ListTile(
                        title: Text(
                          '森羅万象',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Shinrabanshou',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,   //追加
                  physics: const NeverScrollableScrollPhysics(),  //追加
                  itemCount: _postList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: GFAvatar(
                            backgroundImage:NetworkImage("https://kiyohken2000.web.fc2.com/abeshinzo/33.jpg"),
                          ),
                          title: Text('安倍晋三'),
                          subtitle: Text(_postList[index]["post"]),
                          trailing: IconButton(
                            icon: Icon(Icons.flag),
                            onPressed: () {
                              showDialog<void>(
                              context: context,
                              builder: (_) {
                                return ReportAlertDialog();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.message_outlined),
                                  onPressed: () {
                                    showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return InquiryAlertDialog();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.thumb_up_alt_outlined),
                                  onPressed: () {
                                    showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return LikeAlertDialog();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.favorite_outline),
                                  onPressed: () {
                                    showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return ThumbUpAlertDialog();
                                    });
                                  },
                                ),
                              ],
                            ),
                        ),
                        Divider()
                      ],
                    );
                  }),
                ]
            )
          ],
        ),
    );
  }
}