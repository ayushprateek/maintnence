import 'package:flutter/material.dart';
class SerialNoData extends StatefulWidget {
  //todo:
  const SerialNoData({super.key});

  @override
  State<SerialNoData> createState() => _SerialNoDataState();
}

class _SerialNoDataState extends State<SerialNoData> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 265,)
        ],
      ),
    );
  }
}
