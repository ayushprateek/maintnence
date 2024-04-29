import 'package:flutter/material.dart';
class EquipmentCodeLookup extends StatefulWidget {
  const EquipmentCodeLookup({super.key});

  @override
  State<EquipmentCodeLookup> createState() => _EquipmentCodeLookupState();
}

class _EquipmentCodeLookupState extends State<EquipmentCodeLookup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Code'),
      ),
    );
  }
}
