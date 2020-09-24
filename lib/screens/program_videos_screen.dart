import 'package:flutter/material.dart';
import 'package:kayztv/models/constants.dart';
import 'package:kayztv/screens/app_bar.dart';
import 'package:kayztv/screens/nav_drawer.dart';
import 'package:kayztv/screens/video_player_screen.dart';
import 'package:kayztv/models/program.dart';
import 'package:http/http.dart' as http;
import 'package:kayztv/models/movie.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ProgramVideosScreen extends StatefulWidget {
  ProgramVideosScreen({Key key, this.program}) : super(key: key);

  final Program program;
  @override
  _ProgramVideosScreenState createState() => _ProgramVideosScreenState();
}

class _ProgramVideosScreenState extends State<ProgramVideosScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  Future<List<Movie>> _fetchVideosByProgram() async {
    List<Movie> videos = [];
    var response = await http
        .get(Constants.URL + 'videos/' + widget.program.getId.toString());
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Text(
                widget.program.getName,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
            ),
            FutureBuilder(
              future: _fetchVideosByProgram(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
                if (snapshot.hasData) {
                  var results = snapshot.data;
                  return Expanded(
                    child: RefreshIndicator(
                      key: refreshKey,
                      onRefresh: () async {
                        _fetchVideosByProgram();
                        setState(() {});
                      },
                      child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _builVideoTile(results[index]);
                          }),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        )

        // This trailing comma makes auto-formatting nicer for build methods.
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
}
