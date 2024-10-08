import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetBottomSheet.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/SyncModels/MNVCL2.dart';
import 'package:sqflite/sqlite_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom drag'),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            final ByteData data = await rootBundle.load('images/tyre.jpg');
            ui.Image _image =
                await decodeImageFromList(data.buffer.asUint8List());
            Get.to(() => TruckDescription(image: _image));
          },
          child: Text('TruckDescription'),
        ),
      ),
    );
  }
}

class TruckDescription extends StatefulWidget {
  final ui.Image image;

  TruckDescription({required this.image});

  @override
  _TruckDescriptionState createState() => _TruckDescriptionState();
}

class _TruckDescriptionState extends State<TruckDescription> {
  List<MNVCL2> tirePositions = [];

  @override
  void initState() {
    super.initState();
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
    String code = 'ASHOK-AMT-03';
    List l = await db.rawQuery('''
    SELECT ifnull(Max(XAxles),0) as NumberOfAxles FROM MNVCL2 WHERE Code='$code'
    ''');
    if (l.isNotEmpty) {
      numOfAxles = int.tryParse(l[0]['NumberOfAxles'].toString()) ?? 0;
    }

    double horizontalGap = height / (numOfAxles + 1);
    double verticalLineX = width / 2;

    for (int i = 1; i <= numOfAxles; i++) {
      double y = i * horizontalGap;
      // Calculate the number of images per side
      List<MNVCL2> list = await retrieveMNVCL2ById(
          null, 'Code = ? AND XAxles = ?', [code, i],
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
    return Scaffold(
      appBar: AppBar(title: Text('Truck Layout')),
      body: Center(
        child: CustomPaint(
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
                            painter: TirePainter(image: widget.image),
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
                                painter: TirePainter(image: widget.image),
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
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double height = Get.height / 2;
    double width = Get.width;
    Paint paint = Paint()
      ..color = barColor
      ..strokeWidth = 4.0;

    double verticalLineX = width / 2;
    double verticalLineTop = 0;
    double verticalLineBottom = height;
    int numHorizontalLines = 5;
    double horizontalGap = height / (numHorizontalLines + 1);

    // Draw the vertical line
    canvas.drawLine(Offset(verticalLineX, verticalLineTop),
        Offset(verticalLineX, verticalLineBottom), paint);
    for (int i = 1; i <= numHorizontalLines; i++) {
      double y = i * horizontalGap;

      // Draw horizontal line
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TirePainter extends CustomPainter {
  final ui.Image image;

  TirePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = barColor
      ..strokeWidth = 4.0;

    double verticalLineX = size.width / 2;
    double verticalLineTop = 0;
    double verticalLineBottom = size.height;

    // Draw the vertical line
    canvas.drawLine(Offset(verticalLineX, verticalLineTop),
        Offset(verticalLineX, verticalLineBottom), paint);

    final Rect srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
