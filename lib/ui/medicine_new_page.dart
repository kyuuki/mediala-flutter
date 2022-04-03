import 'package:flutter/material.dart';

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
              onPressed: () {
                Navigator.pop(context, Medicine(_nameController.text, ""));
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
              child: TextField(
                enabled: true,
                maxLength: 80,
                obscureText: false,
                maxLines:1,
                decoration: const InputDecoration(
                  icon: Icon(Icons.medical_services),
                  hintText: '薬の名前を入力してください',
                  labelText: 'お薬名',
                ),
                controller: _nameController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}