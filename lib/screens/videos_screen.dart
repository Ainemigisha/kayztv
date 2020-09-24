import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kayztv/models/movie.dart';
import 'package:kayztv/models/constants.dart';
import 'package:http/http.dart' as http;

import 'app_bar.dart';
import 'nav_drawer.dart';
import 'video_player_screen.dart';

class VideosScreen extends StatefulWidget {
  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _initFecth();
  }

  _initFecth() async {
    setState(() {});
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
    return Scaffold(
        drawer: NavDrawer(),
        appBar: MyAppBar(
          appBar: AppBar(),
        ),
        body: FutureBuilder(
            future: _fetchVideos(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasData) {
                var results = snapshot.data;

                return RefreshIndicator(
                  key: refreshKey,
                  onRefresh: () async {
                    _fetchVideos();
                    setState(() {});
                  },
                  child: GridView.count(
                    childAspectRatio: 1.2,
                    crossAxisCount: 2,
                    children: List.generate(results.length, (index) {
                      return _builVideoTile(results[index]);
                    }),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
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
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Column(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(Constants.PATH + movie.getThumbnail),
            ),
            SizedBox(height: 1.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie.getTitle,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    DateFormat('E, dd-MM-yyyy').format(movie.getUploadDate),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
