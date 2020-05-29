import 'package:flutter/material.dart';
import 'package:todolist/src/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        accentColor: Colors.blueGrey
      ),
      home: MyHomePage(title: 'TODO '),
    );
  }
}


