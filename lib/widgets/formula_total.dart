import 'package:flutter/material.dart';
import 'package:invoice_generator/widgets/dropdown_input.dart';
import 'package:invoice_generator/widgets/form_layout.dart';

class FormulaTotal extends StatefulWidget {
  final List<String> options;
  final Function(Map<String, dynamic>) handleChange;

  const FormulaTotal({
    Key? key,
    required this.options,
    required this.handleChange,
  }) : super(key: key);

  @override
  _FormulaTotalState createState() => _FormulaTotalState();
}

class _FormulaTotalState extends State<FormulaTotal> {
  final Map<String, dynamic> total = {
    'columns': ['', ''],
    'operator': '',
  };

  @override
  void initState() {
    super.initState();
    widget.handleChange(total);
  }

  void _updateTotal() {
    widget.handleChange(total);
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: "Formula Jumlah",
      children: [
        DropdownInput(
          options: widget.options,
          labelText: 'Nama kolom 1',
          handleSubmit: (value) {
            setState(() {
              total['columns'][0] = value;
              _updateTotal();
            });
          },
        ),
        DropdownInput(
          options: ['x', '/', '+', '-'],
          labelText: 'Operasi hitung',
          handleSubmit: (value) {
            setState(() {
              total['operator'] = value;
              _updateTotal();
            });
          },
        ),
        DropdownInput(
          options: widget.options,
          labelText: 'Nama kolom 2',
          handleSubmit: (value) {
            setState(() {
              total['columns'][1] = value;
              _updateTotal();
            });
          },
        ),
      ],
    );
  }
}
