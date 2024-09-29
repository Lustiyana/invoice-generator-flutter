import 'package:flutter/material.dart';
import 'package:invoice_generator/widgets/button_add.dart';
import 'package:invoice_generator/widgets/custom_text_field.dart';
import 'package:invoice_generator/widgets/form_layout.dart';

class TableColumns extends StatefulWidget {
  final Function(List<String>) handleChange;
  TableColumns({Key? key, required this.handleChange}) : super(key: key);

  @override
  _TableColumnsState createState() => _TableColumnsState();
}

class _TableColumnsState extends State<TableColumns> {
  var totalColumn = 1;
  List<TextEditingController> controllers = [];
  List<String> columnValues = [];

  @override
  void initState() {
    super.initState();
    controllers.add(TextEditingController());
    columnValues.add('');
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addColumn() {
    setState(() {
      totalColumn++;
      controllers.add(TextEditingController());
      columnValues.add('');
      widget.handleChange(columnValues);
    });
  }

  void _removeColumn(int index) {
    if (index < totalColumn) {
      setState(() {
        controllers[index].dispose();
        controllers.removeAt(index);
        columnValues.removeAt(index);
        totalColumn--;
        widget.handleChange(columnValues);
      });
    }
  }

  void _updateValue(int index, String value) {
    setState(() {
      columnValues[index] = value;
      widget.handleChange(columnValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: 'Informasi Kolom',
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: totalColumn,
          itemBuilder: (context, i) {
            return Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: 'Masukkan nama kolom ke-${i + 1}',
                    controller: controllers[i],
                    onChanged: (value) => _updateValue(i, value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _removeColumn(i),
                ),
              ],
            );
          },
        ),
        ButtonAdd(
          onPressed: _addColumn,
          buttonText: 'Tambah Kolom',
        ),
      ],
    );
  }
}
