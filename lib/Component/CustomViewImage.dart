import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maintenance/Component/CustomColor.dart';


class CustomViewImage extends StatelessWidget {
  File imageFile;

  CustomViewImage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text("Image View"),
      ),
      body: Image.file(
        imageFile,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
