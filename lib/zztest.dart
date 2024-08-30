import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';

// void main() {
//   runApp(MyApp());
// }

class TruckDescription extends StatelessWidget {
  ui.Image image;

  TruckDescription({required this.image});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Truck Layout')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomPaint(
            size: Size(Get.width, Get.height/1.5),
            painter: TruckLayoutPainter(image: image),
          ),
        ),
      ),
    );
  }
}

class TruckLayoutPainter extends CustomPainter {
  ui.Image image;

  TruckLayoutPainter({required this.image});

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

    int numHorizontalLines = 5;
    double horizontalGap = size.height / (numHorizontalLines + 1);

    for (int i = 1; i <= numHorizontalLines; i++) {
      double y = i * horizontalGap;

      // Draw horizontal line
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      // Calculate the number of images per side
      int numImages = i;
      if (i == 4) {
        numImages = 3;
      } else if (i == 5) {
        numImages = 2;
      }

      // Calculate spacing for images
      double imageGap = size.width / (2 * numImages + 1);

      for (int j = 1; j <= numImages; j++) {
        double xOffset = j * imageGap;

        // Draw images on the left side
        drawTireImage(canvas, Offset(verticalLineX - xOffset, y - 20), 40, 40);

        // Draw images on the right side
        drawTireImage(
            canvas, Offset(verticalLineX + xOffset - 40, y - 20), 40, 40);
      }
    }
  }

  Future<void> drawTireImage(
      Canvas canvas, Offset position, double width, double height) async {
    // Rect rect = Rect.fromLTWH(position.dx, position.dy, width, height);
    // Paint paint = Paint()..color = Colors.grey;

    // Placeholder for tire image
    // canvas.drawRect(rect, paint);

    // You can replace the above code with image drawing using Image.asset
    // For example:
    // final ByteData data = await rootBundle.load('images/logo.png');
    // final ui.Image image = await decodeImageFromList(data.buffer.asUint8List());
    final Rect srcRect = Rect.fromLTWH(0, 0, 50, 50);
    final Rect dstRect = Rect.fromLTWH(position.dx, position.dy, 50, 50);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
