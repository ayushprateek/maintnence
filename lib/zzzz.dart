// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ImageSwapPage(),
//     );
//   }
// }
//
// class ImageSwapPage extends StatefulWidget {
//   @override
//   _ImageSwapPageState createState() => _ImageSwapPageState();
// }
//
// class _ImageSwapPageState extends State<ImageSwapPage> {
//   List<String> imagePaths = [
//     'https://m.media-amazon.com/images/I/71iYxdZgElL._AC_UF1000,1000_QL80_.jpg',
//     'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Food3.jpg',
//     'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
//     'https://images.pexels.com/photos/1133957/pexels-photo-1133957.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
//   ];
//
//   int? draggingIndex;
//   int? targetIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Swap App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(imagePaths.length, (index) {
//             return Draggable<int>(
//               data: index,
//               child: DragTarget<int>(
//                 builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
//                   return Image.network(
//                     imagePaths[index],
//                     width: 100,
//                     height: 100,
//                   );
//                 },
//                 onAccept: (int fromIndex) {
//                   setState(() {
//                     String temp = imagePaths[fromIndex];
//                     imagePaths[fromIndex] = imagePaths[index];
//                     imagePaths[index] = temp;
//                   });
//                 },
//               ),
//               feedback: Image.asset(
//                 imagePaths[index],
//                 width: 100,
//                 height: 100,
//               ),
//               childWhenDragging: Container(
//                 width: 100,
//                 height: 100,
//                 color: Colors.grey,
//               ),
//               onDragStarted: () {
//                 setState(() {
//                   draggingIndex = index;
//                 });
//               },
//               onDragCompleted: () {
//                 setState(() {
//                   draggingIndex = null;
//                 });
//               },
//               onDraggableCanceled: (_, __) {
//                 setState(() {
//                   draggingIndex = null;
//                 });
//               },
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
