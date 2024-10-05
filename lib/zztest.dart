import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
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
            ui.Image _image = await decodeImageFromList(data.buffer.asUint8List());
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
  void initializeTirePositions()async{
    int numOfAxles = 0;
    Database db=await initializeDB(null);
    String code='ASHOK-AMT-03';
    List l=await db.rawQuery('''
    SELECT ifnull(Max(XAxles),0) as NumberOfAxles FROM MNVCL2 WHERE Code='$code'
    ''');
    if(l.isNotEmpty)
      {
        numOfAxles=int.tryParse(l[0]['NumberOfAxles'].toString())??0;
      }
    List<MNVCL2> mnvlc2List=await retrieveMNVCL2ById(null, 'Code = ?', [code]);


    double horizontalGap = Get.height / (numOfAxles + 1);
    double verticalLineX = Get.width / 2;
    // double verticalLineTop = 0;
    // double verticalLineBottom = Get.height;

    for (int i = 1; i < mnvlc2List.length; i++) {
      double y = i * horizontalGap;

      // Calculate the number of images per side
      int numImages = 0;

      List l=await db.rawQuery('''
    SELECT ifnull(MaX(YTyres),0) as YTyres FROM MNVCL2 WHERE Code='ASHOK-AMT-03' and XAxles=5
    ''');
      if(l.isNotEmpty)
      {
        numImages=int.tryParse(l[0]['YTyres'].toString())??0;
      }
      // Calculate spacing for images
      double imageGap = Get.width / (2 * numImages + 1);

      for (int j = 1; j <= numImages; j++) {
        double xOffset = j * imageGap;

        // Draw images on the left side
        tirePositions.add(MNVCL2(
          offset: Offset(verticalLineX - xOffset, y - 20)
        ));

        // Draw images on the right side
        tirePositions.add(MNVCL2(
          offset: Offset(verticalLineX + xOffset - 40, y - 20)
        ));
      }
    }
    setState(() {

    });
    // for (int i = 1; i <= numHorizontalLines; i++) {
    //   double y = i * horizontalGap;
    //
    //   // Draw horizontal line
    //   canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    //
    //   // Calculate the number of images per side
    //   int numImages = i;
    //   if (i == 4) {
    //     numImages = 3;
    //   } else if (i == 5) {
    //     numImages = 2;
    //   }
    //
    //   // Calculate spacing for images
    //   double imageGap = size.width / (2 * numImages + 1);
    //
    //   for (int j = 1; j <= numImages; j++) {
    //     double xOffset = j * imageGap;
    //
    //     // Draw images on the left side
    //     drawTireImage(canvas, Offset(verticalLineX - xOffset, y - 20), 40, 40);
    //
    //     // Draw images on the right side
    //     drawTireImage(
    //         canvas, Offset(verticalLineX + xOffset - 40, y - 20), 40, 40);
    //   }
    // }
  }

  void swapTires(int oldIndex, int newIndex) {
    setState(() {
      final temp = tirePositions[oldIndex];
      tirePositions[oldIndex] = tirePositions[newIndex];
      tirePositions[newIndex] = temp;
    });
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
                child: Draggable<int>(
                  data: index,
                  feedback: Container(
                    width: 50,
                    height: 50,
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
                      return CustomPaint(
                        size: Size(50, 50),
                        painter: TirePainter(image: widget.image),
                      );
                    },
                  ),
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
    Paint paint = Paint()
      ..color = barColor
      ..strokeWidth = 4.0;

    double verticalLineX = Get.width / 2;
    double verticalLineTop = 0;
    double verticalLineBottom = Get.height;
    int numHorizontalLines = 5;
    double horizontalGap = Get.height / (numHorizontalLines + 1);

    // Draw the vertical line
    canvas.drawLine(Offset(verticalLineX, verticalLineTop),
        Offset(verticalLineX, verticalLineBottom), paint);
    for (int i = 1; i <= numHorizontalLines; i++) {
      double y = i * horizontalGap;

      // Draw horizontal line
      canvas.drawLine(Offset(0, y), Offset(Get.width, y), paint);
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

    final Rect srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
