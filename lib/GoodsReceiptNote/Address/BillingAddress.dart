import 'package:flutter/material.dart';
import 'package:maintenance/Component/GetTextField.dart';
class BillingAddress extends StatefulWidget {
  const BillingAddress({super.key});

  @override
  State<BillingAddress> createState() => _BillingAddressState();
}

class _BillingAddressState extends State<BillingAddress> {
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
          getDisabledTextField(controller: _docNum, labelText: 'Route code'),
        ],
      ),
    );
  }
}
