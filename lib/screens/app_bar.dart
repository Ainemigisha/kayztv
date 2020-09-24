import 'package:flutter/material.dart';
import 'package:kayztv/models/constants.dart';
import 'dart:convert';

import 'package:kayztv/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:kayztv/models/program.dart';

import 'program_videos_screen.dart';
import 'video_player_screen.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar({Key key, this.appBar}) : super(key: key);
  final AppBar appBar;

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: new IconThemeData(color: Colors.black),
      title: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Image.asset(
          'images/kayz_logo.png',
          width: 60,
        ),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            })
      ],
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  Future<List<Movie>> _fetchVideos() async {
    List<Movie> movies = [];
    if (query != "") {
      var response = await http.get(Constants.URL + "video/" + query);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List<dynamic> videosJson = data;

        videosJson.forEach((json) => movies.add(
              Movie.fromJson(json),
            ));
        return movies;
      } else {
        throw json.decode(response.body)['error'];
      }
    } else {
      return movies;
    }
  }

  Future<List<Program>> _fetchPrograms() async {
    List<Program> programs = [];
    if (query != "") {
      var response = await http.get(Constants.URL + "program/" + query);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List<dynamic> programsJson = data;
        programsJson.forEach((json) => programs.add(
              Program.fromJson(json),
            ));
        return programs;
      } else {
        throw json.decode(response.body)['error'];
      }
    }else{
      return programs;
    }
  }

  final programs = [];

  final recentPrograms = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Videos'),
          FutureBuilder(
              future: _fetchVideos(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
                if (snapshot.hasData) {
                  var results = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(results[index].getTitle),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                    movie: results[index],
                                  )),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          SizedBox(height: 10),
          Text('Programs'),
          FutureBuilder(
              future: _fetchPrograms(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Program>> snapshot) {
                if (snapshot.hasData) {
                  var results = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(results[index].getName),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProgramVideosScreen(
                                    program: results[index],
                                  )),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =
        programs.where((element) => element.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.videocam),
        title: Text(suggestionList[index]),
        onTap: () {
          showResults(context);
        },
      ),
      itemCount: suggestionList.length,
    );
  }
}
