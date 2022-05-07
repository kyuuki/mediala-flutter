import 'package:flutter/material.dart';

import '../db/mediala_database.dart';
import '../model/medicine.dart';

class MedicineNewPage extends StatelessWidget {
  //const MedicineNewPage({Key? key}) : super(key: key);

  var _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("お薬登録")),
      persistentFooterButtons: [
        Row(
          children: [
            const Spacer(),
            ElevatedButton(
              child: Text("キャンセルする"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ElevatedButton(
              child: Text("保存する"),
              onPressed: () async{
                if (!(_formKey.currentState!.validate())) {
                  return;
                }
                await MediaAlaDatabase.instance.create(Medicine(_nameController.text));
                //Navigator.pop(context, Medicine(_nameController.text, ""));
                Navigator.pop(context);
              },
            ),
            const Spacer(),
          ],
        ),
      ],
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: InputForm(_nameController),
            ),
          ],
        ),
      ),
    );
  }
}

// https://docs.flutter.dev/cookbook/forms/validation
class InputForm extends StatefulWidget {
  TextEditingController textEditingController;

  InputForm(this.textEditingController);

  @override
  InputFormState createState() {
    return InputFormState(textEditingController);
  }
}

final _formKey = GlobalKey<FormState>();  // ここでもいい？

class InputFormState extends State<InputForm> {
  //final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController;

  InputFormState(this.textEditingController);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        enabled: true,
        maxLength: 80,
        obscureText: false,
        maxLines:1,
        decoration: const InputDecoration(
          icon: Icon(Icons.medical_services),
          hintText: '薬の名前を入力してください',
          labelText: 'お薬名',
        ),
        controller: textEditingController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "お薬名を入力してください。";
          }
          return null;
        },
      ),
    );
  }
}
