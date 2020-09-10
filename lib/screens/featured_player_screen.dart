import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:kayztv/models/movie.dart';
import 'package:flutter_playout/player_state.dart';

import 'package:intl/intl.dart';

import 'video_player.dart';

class FeaturedPlayerScreen extends StatefulWidget {
  FeaturedPlayerScreen({Key key, this.movie}) : super(key: key);

  final Movie movie;
  @override
  _FeaturedPlayerScreenState createState() => _FeaturedPlayerScreenState();
}

class _FeaturedPlayerScreenState extends State<FeaturedPlayerScreen> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  PlayerState _desiredState = PlayerState.PLAYING;
  bool _showPlayerControls = true;
  String url;

  @override
  void initState() {
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    url = 'http://192.168.43.179/kayztv1' + widget.movie.getVideo;
    _controller = VideoPlayerController.network(
      url,
    );
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: 16 / 9,
        allowFullScreen: true,
        autoPlay: false,
        looping: false,
        autoInitialize: true,
        showControlsOnInitialize: false);

    //  _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                  )),
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ]),
          
          SizedBox(
            height: 20,
          ),
          Text(
            widget.movie.getTitle,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
          ),
          Text(
            DateFormat('E, dd-MM-yyyy').format(widget.movie.getUploadDate),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ]);
  }
}
