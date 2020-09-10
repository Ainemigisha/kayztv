import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'nav_drawer.dart';

class TCsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: MyAppBar(
          appBar: AppBar(),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Text(
                'RULES AND REGULATIONS OF PAYMENT',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                  'These guidelines apply to the user who uses the online services provided for anypayment made to KayZ tv.'),
              SizedBox(
                height: 10,
              ),
              Text(
                  'It is the responsibility of the users to have read the terms and conditions before using the service.'),
            ],
          ),
        ));
  }
}
