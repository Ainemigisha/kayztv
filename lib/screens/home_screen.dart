import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kayztv/helpers/SharedPrefsHelper.dart';
import 'package:kayztv/screens/app_bar.dart';
import 'package:kayztv/screens/nav_drawer.dart';
import 'package:kayztv/screens/video_player_screen.dart';
import 'package:http/http.dart' as http;
import 'package:kayztv/models/movie.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:kayztv/models/constants.dart';
import 'package:workmanager/workmanager.dart';

import '../helpers/SharedPrefsHelper.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;
  GlobalKey<RefreshIndicatorState> refreshKey;
  DateTime backbuttonpressedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Workmanager.initialize(

        // The top level function, aka callbackDispatcher
        callbackDispatcher,

        // If enabled it will post a notification whenever
        // the task is running. Handy for debugging tasks
        isInDebugMode: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }

  Future<List<Movie>> _fetchVideos() async {
    List<Movie> videos = [];

    var response = await http.get(Constants.URL + "videos");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<dynamic> videosJson = data;
      videosJson.forEach((json) => videos.add(
            Movie.fromJson(json),
          ));
      return videos;
    } else {
      throw json.decode(response.body)['error'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    return Scaffold(
      drawer: NavDrawer(),
      appBar: MyAppBar(
        appBar: AppBar(),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: FutureBuilder(
          future: _fetchVideos(),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.hasData) {
              var results = snapshot.data;
              return RefreshIndicator(
                key: refreshKey,
                onRefresh: () async {
                  _fetchVideos();
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: _buildFeaturedImage(results[0]),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: results.length - 1,
                          itemBuilder: (BuildContext context, int index) {
                            return _builVideoTile(results[index + 1]);
                          }),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _buildFeaturedImage(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                    movie: movie,
                  )),
        );
      },
      child: Column(children: <Widget>[
        Image(
          image: NetworkImage(Constants.PATH + movie.getThumbnail),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          movie.getTitle,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ]),
    );
  }

  _builVideoTile(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                    movie: movie,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(Constants.PATH + movie.getThumbnail),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie.getTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    DateFormat('E, dd-MM-yyyy').format(movie.getUploadDate),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    Workmanager.registerOneOffTask(
      "1",

      //This is the value that will be
      // returned in the callbackDispatcher
      "oneOffTask",

      // When no frequency is provided
      // the default 15 minutes is set.
      // Minimum frequency is 15 min.
      // Android will automatically change
      // your frequency to 15 min
      // if you have configured a lower frequency.
      // frequency: Duration(minutes: 15),
      initialDelay: Duration(seconds: 5),
    );
    return true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

Future<List<Movie>> _fetchVideosByDt() async {
  DateTime currentDateTime = DateTime.now();
  DateTime recentDt;
  List<Movie> videos = [];

  recentDt = await SharedPrefsHelper.getRecentFetchDt();
  print(recentDt);
  SharedPrefsHelper.setRecentFetchDt(currentDateTime
      .toString()); //set the recent date in history to current date
  if (recentDt != null) {
    String link = Constants.URL + "videos/date/" + recentDt.toString();
    print(link);
    var response = await http.get(link);
    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> videosJson = data;
      videosJson.forEach((json) => videos.add(
            Movie.fromJson(json),
          ));
      return videos;
    } else {
      throw json.decode(response.body)['error'];
    }
  }

  return videos;
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    List<Movie> res = await _fetchVideosByDt();
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    var android = new AndroidInitializationSettings('@drawable/kayz_logo');
    var iOS = new IOSInitializationSettings();

    var settings = new InitializationSettings(android, iOS);
    flip.initialize(settings);
    print("LENGTH IS" +res.length.toString());
    if (res.length != 0) {
      for (var video in res) {
        _showNotificationWithDefaultSound(flip, video);
      }
    }

    return Future.value(true);
  });
}

void runNotification() {}

Future _showNotificationWithDefaultSound(flip, Movie video) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'newVideosId', 'New Videos', 'Channels for new videos',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flip.show(
      video.getVideoId, "KayzTv " + video.getProgram, video.getTitle, platformChannelSpecifics,
      payload: 'Default_Sound');
}

