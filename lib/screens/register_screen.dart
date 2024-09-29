import 'package:flutter/material.dart';
import 'package:invoice_generator/screens/input_values_screen.dart';
import 'package:invoice_generator/widgets/button_submit.dart';
import 'package:invoice_generator/widgets/formula_total.dart';
import 'package:invoice_generator/widgets/main_layout.dart';
import 'package:invoice_generator/widgets/personal_information.dart';
import 'package:invoice_generator/widgets/table_columns.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> columnValues = [];
  var modifiedData = {
    'informations': {'name': '', 'bank': '', 'rekening': ''},
    'columns': [],
    'operation': {'columns': [], 'operator': ''}
  };

  void handleChange(List<String> values) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        columnValues = values;
        modifiedData['columns'] = values;
      });
    });
  }

  void handleChangeOperation(e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        modifiedData['operation'] = e;
      });
    });
  }

  void handleChangePersonalInformation(Map<String, dynamic> e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        modifiedData['informations'] = e;
      });
    });
  }

  void handleSubmit() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InputValuesScreen(
        modifiedData: modifiedData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Form Invoice',
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListView(
          children: [
            PersonalInformation(
              handleChange: handleChangePersonalInformation,
            ),
            TableColumns(
              handleChange: handleChange,
            ),
            FormulaTotal(
              options: columnValues,
              handleChange: handleChangeOperation,
            ),
            ButtonSubmit(handleSubmit: handleSubmit),
          ],
        ),
      ),
    );
  }
}
