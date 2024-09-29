import 'dart:io';
import 'package:flutter/material.dart';
import 'package:invoice_generator/widgets/button_add.dart';
import 'package:invoice_generator/widgets/button_submit.dart';
import 'package:invoice_generator/widgets/custom_text_field.dart';
import 'package:invoice_generator/widgets/form_layout.dart';
import 'package:invoice_generator/widgets/main_layout.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InputValuesScreen extends StatefulWidget {
  final Map<String, dynamic> modifiedData;

  const InputValuesScreen({Key? key, required this.modifiedData})
      : super(key: key);

  @override
  _InputValuesScreenState createState() => _InputValuesScreenState();
}

class _InputValuesScreenState extends State<InputValuesScreen> {
  int totalColumn = 1;
  final List<List<int>> totalValues = [
    [0, 0]
  ];
  double total = 0.0;

  final List<List<dynamic>> columnsValues = [];
  late TextEditingController notesController;
  final List<List<dynamic>> controllers = [];
  final List<double> totals = [];
  final Map<String, dynamic> results = {
    'informations': {'name': '', 'rekening': '', 'bank': ''},
    'columns': [],
    'values': [],
    'totals': [],
    'total': 0.0,
    'notes': ''
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      results['columns'] = widget.modifiedData['columns'];
      results['informations'] = widget.modifiedData['informations'];
    });
    notesController = TextEditingController();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < totalColumn; i++) {
      controllers.add(List.generate(widget.modifiedData['columns'].length,
          (_) => TextEditingController()));
      columnsValues.add(List.filled(widget.modifiedData['columns'].length, ''));
      results['totals'].add(0.0);
    }
  }

  @override
  void dispose() {
    for (var controllerList in controllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _addColumn() {
    setState(() {
      totalColumn++;
      controllers.add(List.generate(widget.modifiedData['columns'].length,
          (_) => TextEditingController()));
      columnsValues.add(List.filled(widget.modifiedData['columns'].length, ''));
      totalValues.add(List.filled(widget.modifiedData['columns'].length, 0));
      results['totals'].add(0);
    });
  }

  void _updateValue(int parentIndex, int index, String value, String column) {
    setState(() {
      if (columnsValues.length <= parentIndex) {
        columnsValues
            .add(List.filled(widget.modifiedData['columns'].length, ''));
        controllers.add(List.generate(widget.modifiedData['columns'].length,
            (_) => TextEditingController()));
      }

      var columnOperation = widget.modifiedData['operation']['columns'];
      if (columnOperation.contains(column)) {
        int indexColumn = columnOperation.indexOf(column);
        try {
          // Initialize valueNumber with 0
          int valueNumber = 0;

          // Check if value is not empty and parse it to an integer
          if (value.isNotEmpty) {
            valueNumber = int.parse(value);
          }

          // Update totalValues at the specified parentIndex and indexColumn
          totalValues[parentIndex][indexColumn] = valueNumber;
        } catch (e) {
          print('Error parsing value "$value" for column "$column": $e');
        }
      }

      var count = 0.0;
      var countArr = [];
      for (var items in totalValues) {
        switch (widget.modifiedData['operation']['operator']) {
          case 'x':
            count += items[0] * items[1];
          case '+':
            count += items[0] + items[1];
          case '-':
            count += items[0] - items[1];
          case '/':
            count += items[0] / items[1];
        }
        countArr.add(count);
      }

      switch (widget.modifiedData['operation']['operator']) {
        case 'x':
          results['totals'][parentIndex] =
              totalValues[parentIndex][0] * totalValues[parentIndex][1];
        case '+':
          results['totals'][parentIndex] =
              totalValues[parentIndex][0] + totalValues[parentIndex][1];
        case '-':
          results['totals'][parentIndex] =
              totalValues[parentIndex][0] - totalValues[parentIndex][1];
        case '/':
          results['totals'][parentIndex] =
              totalValues[parentIndex][0] / totalValues[parentIndex][1];
      }

      columnsValues[parentIndex][index] = value;
      results['total'] = count;
      results['values'] = columnsValues;
    });
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Invoice Data', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(children: [
                    for (var column in results['columns']) // Dynamic columns
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(column,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                  ]),
                  // Data Rows
                  if (results['totals'].isNotEmpty)
                    for (int i = 0; i < results['totals'].length; i++)
                      pw.TableRow(
                        children: [
                          for (var j = 0; j < results['columns'].length; j++)
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                  results['values'][i][j]?.toString() ?? 'N/A'),
                            ),
                        ],
                      ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Personal Information:',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Name: ${results['informations']['name'] ?? 'N/A'}'),
              pw.Text('Bank: ${results['informations']['bank'] ?? 'N/A'}'),
              pw.Text(
                  'Rekening: ${results['informations']['rekening'] ?? 'N/A'}'),
              pw.SizedBox(height: 20),
              pw.Text('Overall Total: ${results['total']?.toString() ?? 'N/A'}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Notes: ${results['notes'] ?? 'No notes provided'}'),
            ],
          );
        },
      ),
    );

    final directory = await getDownloadsDirectory();
    if (directory == null) {
      print('Failed to get the directory');
      return;
    }

    final filePath = '${directory.path}/invoice.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Input Form',
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: totalColumn,
              itemBuilder: (context, i) {
                return Card(
                  color: Colors.white,
                  child: FormLayout(
                    title: "Data ${i + 1}",
                    children: [
                      Column(
                        children: List.generate(
                            widget.modifiedData['columns'].length, (index) {
                          String column = widget.modifiedData['columns'][index];
                          return CustomTextField(
                            controller: controllers[i][index],
                            defaultValue: columnsValues[i][index],
                            labelText: column,
                            hintText: 'Masukkan $column',
                            onChanged: (value) =>
                                _updateValue(i, index, value, column),
                            keyboardType: widget.modifiedData['operation']
                                        ['columns']
                                    .contains(column)
                                ? TextInputType.number
                                : TextInputType.text,
                          );
                        }),
                      ),
                      CustomTextField(
                        labelText: 'Total',
                        hintText: 'Total',
                        enabled: false,
                        defaultValue: results['totals'][i].toString(),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                );
              },
            ),
            ButtonAdd(onPressed: _addColumn, buttonText: 'Tambah'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total'),
                Text(
                  'Rp. ${results['total']}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                  CustomTextField(
                    controller: notesController,
                    hintText: 'Masukkan catatan disini...',
                    maxLines: 5,
                    onChanged: (value) {
                      setState(() {
                        results['notes'] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            ButtonSubmit(handleSubmit: _generatePdf),
          ],
        ),
      ),
    );
  }
}
