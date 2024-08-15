import 'package:flutter/material.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD5.dart';

class WhyWhyAnalysis extends StatefulWidget {
  static List<MNJCD5> list = [];

  const WhyWhyAnalysis({super.key});

  @override
  State<WhyWhyAnalysis> createState() => _WhyWhyAnalysisState();
}

class _WhyWhyAnalysisState extends State<WhyWhyAnalysis> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8, top: 20),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              ListView.builder(
                  itemCount: WhyWhyAnalysis.list.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return getDisabledTextFieldWithoutLookup(
                        controller: TextEditingController(
                            text: WhyWhyAnalysis.list[index].Remarks),
                        onChanged: (val) {
                          WhyWhyAnalysis.list[index].Remarks = val;
                        },
                        labelText: "Why?");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
