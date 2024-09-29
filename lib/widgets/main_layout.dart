import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  var body;
  String title;
  MainLayout({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          backgroundColor: Colors.amberAccent,
          titleTextStyle: const TextStyle(color: Colors.white),
        ),
        body: body);
  }
}
