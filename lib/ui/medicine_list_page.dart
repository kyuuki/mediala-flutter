import 'package:flutter/material.dart';
import 'package:mediala/db/mediala_database.dart';

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
              // この値を MedicineList に渡したい。
              // DB に入れちゃうのが楽なのか？
             /** setState(() {
                medicines.add(medicne);
              });**/
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
// お薬リスト
/**List<Medicine> medicines = [
  //Medicine("ビタミン剤", ""),
 // Medicine("目薬", ""),
  //Medicine("喉のくすり", ""),
]; */
class MedicineList extends StatefulWidget {
  //const MedicineList({Key? key}) : super(key: key);

  @override
  _MedicineListState createState() => _MedicineListState();
  /**void add(Medicine medicine) {
    medicines.add(medicine);
  }**/
}

class _MedicineListState extends State<MedicineList> {

  late List<Medicine> medicines;
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
    this.medicines = (await MediaAlaDatabase.instance.getAllMedicines())!;
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
          trailing: const Icon(Icons.delete_forever),
        );
      },
      separatorBuilder: (context, i) {
        return const Divider();
      },
    );
  }
}
