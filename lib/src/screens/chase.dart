import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChaseScreen extends StatefulWidget {

  const ChaseScreen({
    Key? key,
  }) : super(key: key);
  
  @override
  _ChaseScreenState createState() => _ChaseScreenState();
}

class _ChaseScreenState extends State<ChaseScreen> {
  var traceData = <String, dynamic>{};
  late GoogleMapController _controller;
  String updated_at = '';
  List<dynamic> articlesList = [];
  final Set<Marker> markers = new Set();

  //初期位置
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(35.67598820659808, 139.74483117563184),
    zoom: 7,
  );

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  void loadArticles() async{
    final docRef = FirebaseFirestore.instance.collection('trace').doc('articles');
    final docSnapshot = await docRef.get();
    final data = docSnapshot.exists ? docSnapshot.data() : null;
    setState(() {
      traceData = data!;
    });
    setState(() {
      updated_at = traceData['updated_at'];
      articlesList = traceData['articles'];
    });
    createMarker();
  }

  void createMarker() {
    articlesList.asMap().forEach((index, article) {
      article['positions'].asMap().forEach((indexChild, location) {
        var coordinate = location['position'];
        var id = index + indexChild;
        markers.add(
          Marker(
            markerId: MarkerId(id.toString()),
            position: LatLng(coordinate[0], coordinate[1]),
            icon: index == 0? BitmapDescriptor.defaultMarkerWithHue(280): BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: location['label'],
              snippet: article['title'] + '(' + article['time'] + ')',
              onTap: () async {
                var url = Uri.parse(article['url']);
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
            ),
          )
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(updated_at + '更新'),
        toolbarHeight: 40,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      )
    );
  }
}
