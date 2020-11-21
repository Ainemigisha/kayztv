import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../models/constants.dart';
import 'app_bar.dart';
import 'nav_drawer.dart';

class LiveScreen extends StatefulWidget {
  LiveScreen({Key key}) : super(key: key);

  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.

    _controller = VideoPlayerController.network(Constants.LIVE);
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: 16 / 9,
        fullScreenByDefault: true,
        allowFullScreen: true,
        autoPlay: true,
        looping: false,
        autoInitialize: true,
        showControlsOnInitialize: false,
        allowedScreenSleep: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        isLive: true);

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
    return Scaffold(
      drawer: NavDrawer(),
      appBar: MyAppBar(
        appBar: AppBar(),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Text(
            //   widget.movie.getTitle,
            //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            // ),
            // Text(
            //   DateFormat('E, dd-MM-yyyy').format(widget.movie.getUploadDate),
            //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            // ),
          ]),
    );
  }
}
