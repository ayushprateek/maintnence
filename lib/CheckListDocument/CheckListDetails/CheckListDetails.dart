import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListDetails/AddCheckList.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
class CheckListDetails extends StatefulWidget {
   static List<MNCLD1> items=[];

    CheckListDetails({super.key});

  @override
  State<CheckListDetails> createState() => _CheckListDetailsState();
}

class _CheckListDetailsState extends State<CheckListDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "+ Add Item",
                  style: TextStyle(
                    color: barColor,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onPressed: () {
                  Get.to(()=>AddCheckList());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
