import 'package:flutter/material.dart';

getBottomSheet(
    {required BuildContext context,
      required Widget content,
      required double height,
      bool isDismissible = true,
      bool enableDrag = true}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: content,
    ),
  );
}
