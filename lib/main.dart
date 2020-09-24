import 'package:flutter/material.dart'; 
import 'package:kayztv/screens/home_screen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  

  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kayz Tv',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }

  

  
}
