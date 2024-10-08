import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetBottomSheet.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/SyncModels/MNVCL2.dart';
import 'package:maintenance/CheckListDocument/create/GeneralData.dart';
import 'package:maintenance/zztest.dart';
import 'package:sqflite/sqlite_api.dart';
class TyreMaintenance extends StatefulWidget {

  const TyreMaintenance({super.key,

  });

  @override
  State<TyreMaintenance> createState() => _TyreMaintenanceState();
}

class _TyreMaintenanceState extends State<TyreMaintenance> {
  List<MNVCL2> tirePositions = [];
  late ui.Image image;

  @override
  void initState() {
    super.initState();
    setImage();
  }
  void setImage()async{
    final ByteData data = await rootBundle.load('images/tyre.jpg');
    image = await decodeImageFromList(data.buffer.asUint8List());
    initializeTirePositions();
  }

  // void initializeTirePositions()async{
  //   int numOfAxles = 0;
  //   Database db=await initializeDB(null);
  //   String code='ASHOK-AMT-03';
  //   List l=await db.rawQuery('''
  //   SELECT ifnull(Max(XAxles),0) as NumberOfAxles FROM MNVCL2 WHERE Code='$code'
  //   ''');
  //   if(l.isNotEmpty)
  //   {
  //     numOfAxles=int.tryParse(l[0]['NumberOfAxles'].toString())??0;
  //   }
  //
  //   double horizontalGap = Get.height / (numOfAxles + 1);
  //   double verticalLineX = Get.width / 2;
  //
  //   for (int i = 1; i <= numOfAxles; i++) {
  //     double y = i * horizontalGap;
  //     // Calculate the number of images per side
  //     List<MNVCL2> list=await retrieveMNVCL2ById(null, 'Code = ? AND XAxles = ?', [code,i]);
  //     int numImages=list[0].YTyres??0;
  //
  //     // Calculate spacing for images
  //     double imageGap = Get.width / (2 * numImages + 1);
  //
  //     for (int j = 1; j <= numImages; j++) {
  //       double xOffset = j * imageGap;
  //
  //       // Draw images on the left side
  //       tirePositions.add(MNVCL2(
  //         offset: Offset(verticalLineX - xOffset, y - 20)
  //       ));
  //
  //       // Draw images on the right side
  //       tirePositions.add(MNVCL2(
  //         offset: Offset(verticalLineX + xOffset - 40, y - 20)
  //       ));
  //     }
  //   }
  //   setState(() {
  //
  //   });
  // }
  void initializeTirePositions() async {
    double height = Get.height / 2;
    double width = Get.width;
    int numOfAxles = 0;
    Database db = await initializeDB(null);

    List l = await db.rawQuery('''
    SELECT ifnull(Max(XAxles),0) as NumberOfAxles FROM MNVCL2 WHERE Code='${GeneralData.equipmentCode}'
    ''');
    if (l.isNotEmpty) {
      numOfAxles = int.tryParse(l[0]['NumberOfAxles'].toString()) ?? 0;
    }
    if(numOfAxles==0)
      {
        return;
      }

    double horizontalGap = height / (numOfAxles + 1);
    double verticalLineX = width / 2;

    for (int i = 1; i <= numOfAxles; i++) {
      double y = i * horizontalGap;
      // Calculate the number of images per side
      List<MNVCL2> list = await retrieveMNVCL2ById(
          null, 'Code = ? AND XAxles = ?', [GeneralData.equipmentCode, i],
          orderBy: 'ZPosition ASC');
      for (MNVCL2 mnvcl2 in list) {
        mnvcl2.tyreCodeController.text = mnvcl2.TyreCode ?? '';
        mnvcl2.serialNoController.text = mnvcl2.SerialNo ?? '';
        mnvcl2.treadController.text = mnvcl2.Tread?.toStringAsFixed(2) ?? '';
        mnvcl2.pressureController.text = mnvcl2.Pressure ?? '';
        mnvcl2.remarksController.text = mnvcl2.Remarks ?? '';
        mnvcl2.xAxlesController.text = mnvcl2.XAxles?.toStringAsFixed(0) ?? '';
        mnvcl2.yTyresController.text = mnvcl2.YTyres?.toStringAsFixed(0) ?? '';
        mnvcl2.zPositionController.text =
            mnvcl2.ZPosition?.toStringAsFixed(0) ?? '';
      }
      int numImages = list[0].YTyres ?? 0;

      // Calculate spacing for images
      double imageGap = width / (2 * numImages + 1);

      for (int j = 1; j <= numImages; j++) {
        double xOffset = j * imageGap;

        int left = numImages - j;
        int right = numImages + (j - 1);

        // Draw images on the left side
        list[left].offset = Offset(verticalLineX - xOffset, y - 20);
        tirePositions.add(list[left]);

        // Draw images on the right side
        list[right].offset = Offset(verticalLineX + xOffset - 40, y - 20);
        tirePositions.add(list[right]);
      }
    }
    setState(() {});
  }

  // void swapTires(int oldIndex, int newIndex) {
  //   setState(() {
  //     final temp = tirePositions[oldIndex];
  //     tirePositions[oldIndex] = tirePositions[newIndex];
  //     tirePositions[newIndex] = temp;
  //
  //     /// set old index
  //     tirePositions[oldIndex].tyreCodeController.text = tirePositions[oldIndex].TyreCode ?? '';
  //     tirePositions[oldIndex].serialNoController.text = tirePositions[oldIndex].SerialNo ?? '';
  //     tirePositions[oldIndex].treadController.text = tirePositions[oldIndex].Tread?.toStringAsFixed(2) ?? '';
  //     tirePositions[oldIndex].pressureController.text = tirePositions[oldIndex].Pressure ?? '';
  //     tirePositions[oldIndex].remarksController.text = tirePositions[oldIndex].Remarks ?? '';
  //     tirePositions[oldIndex].xAxlesController.text = tirePositions[oldIndex].XAxles?.toStringAsFixed(0) ?? '';
  //     tirePositions[oldIndex].yTyresController.text = tirePositions[oldIndex].YTyres?.toStringAsFixed(0) ?? '';
  //     tirePositions[oldIndex].zPositionController.text = tirePositions[oldIndex].ZPosition?.toStringAsFixed(0) ?? '';
  //
  //     /// set new index
  //     tirePositions[newIndex].tyreCodeController.text = tirePositions[newIndex].TyreCode ?? '';
  //     tirePositions[newIndex].serialNoController.text = tirePositions[newIndex].SerialNo ?? '';
  //     tirePositions[newIndex].treadController.text = tirePositions[newIndex].Tread?.toStringAsFixed(2) ?? '';
  //     tirePositions[newIndex].pressureController.text = tirePositions[newIndex].Pressure ?? '';
  //     tirePositions[newIndex].remarksController.text = tirePositions[newIndex].Remarks ?? '';
  //     tirePositions[newIndex].xAxlesController.text = tirePositions[newIndex].XAxles?.toStringAsFixed(0) ?? '';
  //     tirePositions[newIndex].yTyresController.text = tirePositions[newIndex].YTyres?.toStringAsFixed(0) ?? '';
  //     tirePositions[newIndex].zPositionController.text = tirePositions[newIndex].ZPosition?.toStringAsFixed(0) ?? '';
  //
  //     print('Hii');
  //   });
  // }

  void swapTires(int oldIndex, int newIndex) {
    setState(() {
      final temp = tirePositions[oldIndex];
      tirePositions[oldIndex] = tirePositions[newIndex];
      tirePositions[newIndex] = temp;

      // Swap the controllers' text values
      swapControllers(tirePositions[oldIndex], tirePositions[newIndex]);
    });
  }

  void swapControllers(MNVCL2 tire1, MNVCL2 tire2) {
    // Swap tire codes
    final tireCode1 = tire1.tyreCodeController.text;
    tire1.tyreCodeController.text = tire2.tyreCodeController.text;
    tire2.tyreCodeController.text = tireCode1;

    // Swap serial numbers
    final serialNo1 = tire1.serialNoController.text;
    tire1.serialNoController.text = tire2.serialNoController.text;
    tire2.serialNoController.text = serialNo1;

    // Swap tread values
    final tread1 = tire1.treadController.text;
    tire1.treadController.text = tire2.treadController.text;
    tire2.treadController.text = tread1;

    // Swap pressure values
    final pressure1 = tire1.pressureController.text;
    tire1.pressureController.text = tire2.pressureController.text;
    tire2.pressureController.text = pressure1;

    // Swap remarks
    final remarks1 = tire1.remarksController.text;
    tire1.remarksController.text = tire2.remarksController.text;
    tire2.remarksController.text = remarks1;

    // Swap axle values
    final xAxles1 = tire1.xAxlesController.text;
    tire1.xAxlesController.text = tire2.xAxlesController.text;
    tire2.xAxlesController.text = xAxles1;

    // Swap tyre count
    final yTyres1 = tire1.yTyresController.text;
    tire1.yTyresController.text = tire2.yTyresController.text;
    tire2.yTyresController.text = yTyres1;

    // Swap Z position values
    final zPosition1 = tire1.zPositionController.text;
    tire1.zPositionController.text = tire2.zPositionController.text;
    tire2.zPositionController.text = zPosition1;
  }
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(),
      child: Stack(
        children: List.generate(tirePositions.length, (index) {
          return Positioned(
            left: tirePositions[index].offset?.dx,
            top: tirePositions[index].offset?.dy,
            child: Column(
              children: [
                getHeadingText(text: index.toString()),
                InkWell(
                  onTap: () {
                    getBottomSheet(
                        context: Get.context!,
                        content: SizedBox(
                          width: Get.width,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  getTextFieldWithoutLookup(
                                      controller: tirePositions[index]
                                          .tyreCodeController,
                                      labelText: 'TyreCode',
                                      height: 35),
                                  getDisabledTextFieldWithoutLookup(
                                      controller:
                                      tirePositions[index].xAxlesController,
                                      labelText: 'Axles',
                                      height: 35),
                                  getDisabledTextFieldWithoutLookup(
                                      controller:
                                      tirePositions[index].yTyresController,
                                      labelText: 'Tyre',
                                      height: 35),
                                  getDisabledTextFieldWithoutLookup(
                                      controller: tirePositions[index]
                                          .zPositionController,
                                      labelText: 'Position',
                                      height: 35),
                                  if (tirePositions[index]
                                      .serialNoController
                                      .text
                                      .isEmpty)
                                    getTextFieldWithoutLookup(
                                        controller: tirePositions[index]
                                            .serialNoController,
                                        labelText: 'Serial No',
                                        height: 35)
                                  else
                                    getDisabledTextFieldWithoutLookup(
                                        controller: tirePositions[index]
                                            .serialNoController,
                                        labelText: 'Serial No',
                                        height: 35),
                                  getTextFieldWithoutLookup(
                                      controller:
                                      tirePositions[index].treadController,
                                      labelText: 'Tread',
                                      height: 35),
                                  getTextFieldWithoutLookup(
                                      controller: tirePositions[index]
                                          .pressureController,
                                      labelText: 'Pressure',
                                      height: 35),
                                  getTextFieldWithoutLookup(
                                      controller: tirePositions[index]
                                          .remarksController,
                                      labelText: 'Remarks',
                                      height: 35),
                                ],
                              ),
                            ),
                          ),
                        ),
                        height: 2 * Get.height / 3);
                  },
                  child: Draggable<int>(
                    data: index,
                    feedback: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: tirePositions[index]
                                  .serialNoController
                                  .text
                                  .isEmpty
                                  ? Colors.red
                                  : Colors.blue,
                              width: 1.5)),
                      child: CustomPaint(
                        size: Size(50, 50),
                        painter: TirePainter(image: image),
                      ),
                    ),
                    childWhenDragging: Container(),
                    child: DragTarget<int>(
                      onAccept: (oldIndex) {
                        swapTires(oldIndex, index);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: tirePositions[index]
                                      .serialNoController
                                      .text
                                      .isEmpty
                                      ? Colors.red
                                      : Colors.blue,
                                  width: 1.5)),
                          child: CustomPaint(
                            size: Size(50, 50),
                            painter: TirePainter(image: image),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
