import 'package:flutter/material.dart';
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
  List _movies = [];
  String url = "http://192.168.43.179/kayztv1/api/videos/";
  String path = "http://192.168.43.179/kayztv1";

  @override
  void initState() {
    super.initState();
    _initFecth();
  }

  _initFecth() async {
    _movies = await _fetchVideosByProgram();

    setState(() {});
  }

  Future<List<Movie>> _fetchVideosByProgram() async {
    String t = url + widget.program.getId.toString();
    print(t);
    var response = await http.get(url + widget.program.getId.toString());
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<dynamic> videosJson = data;
      List<Movie> movies = [];
      print(data);
      videosJson.forEach((json) => movies.add(
            Movie.fromJson(json),
          ));
      return movies;
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
      body: _movies.length != 0
          ? Column(
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
                Expanded(
                  child: ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _builVideoTile(_movies[index]);
                      }),
                ),
              ],
            )
          : Center(
              
            ),
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
              image: NetworkImage(path + movie.getThumbnail),
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
