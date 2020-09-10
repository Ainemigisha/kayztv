
import 'package:flutter/material.dart';
import 'nav_drawer.dart';
import 'featured_player_screen.dart';
import 'app_bar.dart';
import 'package:kayztv/models/movie.dart'; 

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key, this.movie}) : super(key: key);

  final Movie movie;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: MyAppBar(
        appBar: AppBar(),
      ), 

      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: FeaturedPlayerScreen(movie: widget.movie),
          ),
          
        ],
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
