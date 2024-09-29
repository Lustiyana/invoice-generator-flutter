import 'package:flutter/material.dart';

class ButtonSubmit extends StatelessWidget {
  final Function() handleSubmit;
  ButtonSubmit({Key? key, required this.handleSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: ElevatedButton(
        onPressed: handleSubmit,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
