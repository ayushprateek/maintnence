import 'package:flutter/material.dart';

class BatchNoData extends StatefulWidget {
  //todo:
  const BatchNoData({super.key});

  @override
  State<BatchNoData> createState() => _BatchNoDataState();
}

class _BatchNoDataState extends State<BatchNoData> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 265,
          )
        ],
      ),
    );
  }
}
