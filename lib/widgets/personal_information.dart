import 'package:flutter/material.dart';
import 'package:invoice_generator/widgets/custom_text_field.dart';
import 'package:invoice_generator/widgets/dropdown_input.dart';
import 'package:invoice_generator/widgets/form_layout.dart';

class PersonalInformation extends StatefulWidget {
  final Function(Map<String, dynamic>) handleChange;

  PersonalInformation({Key? key, required this.handleChange}) : super(key: key);

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final listBank = ['BCA', 'MANDIRI', 'BRI', 'BNI'];
  final Map<String, dynamic> informations = {
    'name': '',
    'bank': '',
    'rekening': '',
  };

  late TextEditingController nameController;
  late TextEditingController rekeningController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: informations['name']);
    rekeningController = TextEditingController(text: informations['rekening']);
  }

  void _updateInformation() {
    widget.handleChange(informations);
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      title: 'Informasi Diri',
      children: [
        Column(
          children: [
            CustomTextField(
              controller: nameController,
              labelText: 'Nama',
              hintText: 'Silahkan isi nama anda',
              onChanged: (value) {
                setState(() {
                  informations['name'] = value;
                  _updateInformation();
                });
              },
            ),
            DropdownInput(
              options: listBank,
              labelText: 'Nama Bank',
              handleSubmit: (value) {
                setState(() {
                  informations['bank'] = value;
                  _updateInformation();
                });
              },
            ),
            CustomTextField(
              controller: rekeningController,
              labelText: 'No. Rekening',
              hintText: 'Silahkan isi nomor rekening anda',
              onChanged: (value) {
                setState(() {
                  informations['rekening'] = value;
                  _updateInformation();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    rekeningController.dispose();
    super.dispose();
  }
}
