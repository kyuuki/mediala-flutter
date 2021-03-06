import 'package:flutter/material.dart';
import 'package:mediala/service/notification_service.dart';

import '../db/mediala_database.dart';
import '../model/medicine.dart';
import 'medicine_detail_page.dart';
import 'medicine_new_page.dart';

class MedicineListPage extends StatefulWidget {
  const MedicineListPage({Key? key}) : super(key: key);

  @override
  State<MedicineListPage> createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("お薬一覧")),
      persistentFooterButtons: [
        Center(
          child: ElevatedButton(
            child: const Text("薬を登録する"),
            onPressed: () async {
              //Medicine medicne = await Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineNewPage()));
              await Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineNewPage()));

              // new_page で登録したデータをここで取り出し
              medicines = await MediaAlaDatabase.instance.getAllMedicines();

              setState(() {
                // グローバル変数に入れる処理はここじゃなくても大丈夫？
                // setState の中でやる処理は？
              });
            },
          ),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: MedicineList(),
      ),
    );
  }
}

// TODO: グローバルにはしたくない
// Widget 間のやりとりをあとで勉強
// BLoCパターン
// リアクティブプログラミング
// グローバル変数 (今はこれ)
// Stream
// RxDart
// Provider

// お薬リスト
List<Medicine> medicines = [];

class MedicineList extends StatefulWidget {
  //const MedicineList({Key? key}) : super(key: key);

  @override
  _MedicineListState createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {

  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    refreshMedicines();
  }

  @override
  void dispose() {
    MediaAlaDatabase.instance.close();
    super.dispose();
  }

  Future refreshMedicines() async {
    setState(() => isLoading = true);
    medicines = await MediaAlaDatabase.instance.getAllMedicines();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context){
    return ListView.separated(
      itemCount: medicines.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: const Icon(Icons.medical_services),
          title: Text(
              medicines[i].name
          ),
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineDetailPage(medicines[i])))
          },
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_rounded,
            ),
            onPressed: () async {
              List alarms = await MediaAlaDatabase.instance.getAlarms(medicines[i].id!);
              for (int i=0; i<alarms.length; i++) {
               await NotificationService.cancelNotification(alarms[i]);
              }
              MediaAlaDatabase.instance.deleteMedicine(medicines[i].id!);
              refreshMedicines();
            } ,
          ),
        );
      },
      separatorBuilder: (context, i) {
        return const Divider();
      },
    );
  }
}
