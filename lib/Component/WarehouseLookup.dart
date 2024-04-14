import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';
import 'package:maintenance/main.dart';
class WarehouseLookup extends StatefulWidget {
  Function(String WhsCode,String WhsName) onSelection;
   WarehouseLookup({super.key,required this.onSelection});

  @override
  State<WarehouseLookup> createState() => _WarehouseLookupState();
}

class _WarehouseLookupState extends State<WarehouseLookup> {
  TextEditingController query = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text(
          "Select Warehouse",
          style: TextStyle(color: Colors.white, fontFamily: custom_font),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
         child: Column(
           children: [
             Padding(
               padding: const EdgeInsets.only(
                   left: 4.0, bottom: 15, right: 4, top: 15),
               child: Container(
                 height: 43,
                 width: MediaQuery.of(context).size.width,
                 child: Row(
                   children: [
                     Expanded(
                       flex: 3,
                       child: getTextFieldWithoutLookup(
                         controller: query,
                         prefixIcon: Icon(
                           Icons.search,
                           color: barColor,
                         ),
                         suffixIcon: IconButton(
                           icon: Icon(
                             Icons.clear,
                             color: barColor,
                           ),
                           onPressed: () {
                             setState(() {
                               query.text = "";
                             });
                           },
                         ),
                         labelText: 'Search warehouse',
                         //keyboardType: TextInputType.number,
                         style: new TextStyle(
                           fontFamily: "Poppins",
                         ),
                       ),
                     ),
                     Expanded(
                       child: Padding(
                         padding: const EdgeInsets.only(left: 4.0, bottom: 6),
                         child: Material(
                           borderRadius: BorderRadius.circular(10.0),
                           color: barColor,
                           child: MaterialButton(
                             onPressed: () async {
                               setState(() {
                                 query;
                               });
                             },
                             minWidth: MediaQuery.of(context).size.width,
                             child: FittedBox(
                               child: Text(
                                 "Search",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   color: Colors.white,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             FutureBuilder(
               future: retrieveOWHSById(context, "BranchId = ? AND Active = ?",
                   [userModel.BranchId,1]),
               builder: (BuildContext context,
                   AsyncSnapshot<List<OWHS>> snapshot) {
                 if (snapshot.hasData) {
                   return ListView.separated(
                     itemCount: snapshot.data?.length ?? 0,
                     shrinkWrap: true,
                     physics: ScrollPhysics(),
                     itemBuilder: (BuildContext context, int index) {
                       if (query.text.isNotEmpty
                           ? (snapshot.data![index].WhsCode.toString())
                           .toUpperCase()
                           .contains(query.text.toString().toUpperCase()) ||
                           (snapshot.data![index].WhsName.toString())
                               .toUpperCase()
                               .contains(query.text.toString().toUpperCase())
                           :  true) {
                         //searching
                         return InkWell(
                           onDoubleTap: (){
                             widget.onSelection(snapshot.data![index].WhsCode??'',snapshot.data![index].WhsName??'');
                             Get.back();
                           },
                           child: Container(
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 shape: BoxShape.rectangle,
                                 borderRadius: BorderRadius.circular(16.0),
                                 boxShadow: const [
                                   BoxShadow(
                                     color: Colors.black26,
                                     blurRadius: 4.0,
                                     offset: Offset(2.0, 2.0),
                                   ),
                                 ],
                               ),
                               margin: const EdgeInsets.all(15),
                               width: MediaQuery.of(context).size.width,
                               child: Padding(
                                 padding: const EdgeInsets.all(8),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text.rich(
                                       TextSpan(
                                         children: [
                                           getPoppinsTextSpanHeading(
                                               text: 'WhsCode'),
                                           getPoppinsTextSpanDetails(
                                               text: snapshot.data![index].WhsCode
                                                   .toString()),
                                         ],
                                       ),
                                     ),
                                     Text.rich(
                                       TextSpan(
                                         children: [
                                           getPoppinsTextSpanHeading(
                                               text: 'WhsName'),
                                           getPoppinsTextSpanDetails(
                                               text: snapshot
                                                   .data![index].WhsName
                                                   .toString() ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               )),
                         );
                       }
                       return Container(
                         height: 0,
                         width: 0,
                       );
                     },
                     separatorBuilder: (BuildContext context, int index) {
                       if (query.text.isNotEmpty
                           ? (snapshot.data![index].WhsCode.toString())
                           .toUpperCase()
                           .contains(query.text.toString().toUpperCase()) ||
                           (snapshot.data![index].WhsName.toString())
                               .toUpperCase()
                               .contains(query.text.toString().toUpperCase())
                           :  true)  {
                         return Divider(
                           thickness: 1.5,
                         );
                       }
                       return Container(
                         height: 0,
                         width: 0,
                       );
                     },
                   );
                 } else {
                   return Center(child: CircularProgressIndicator());
                 }
               },
             ),
           ],
         ),
      ),
    );
  }
}
