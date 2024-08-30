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

import 'package:flutter/material.dart';

class DragDemo extends StatefulWidget {
  const DragDemo({super.key});

  @override
  State<DragDemo> createState() => _DragDemoState();
}

class _DragDemoState extends State<DragDemo> with TickerProviderStateMixin {
  final GlobalKey _draggableKey = GlobalKey();
  List<String> _items = [
    'https://m.media-amazon.com/images/I/71iYxdZgElL._AC_UF1000,1000_QL80_.jpg',
    'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Food3.jpg',
    'https://itfitt.com/assets/coming-soon.jpeg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drag Demo'),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                    itemBuilder: (context, index) {
                      final url = _items[index];

                      ///TODO:CREATE A MODEL CLASS TO PADD INDEX WITH OTHER DATA
                      return DragTarget(
                        builder: (context, candidateItems, rejectedItems) {
                          return LongPressDraggable(
                            data: url,
                            dragAnchorStrategy: pointerDragAnchorStrategy,
                            feedback: ClipRRect(
                              key: _draggableKey,
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Opacity(
                                  opacity: 0.85,
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        onAcceptWithDetails: (details) {
                          int oldIndex = -1;
                          for (int i = 0; i < _items.length; i++) {
                            if (_items[i] == details.data) {
                              oldIndex = i;
                              break;
                            }
                          }
                          _items[oldIndex] = url;
                          _items[index] =
                              details.data?.toString() ?? _items[index];
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
