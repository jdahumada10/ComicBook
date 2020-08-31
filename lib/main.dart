import 'package:comicbook/src/pages/comic_detail.dart';
import 'package:comicbook/src/pages/home_page.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/'             : (BuildContext context) => HomePage(),
        'comicDetail'   : (BuildContext context) => ComicDetail(),
      },
    );
  }
}