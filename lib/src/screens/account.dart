import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/services.dart';

class ShowAlertDialog extends StatelessWidget {
  final String message;
  const ShowAlertDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
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
  var galery = <String, dynamic>{};
  List _postList = [];
  int photoCount = 0;
  String galeryRef = 'appstore';

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

  void loadGalery() async {
    final docRef = FirebaseFirestore.instance.collection('galery').doc('xcpa16TZ6IlV65I2D7KF'); // DocumentReference
    final docSnapshot = await docRef.get(); // DocumentSnapshot
    final data = docSnapshot.exists ? docSnapshot.data() : null; // `data()`で中身を取り出す
    setState(() {
      galery = data!;
    });
    setState(() {
      photoCount = galery['count'];
      galeryRef = galery['ref'];
    });
  }

  @override
  void initState() {
    super.initState();
    loadPost();
    loadGalery();
  }

  Future<void> _copyToClipboard({toClipboard}) async {
    await Clipboard.setData(ClipboardData(text: toClipboard));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('コピーしました'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
        toolbarHeight: 40,
      ),
      body: Scrollbar(
        child: ListView(
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
                            return ShowAlertDialog(message: '意味のない質問だよ');
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade300,
                          minRadius: 35.0,
                          child: Icon(
                            Icons.question_answer_outlined,
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
                              NetworkImage("https://kiyohken2000.web.fc2.com/" + galeryRef + "/33.jpg"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog<void>(
                          context: context,
                          builder: (_) {
                            return ShowAlertDialog(message: 'だから、すみませんって言ってるじゃないか！！');
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
                            backgroundImage: NetworkImage("https://kiyohken2000.web.fc2.com/" + galeryRef + "/33.jpg"),
                          ),
                          title: Text('安倍晋三'),
                          subtitle: Text(_postList[index]["post"]),
                          trailing: IconButton(
                            icon: Icon(Icons.flag),
                            onPressed: () {
                              showDialog<void>(
                              context: context,
                              builder: (_) {
                                return ShowAlertDialog(message: 'だから、すみませんって言ってるじゃないか！！');
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
                                    _copyToClipboard(toClipboard: _postList[index]["post"]);
                                    showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return ShowAlertDialog(message: '意味のない質問だよ');
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.thumb_up_alt_outlined),
                                  onPressed: () {
                                    _copyToClipboard(toClipboard: _postList[index]["post"]);
                                    showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return ShowAlertDialog(message: '非常にジューシー');
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.favorite_outline),
                                  onPressed: () {
                                    _copyToClipboard(toClipboard: _postList[index]["post"]);
                                    showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return ShowAlertDialog(message: '非常にしつこい');
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
      )
    );
  }
}