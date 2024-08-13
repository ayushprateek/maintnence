import 'dart:io';

import 'package:flutter/material.dart';

class ViewImageFile extends StatelessWidget {
  final File file;

  const ViewImageFile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File View'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 8, right: 8),
        child: Image.file(file),
      ),
    );
  }
}
