
import 'package:flutter/material.dart';
import 'package:movie_library_test/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.white
      ),
      home: new MyHomePage(title: 'Flutter Library'),
    );
  }
}
