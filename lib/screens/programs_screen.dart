import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kayztv/screens/program_videos_screen.dart';
import 'nav_drawer.dart';
import 'app_bar.dart';
import 'package:kayztv/models/program.dart';
import 'package:http/http.dart' as http;

class ProgramsScreen extends StatefulWidget {
  ProgramsScreen({Key key}) : super(key: key);

  @override
  _ProgramsScreenState createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List _programs = [];
  String url = "http://192.168.43.179/kayztv1/api/";

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _initFecth();
  }

  _initFecth() async {
    _programs = await _fetchPrograms();

    setState(() {});
  }

  Future<List<Program>> _fetchPrograms() async {
    var response = await http.get(url + "programs");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<dynamic> programsJson = data;
      List<Program> programs = [];
      programsJson.forEach((json) => programs.add(
            Program.fromJson(json),
          ));
      return programs;
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

      body: _programs.length != 0
          ? RefreshIndicator(
              key: refreshKey,
              onRefresh: () async {
                _initFecth();
              },
              child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _programs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildProgramTile(_programs[index]);
                  }),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _buildProgramTile(Program program) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgramVideosScreen(program: program),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            program.getName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
