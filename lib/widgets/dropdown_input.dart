import 'package:flutter/material.dart';

class DropdownInput extends StatefulWidget {
  final List<String> options;
  final String labelText;
  final Function(String?) handleSubmit;

  const DropdownInput({
    Key? key,
    required this.options,
    required this.labelText,
    required this.handleSubmit,
  }) : super(key: key);

  @override
  _DropdownInputState createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: widget.labelText,
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
        value: selectedValue,
        items: widget.options
            .where((String value) => value.isNotEmpty)
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
            widget.handleSubmit(newValue); // Always call handleSubmit
          });
        },
        // To avoid assertion errors, ensure selectedValue matches an item
        validator: (value) {
          if (value == null || !widget.options.contains(value)) {
            return 'Please select a valid option';
          }
          return null;
        },
      ),
    );
  }
}
