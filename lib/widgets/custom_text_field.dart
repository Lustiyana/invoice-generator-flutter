import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool? enabled;
  final String? defaultValue;
  final int? maxLines;
  final TextInputType? keyboardType;

  CustomTextField({
    Key? key,
    this.labelText,
    this.hintText,
    TextEditingController? controller,
    this.onChanged,
    this.enabled = true,
    this.maxLines = null,
    this.defaultValue,
    this.keyboardType = TextInputType.text,
  })  : controller =
            controller ?? TextEditingController(text: defaultValue ?? ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
