import 'package:flutter/material.dart';
import 'package:maintenance/Component/GetTextField.dart';
class ShippingAddress extends StatefulWidget {
  const ShippingAddress({super.key});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  final TextEditingController _docNum =
  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          getDisabledTextField(controller: _docNum, labelText: 'Address'),
          getDisabledTextField(controller: _docNum, labelText: 'Address code'),
          getDisabledTextField(controller: _docNum, labelText: 'City Name'),
          getDisabledTextField(controller: _docNum, labelText: 'Region Name'),
          getDisabledTextField(controller: _docNum, labelText: 'Country Name'),
        ],
      ),
    );
  }
}
