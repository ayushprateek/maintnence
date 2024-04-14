// import 'package:flutter/material.dart';
// import 'package:html/parser.dart';
//
// class DataSearch extends SearchDelegate<String> {
//
//   List searchedList=[];
//   List lists=[];
//   List list1=[];
//   List list2=[];
//   String _parseHtmlString(String htmlString) {
//     final document = parse(htmlString);
//     final String parsedString = parse(document.body.text).documentElement.text;
//
//
//     return parsedString;
//   }
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     //actions of appbar
//     return [
//       IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             query = "";
//           })
//     ];
//
//
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     //leading icon on the left of the appbar
//     return IconButton(
//         icon: AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow,
//           progress: transitionAnimation,
//         ),
//         onPressed: () {
//           close(context, null);
//         });
//   }
//   @override
//   Widget buildResults(BuildContext context) {
//     showResults(context);
//     return new SearchedItems(query);
//   }
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.isEmpty) {
//       return ListView(
//         children: [
//           Container(
//             height: 20.0,
//           ),
//           // // GROCERY
//           Container(
//             margin: EdgeInsets.only(top: 5),
//             child: Padding(
//               padding: const EdgeInsets.only(left:8.0,right:8.0,top: 2.0,bottom: 2.0),
//               child: Padding(
//                 padding:  EdgeInsets.only(left:2.0),
//                 child: Text(
//                   "Ayush Pratik",
//                   style: TextStyle(
//                       color: Colors.black,fontSize: 20),
//                 ),
//               ),
//             ),
//           ),
//
//
//           Container(
//             height: 20.0,
//           ),
//
//           // VEGETABLES
//
//
//
//           //FRUITS
//         ],
//       );
//       return Container();
//     } else {
//       return ListTile(
//           onTap: () {
//             showResults(context);
//           },
//           leading: Icon(Icons.search),
//           title: Container(
//             child:Text(query)
//           ));
//     }
//   }
// }
