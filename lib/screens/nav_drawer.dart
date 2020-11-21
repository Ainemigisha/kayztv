import 'package:flutter/material.dart';
import 'package:kayztv/screens/home_screen.dart';
import 'package:kayztv/screens/programs_screen.dart';
import 'package:kayztv/screens/videos_screen.dart';
import 'package:kayztv/screens/live_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tcs_screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xff000800),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 100),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Home',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => MyHomePage()));
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.live_tv,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Live',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => LiveScreen()));
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.movie,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Videos',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => VideosScreen()));
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.live_tv,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Programs',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ProgramsScreen()));
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.note,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'TCs',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => TCsScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.facebookSquare,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.twitterSquare,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.instagramSquare,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
