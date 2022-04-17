import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediala/service/notification_service.dart';
import 'package:sprintf/sprintf.dart';

import '../db/mediala_database.dart';
import '../model/alarm.dart';
import '../model/medicine.dart';

// 薬詳細ページ
class MedicineDetailPage extends StatelessWidget {
  //const MedicineDetailPage({Key? key}) : super(key: key);  // TODO: 後で調べる

  Medicine medicine;

  MedicineDetailPage(this.medicine);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("お薬アラーム編集")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.medical_services),
                ),
                Text(
                  medicine.name,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: AlertList(mediCineId: medicine.id!), // 前画面から渡される Medicine なので ID は絶対に入っている
            ),
          ),
        ],
      ),
    );
  }

}

//
// アラームリスト (Stateful)
//
class AlertList extends StatefulWidget {
  // Constant constructors
  // https://dart.dev/guides/language/language-tour#constant-constructors
  // https://docs.flutter.dev/development/ui/interactive#the-parent-widget-manages-the-widgets-state
  const AlertList({Key? key, required this.mediCineId}) : super(key: key);

  // 薬 ID
  final int mediCineId;

  @override
  _AlertListState createState() => _AlertListState();
}

class _AlertListState extends State<AlertList> {
  List<Alarm> alarms = [
    //Alarm(15,30,[ true, true, true, true, true, true, true ], 1, 2),
    //Alarm(13, 0, [ true, false, false, false, true, false, false ]),
    //Alarm(17, 30, [ true, false, true, true, false, false, true ]),
  ];

  @override
  void initState() {
    super.initState();
    refreshAlarms();  // Future のためだけに別メソッド？
  }

  Future refreshAlarms() async {
    alarms = await MediaAlaDatabase.instance.getAlarms(widget.mediCineId);
    setState(() {
      // 何書くの？
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // TODO: 使いやすく
      itemCount: alarms.length + 1,
      itemBuilder: (context, i) {
        // 最後の追加ボタン
        if (i == alarms.length) {
          return ListTile(
            leading: const Icon(Icons.add_circle),
            onTap: () async {
              InputAlarm inputAlarm = await openDialog(context);
              var alarm = await MediaAlaDatabase.instance.createAlarm(
                  Alarm(inputAlarm.hour, inputAlarm.minute, inputAlarm.days, widget.mediCineId));

              // アラーム設定
              await NotificationService.scheduleAlarm(alarm);

              setState(() {
                alarms.add(alarm);
              });
            },
          );
        }

        return ListTile(
          leading: const Icon(Icons.alarm),
          title: Text(
            sprintf("%02d:%02d", [ alarms[i].hour, alarms[i].minute ]),
          ),
          subtitle: buildRowDays(alarms[i].days),
          trailing: IconButton(
            icon: const Icon(
              Icons.remove_circle,
            ),
            onPressed: () async {
              //
              // アラーム削除処理
              //
              await NotificationService.cancelNotification(alarms[i]);
              MediaAlaDatabase.instance.deleteAlarm(alarms[i].id!);
              setState(() {
                alarms.removeAt(i);
              });
            } ,
          ),
        );
      },
      separatorBuilder: (context, i) {
        return const Divider();
      },
    );
  }

  // 曜日のリスト作成
  Wrap buildRowDays(List<bool> days) {
    List<Widget> children = [];
    if (days.every((d) => d)) {
      children.add(buildChipDay("毎日"));
    } else if (days.where((d) => d).length == 6) {
      String label = "";
      days.asMap().forEach((i, v) {
        if (!v) {
          label = label + (Alarm.dayTexts[i]);
        }
      });
      children.add(buildChipDay("${label}以外"));
    } else {
      days.asMap().forEach((i, v) {
        if (v) {
          children.add(buildChipDay(Alarm.dayTexts[i]));
        }
      });
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  Chip buildChipDay(String text) {
    return Chip(
            //avatar: Icon(Icons.alarm),
            label: Text(
              text,
              style: TextStyle(fontSize: 12.0),
            ),
          );
  }
}

// https://www.youtube.com/watch?v=D6icsXS8NeA
Future openDialog(BuildContext context) {
  var _hourController = TextEditingController();
  var _minuteController = TextEditingController(text: "00");
  List<DaysModel> days = [
    DaysModel("日"),
    DaysModel("月"),
    DaysModel("火"),
    DaysModel("水"),
    DaysModel("木"),
    DaysModel("金"),
    DaysModel("土"),
  ];

  return showDialog<InputAlarm>(  // ← ここ <> にダイアログからの戻り値の型を書く
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
          title: const Text("アラーム追加"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: const InputDecoration(labelText: "時"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"^([01]?[0-9]|2[0-3])$"))
                        ],
                        controller: _hourController,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        ":",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        decoration: const InputDecoration(labelText: "分"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"^[0-5]?[0-9]$"))
                        ],
                        controller: _minuteController,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 18.0,
                ),
                // 日 〜 土 のチェックボックス
                for (var d in days) checkboxListTile(d, setState),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("キャンセル"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("追加"),
              onPressed: () async{
                int hour = int.parse(_hourController.text);
                int minute = int.parse(_minuteController.text);

                // DB 保存箇所をダイアログから戻った場所に移動
                //var alarm = await MediaAlaDatabase.instance.createAlarm(Alarm(hour, minute, days.map((d) => d.checked).toList(), 5));
                Navigator.pop(context, InputAlarm(hour, minute, days.map((d) => d.checked).toList()));
              },
            ),
          ]),
    ),
  );
}

// アラーム入力ダイアログの入力データ
class InputAlarm {
  final int hour;
  final int minute;
  final List<bool> days;

  const InputAlarm(this.hour, this.minute, this.days);
}

// 曜日のチェックボックスのモデル
class DaysModel {
  final String name;
  bool checked = true;

  DaysModel(this.name);
}

// 毎週のチェックボックス
CheckboxListTile checkboxListTile(DaysModel daysModel, StateSetter setState) {
  return CheckboxListTile(
                title: Text(daysModel.name),
                value: daysModel.checked,
                onChanged: (bool? e) {
                  setState(() {
                    daysModel.checked = e!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
}
