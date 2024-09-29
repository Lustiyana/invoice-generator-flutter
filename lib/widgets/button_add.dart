import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  final Function() onPressed;
  String buttonText;
  ButtonAdd({Key? key, required this.onPressed, required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText,
            style: TextStyle(color: Colors.amber[700]),
          ),
          Icon(
            Icons.add,
            color: Colors.amber[700],
          ),
        ],
      ),
    );
  }
}
