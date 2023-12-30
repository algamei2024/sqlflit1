import 'package:flutter/material.dart';
import 'package:sqlflit1/screen/home.dart';
import 'package:sqlflit1/screen/lab11.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home:myHome(),
    );
  }
}
