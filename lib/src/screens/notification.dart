import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationScreen extends StatefulWidget {

  const NotificationScreen({
    Key? key,
  }) : super(key: key);
  
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List notificationList = [];
  bool _pending = false;

  void loadNotification() async {
    final flnp = FlutterLocalNotificationsPlugin();
    final List<PendingNotificationRequest> pendingNotificationRequests =
    await flnp.pendingNotificationRequests();
    setState(() {
      notificationList = pendingNotificationRequests;
    });
    if(notificationList.length > 0) {
      setState(() {
        _pending = true;
      });
    } else {
      setState(() {
        _pending = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadNotification();
  }

  var androidChannelSpecifics = AndroidNotificationDetails(
    'channel id',
    'channel name',
    channelDescription: "Your description",
    icon: 'icon',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('sound'),//←Android用に保存した拡張子抜きのファイル名
    styleInformation: DefaultStyleInformation(true, true),
  );

  var iosChannelSpecifics = IOSNotificationDetails(
    presentSound: true,
    presentBadge: true,
    presentAlert: true,
    sound: 'sound.caf',//←Xcodeにドロップしたファイル名
  );

  Future<void> notify() {
    final flnp = FlutterLocalNotificationsPlugin();
    return flnp.initialize(
      InitializationSettings(
        iOS: IOSInitializationSettings(),
        android: AndroidInitializationSettings('icon'),
      ),
    ).then((_) => 
      flnp.zonedSchedule(
        0,
        '安倍晋三エクスプローラー',
        'チョーゼバ イターキマス お箸ｸﾙﾝｯ',
        tz.TZDateTime.now(tz.UTC).add(Duration(seconds: 60)),
        NotificationDetails(
          iOS: iosChannelSpecifics,
          android: androidChannelSpecifics
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      )
    ).then((value) => loadNotification());
  }

  void cancelNotification() async {
    final flnp = FlutterLocalNotificationsPlugin();
    await flnp.cancelAll();
    loadNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知'),
        toolbarHeight: 40,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              child: Text(_pending?'チョーゼバ待機中':'予定されているチョーゼバはありません'),
              padding: EdgeInsets.only(bottom: 40),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: 300, //横幅
                height: 50, //高さ
                child: OutlinedButton(
                  child: Text('チョーゼバ予定をチェック'),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    loadNotification();
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: 300, //横幅
                height: 50, //高さ
                child: ElevatedButton(
                  onPressed: () {
                    notify();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    elevation: 16,
                  ),
                  child: Text('1分後にチョーゼバ'),
                ),
              ),
            ),
            SizedBox(
              width: 300, //横幅
              height: 50, //高さ
              child: ElevatedButton(
                onPressed: () {
                  cancelNotification();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  elevation: 16,
                ),
                child: Text('予定されているチョーゼバをキャンセル'),
              ),
            )
          ],
        ),
      )
    );
  }
}