import 'package:flutter/material.dart';

class FormLayout extends StatelessWidget {
  final children;
  final title;
  const FormLayout({Key? key, required this.title, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            SizedBox(height: 8.0),
            Column(children: children),
          ],
        ));
  }
}
