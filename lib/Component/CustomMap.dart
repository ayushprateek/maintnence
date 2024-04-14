// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:maintenance/Component/ClearTextFieldData.dart';
// import 'package:maintenance/Component/CompanyDetails.dart';
// import 'package:maintenance/Component/CustomColor.dart';
// import 'package:maintenance/Component/CustomFont.dart';
// import 'package:maintenance/Component/GetLastDocNum.dart';
// import 'package:maintenance/Component/IsAvailableTransId.dart';
// import 'package:maintenance/Component/SnackbarComponent.dart';
// import 'package:maintenance/CustomersVisit/CustomerVisit.dart';
// import 'package:maintenance/CustomersVisit/GeneralData.dart' as CVGdenData;
// import 'package:maintenance/DatabaseInitialization.dart';
// import 'package:maintenance/Sync/CustomURL.dart';
// import 'package:maintenance/Sync/SyncModels/CRD2.dart';
// import 'package:maintenance/Sync/SyncModels/OCRD.dart';
// import 'package:maintenance/Sync/SyncModels/ROUT.dart';
// import 'package:maintenance/VisitPlan/GeneralData.dart';
// import 'package:maintenance/VisitPlan/Plan/VisitList.dart';
// import 'package:maintenance/main.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:sqflite/sqlite_api.dart';
//
// Future<void> onCVCustomerSelection({
//   required String Code,
// }) async {
//   OCRDModel ocrdModel =
//       (await retrieveOCRDById(null, 'Code = ? AND Active = ?', [Code, 1]))[0];
//
//   bool currencyRateExists = false;
//   if (CompanyDetails.ocinModel?.LCurr == ocrdModel.Currency) {
//     CVGdenData.GeneralData.CurrRate = '1';
//     currencyRateExists = true;
//   } else {
//     final Database db = await initializeDB(null);
//     final List<Map<String, Object?>> ortt = await db.query('ORTT',
//         where: 'Currency = ?', whereArgs: [ocrdModel.Currency.toString()]);
//     ortt.forEach((map) {
//       DateTime rateDate = DateTime.tryParse(map['RateDate'].toString()) ??
//           DateTime.parse("1900-01-01");
//       DateTime now = DateTime.now();
//       if (rateDate.day == now.day &&
//           rateDate.month == now.month &&
//           rateDate.year == now.year) {
//         print(map['Rate'].toString());
//         CVGdenData.GeneralData.CurrRate = map['Rate'].toString();
//         currencyRateExists = true;
//       }
//     });
//   }
//
//   if (currencyRateExists) {
//     CVGdenData.GeneralData.customerCode = ocrdModel.Code;
//     CVGdenData.GeneralData.MobileNo = ocrdModel.MobileNo;
//     CVGdenData.GeneralData.customerName = ocrdModel.FirstName +
//         " " +
//         ocrdModel.MiddleName +
//         " " +
//         ocrdModel.LastName;
//     CVGdenData.GeneralData.Currency = ocrdModel.Currency;
//
//     await setContactPerson();
//     final Database db = await initializeDB(null);
//     final List<Map<String, Object?>> ortt = await db.query('ORTT',
//         where: 'Currency = ?',
//         whereArgs: [CVGdenData.GeneralData.Currency.toString()]);
//     ortt.forEach((map) {
//       print(map['Rate'].toString());
//       CVGdenData.GeneralData.CurrRate = map['Rate'].toString();
//     });
//     List<CRD2Model> shipping = await retrieveCRD2ById(
//         null, "Code = ?", [CVGdenData.GeneralData.customerCode]);
//     if (shipping.isNotEmpty) {
//       CVGdenData.GeneralData.Latitude = shipping[0].Latitude;
//       CVGdenData.GeneralData.Longitude = shipping[0].Longitude;
//       CVGdenData.GeneralData.meetinglocation =
//           '${shipping[0].Address} ${shipping[0].CityName} ${shipping[0].CountryCode} ';
//     }
//     Get.back();
//     Get.back();
//
//     Get.to(() => CustomerVisit(0));
//   } else {
//     getErrorSnackBar("Enter exchange rate in ORTT");
//   }
// }
//
// setContactPerson() async {
//   List<OCRDModel> contactPerson = await retrieveOCRDById(null,
//       "Code = ? AND Active = ?", [CVGdenData.GeneralData.customerCode, 1]);
//   if (contactPerson.isNotEmpty) {
//     CVGdenData.GeneralData.ContactPersonID = contactPerson[0].ID.toString();
//     CVGdenData.GeneralData.MobileNo = contactPerson[0].MobileNo.toString();
//     CVGdenData.GeneralData.ContactPerson =
//         contactPerson[0].FirstName.toString() +
//             " " +
//             contactPerson[0].MiddleName.toString() +
//             " " +
//             contactPerson[0].LastName.toString();
//   }
// }
//
// class CustomMap extends StatefulWidget {
//   bool displayAppBar;
//
//   CustomMap({Key? key, required this.displayAppBar}) : super(key: key);
//
//   @override
//   State<CustomMap> createState() => _CustomMapState();
// }
//
// class _CustomMapState extends State<CustomMap> {
//   final key = GlobalKey<ScaffoldState>();
//   List<OCRDModel> ocrdList = [];
//
//   GoogleMapController? mapController;
//   PolylinePoints polylinePoints = PolylinePoints();
//
//   Set<Marker> markers = Set();
//   Map<PolylineId, Polyline> polyLines = {};
//   Set<Polyline> multiplePolyLines = {};
//   CameraPosition? cameraPosition;
//
//   LatLng startCoordinate = LatLng(17.877964, 74.853112);
//   LatLng endCoordinate = LatLng(32.127939, 75.970825);
//   List<LatLng> routeCoordinates = [];
//   List<LatLng> otherCoordinates = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _plotSelectedRoute();
//   }
//
//   _plotSelectedRoute() async {
//     List<ROUTModel> routeList =
//         await retrieveROUTById(null, 'RouteCode = ?', [GeneralData.RouteCode]);
//     if (routeList.isNotEmpty) {
//       startCoordinate = LatLng(
//           double.tryParse(routeList[0].Latitude) ?? 27.6688422,
//           double.tryParse(routeList[0].Longitude) ?? 85.3077330);
//       cameraPosition = CameraPosition(
//         target: startCoordinate,
//         zoom: 16.0, //initial zoom level
//       );
//
//       endCoordinate = LatLng(
//           double.tryParse(routeList[0].TLatitude) ?? 27.6688422,
//           double.tryParse(routeList[0].TLongitude) ?? 85.3077330);
//     }
//     _addRouteMarkers();
//   }
//
//   Future<void> _addRouteMarkers() async {
//     markers.add(Marker(
//       markerId: MarkerId('start'),
//       position: startCoordinate,
//       infoWindow: InfoWindow(title: 'Start'),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//     ));
//     //TODO: IMPLEMENT CUSTOMER WIDGET MARKER WATCH https://www.youtube.com/watch?v=MrnA6vpTXik
//
//     // Text('Hello guys',key: key,);
//     // RenderRepaintBoundary boundary=key
//     //     .currentContext?.findRenderObject()
//     // as RenderRepaintBoundary;
//     // ui.Image image=await boundary.toImage();
//     // ByteData? byteData=await image.toByteData(
//     //   format: ui.ImageByteFormat.png,
//     // );
//     //
//     // markers.add(Marker(
//     //   markerId: MarkerId('end'),
//     //   position: endCoordinate,
//     //   infoWindow: InfoWindow(title: 'End'),
//     //   icon: BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List()),
//     // ));
//
//     markers.add(Marker(
//       markerId: MarkerId('end'),
//       position: endCoordinate,
//       infoWindow: InfoWindow(title: 'End'),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//     ));
//
//     List<CRD2Model> list = await retrieveMapDataForVisitPlan();
//     print(list);
//     if (list.isNotEmpty) {
//       for (CRD2Model crd2model in list) {
//         LatLng docLocation = LatLng(
//             double.tryParse(crd2model.Latitude ?? '') ?? 0.0,
//             double.tryParse(crd2model.Longitude ?? '') ?? 0.0);
//         markers.add(Marker(
//           markerId: MarkerId(crd2model.ID.toString()),
//           position: docLocation,
//           infoWindow: InfoWindow(
//             title: '${crd2model.Code} ${crd2model.Name}',
//             snippet: "Create Customer Visit",
//             onTap: () async {
//               await clearCustomerVisitData();
//               getLastDocNum("AT", context).then((snapshot) async {
//                 int DocNum = snapshot[0].DocNumber - 1;
//                 do {
//                   DocNum += 1;
//
//                   CVGdenData.GeneralData.TransId =
//                       DateTime.now().millisecondsSinceEpoch.toString() +
//                           "U0" +
//                           userModel.ID.toString() +
//                           "_" +
//                           snapshot[0].DocName +
//                           "/" +
//                           DocNum.toString();
//                 } while (await isATTransIdAvailable(
//                     context, CVGdenData.GeneralData.TransId ?? ""));
//
//                 Map<String, dynamic> val = {"DocNumber": DocNum};
//                 updateDocNum(snapshot[0].ID, val, context);
//                 CVGdenData.GeneralData.isSelected = false;
//                 CVGdenData.GeneralData.isComingFromVPMap = true;
//                 CVGdenData.GeneralData.BaseTransId = GeneralData.TransId;
//                 CustomerVisit.saveButtonPesses = false;
//                 onCVCustomerSelection(Code: crd2model.Code);
//               });
//             },
//           ),
//           icon:
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//         ));
//       }
//     }
//     VisitList.planList.forEach((plan) {
//       if (plan.Latitude != 0.0 && plan.Longitude != 0.0) {
//         LatLng docLocation = LatLng(double.tryParse(plan.Latitude ?? '') ?? 0.0,
//             double.tryParse(plan.Longitude ?? '') ?? 0.0);
//         otherCoordinates.add(docLocation);
//         print("Trans ID = ${plan.ATTransId}");
//         markers.add(Marker(
//           markerId: MarkerId(docLocation.toString()),
//           position: docLocation,
//           infoWindow: InfoWindow(
//             title: plan.ATTransId,
//             // snippet: "Doc Total : \u{20b9}",
//             onTap: () {
//               // navigateToInvoice(routePlan.TransId);
//             },
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ));
//       }
//     });
//
//     // otherCoordinates.forEach((coordinate) {
//     //   markers.add(Marker(
//     //     markerId: MarkerId(coordinate.toString()),
//     //     position: coordinate,
//     //     infoWindow: InfoWindow(title: 'Other Coordinate'),
//     //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//     //   ));
//     // });
//     _getRoutePolylines();
//   }
//
//   Future<void> _getRoutePolylines() async {
//     String apiUrl = 'https://maps.googleapis.com/maps/api/directions/json?' +
//         'origin=${startCoordinate.latitude},${startCoordinate.longitude}&' +
//         'destination=${endCoordinate.latitude},${endCoordinate.longitude}&' +
//         'waypoints=${otherCoordinates.map((point) => "via:${point.latitude},${point.longitude}").join("|")}&' +
//         'key=$googleAPiKey'; // Replace YOUR_API_KEY with your Google Maps API key
//
//     final response = await http.get(Uri.parse(apiUrl));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       List<LatLng> decodedPoints =
//           _decodePoly(data['routes'][0]['overview_polyline']['points']);
//       routeCoordinates = decodedPoints;
//       _addSuggestedRoutePolylines();
//     } else {
//       throw Exception('Failed to load polyline data');
//     }
//   }
//
//   void _addSuggestedRoutePolylines() {
//     List<LatLng> polylineCoordinates = [startCoordinate];
//     polylineCoordinates.addAll(routeCoordinates);
//     polylineCoordinates.add(endCoordinate);
//     multiplePolyLines.add(Polyline(
//       polylineId: PolylineId('Suggested Route'),
//       points: polylineCoordinates,
//       color: Colors.blue,
//       width: 5,
//     ));
//     _addActualRoutePolylines();
//   }
//
//   _addActualRoutePolylines() async {
//     List<LatLng> decodedPoints = [];
//     String apiUrl = 'https://maps.googleapis.com/maps/api/directions/json?' +
//         'origin=${startCoordinate.latitude},${startCoordinate.longitude}&' +
//         'destination=${endCoordinate.latitude},${endCoordinate.longitude}&' +
//         'key=$googleAPiKey';
//
//     final response = await http.get(Uri.parse(apiUrl));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       decodedPoints =
//           _decodePoly(data['routes'][0]['overview_polyline']['points']);
//     } else {
//       throw Exception('Failed to load polyline data');
//     }
//     List<LatLng> polylineCoordinates = [startCoordinate];
//     polylineCoordinates.addAll(decodedPoints);
//     polylineCoordinates.add(endCoordinate);
//     // markers.forEach((marker) {
//     //   mapController?.showMarkerInfoWindow(marker.markerId);
//     // });
//
//     setState(() {
//       multiplePolyLines.add(Polyline(
//         polylineId: PolylineId('Actual Route'),
//         points: polylineCoordinates,
//         color: Colors.orange,
//         width: 5,
//       ));
//     });
//   }
//
//   List<LatLng> _decodePoly(String encoded) {
//     List<LatLng> points = [];
//     int index = 0;
//     int len = encoded.length;
//     int lat = 0;
//     int lng = 0;
//
//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lat += dlat;
//
//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lng += dlng;
//
//       double latDouble = lat / 1E5;
//       double lngDouble = lng / 1E5;
//       LatLng position = LatLng(latDouble, lngDouble);
//       points.add(position);
//     }
//     return points;
//   }
//
//   // _plotSuggestedCustomer() async {
//   //   List<CRD2Model> list = await retrieveMapDataForVisitPlan();
//   //   print(list);
//   //   if (list.isNotEmpty) {
//   //     for (CRD2Model crd2model in list) {
//   //       LatLng docLocation = LatLng(
//   //           double.tryParse(crd2model.Latitude ?? '') ?? 0.0,
//   //           double.tryParse(crd2model.Longitude ?? '') ?? 0.0);
//   //       markers.add(Marker(
//   //         markerId: MarkerId(crd2model.ID.toString()),
//   //         position: docLocation,
//   //         infoWindow: InfoWindow(
//   //           title: '${crd2model.Code} ${crd2model.Name}',
//   //           snippet: "Create Customer Visit",
//   //           onTap: () async {
//   //             await clearCustomerVisitData();
//   //             getLastDocNum("AT", context).then((snapshot) async {
//   //               int DocNum = snapshot[0].DocNumber - 1;
//   //               do {
//   //                 DocNum += 1;
//   //
//   //                 CVGdenData.GeneralData.TransId =
//   //                     DateTime.now().millisecondsSinceEpoch.toString() +
//   //                         "U0" +
//   //                         userModel.ID.toString() +
//   //                         "_" +
//   //                         snapshot[0].DocName +
//   //                         "/" +
//   //                         DocNum.toString();
//   //               } while (await isATTransIdAvailable(
//   //                   context, CVGdenData.GeneralData.TransId ?? ""));
//   //
//   //               Map<String, dynamic> val = {"DocNumber": DocNum};
//   //               updateDocNum(snapshot[0].ID, val, context);
//   //               CVGdenData.GeneralData.isSelected = false;
//   //               CVGdenData.GeneralData.isComingFromVPMap = true;
//   //               CVGdenData.GeneralData.BaseTransId = GeneralData.TransId;
//   //               CustomerVisit.saveButtonPesses = false;
//   //               onActivityCustomerSelection(Code: crd2model.Code);
//   //             });
//   //           },
//   //         ),
//   //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//   //       ));
//   //     }
//   //   }
//   //   _plotPlanMap();
//   // }
//
//   // _plotPlanMap() async {
//   //   if (VisitList.planList.isNotEmpty && GeneralData.TransId != null) {
//   //     print(VisitList.planList);
//   //     VisitList.planList.forEach((plan) {
//   //       if (plan.Latitude != 0.0 && plan.Longitude != 0.0) {
//   //         LatLng docLocation = LatLng(
//   //             double.tryParse(plan.Latitude ?? '') ?? 0.0,
//   //             double.tryParse(plan.Longitude ?? '') ?? 0.0);
//   //         print("Trans ID = ${plan.ATTransId}");
//   //         markers.add(Marker(
//   //           markerId: MarkerId(docLocation.toString()),
//   //           position: docLocation,
//   //           infoWindow: InfoWindow(
//   //             title: plan.ATTransId,
//   //             // snippet: "Doc Total : \u{20b9}",
//   //             onTap: () {
//   //               // navigateToInvoice(routePlan.TransId);
//   //             },
//   //           ),
//   //           icon:
//   //               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//   //         ));
//   //       }
//   //     });
//   //   }
//   //   List<OECLOModel> userTrack =
//   //       await retrieveOECLOById(context, 'UserCode = ?', [userModel.UserCode]);
//   //   List<LatLng> coordinates = [];
//   //   for (OECLOModel oecloModel in userTrack) {
//   //     if (oecloModel.Latitude != 0.0) {
//   //       coordinates.add(LatLng(
//   //           double.tryParse(oecloModel.Latitude ?? '') ?? 0.0,
//   //           double.tryParse(oecloModel.Longitude ?? '') ?? 0.0));
//   //     }
//   //   }
//   //   if (coordinates.isNotEmpty) {
//   //     multiplePolyLines.add(Polyline(
//   //       polylineId: PolylineId('route'),
//   //       points: coordinates,
//   //       color: Colors.blue,
//   //       width: 5,
//   //     ));
//   //   }
//   //   _getData();
//   // }
//
//   // _getData() async {
//   //   if (VisitList.planList.isNotEmpty && GeneralData.TransId != null) {
//   //     // ocrdList = await retrieveOCRDForVisitPlanMap(TransId: GeneralData.TransId!);
//   //     ocrdList = await retrieveOCRDForVisitPlanMap();
//   //     if (ocrdList.isNotEmpty && ocrdList.length > 1) {
//   //       if (startLocation == null) {
//   //         startLocation = LatLng(
//   //             double.tryParse(ocrdList[0].Latitude) ?? 27.6688422,
//   //             double.tryParse(ocrdList[0].Longitude) ?? 85.3077330);
//   //         cameraPosition = CameraPosition(
//   //           //innital position in map
//   //           target: startLocation ?? LatLng(27.6688422, 85.3077330),
//   //           //initial position
//   //           zoom: 16.0, //initial zoom level
//   //         );
//   //
//   //         endLocation = LatLng(
//   //             double.tryParse(ocrdList[1].Latitude) ?? 27.6688422,
//   //             double.tryParse(ocrdList[1].Longitude) ?? 85.3077330);
//   //       }
//   //       addMarkers();
//   //     }
//   //   }
//   // }
//
//   // addMarkers() async {
//   //   ocrdList.forEach((ocrd) {
//   //     if (ocrd.Latitude != 0.0 && ocrd.Longitude != 0.0) {
//   //       LatLng docLocation = LatLng(double.tryParse(ocrd.Latitude) ?? 0.0,
//   //           double.tryParse(ocrd.Longitude) ?? 0.0);
//   //       print("Trans ID = ${ocrd.ATTransId}");
//   //       markers.add(Marker(
//   //         markerId: MarkerId(docLocation.toString()),
//   //         position: docLocation,
//   //         //position of marker
//   //         // visible: true,
//   //         infoWindow: InfoWindow(
//   //           title: ocrd.ATTransId,
//   //           // snippet: "Doc Total : \u{20b9}",
//   //           onTap: () {
//   //             // navigateToInvoice(routePlan.TransId);
//   //           },
//   //         ),
//   //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//   //       ));
//   //     }
//   //   });
//   //   await getDirections(index: 0);
//   //   setState(() {});
//   // }
//
//   // getDirections({required int index}) async {
//   //   if (index + 1 == ocrdList.length) {
//   //     return;
//   //   }
//   //
//   //   startLocation = LatLng(
//   //       double.tryParse(ocrdList[index].Latitude) ?? 27.6688422,
//   //       double.tryParse(ocrdList[index].Longitude) ?? 85.3077330);
//   //   endLocation = LatLng(
//   //       double.tryParse(ocrdList[index + 1].Latitude) ?? 27.6688422,
//   //       double.tryParse(ocrdList[index + 1].Longitude) ?? 85.3077330);
//   //
//   //   List<LatLng> polylineCoordinates = [];
//   //   if (startLocation == null || endLocation == null) return;
//   //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//   //       googleAPiKey,
//   //       PointLatLng(startLocation!.latitude, startLocation!.longitude),
//   //       PointLatLng(endLocation!.latitude, endLocation!.longitude),
//   //       travelMode: TravelMode.driving,
//   //       wayPoints: [PolylineWayPoint(location: "48.657421,-122.917412")]);
//   //   if (result.points.isNotEmpty) {
//   //     result.points.forEach((PointLatLng point) {
//   //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//   //     });
//   //     addPolyLine(polylineCoordinates);
//   //   } else {
//   //     print(result.errorMessage);
//   //   }
//   //   return getDirections(index: index + 1);
//   // }
//
//   // addPolyLine(List<LatLng> polylineCoordinates, {Color? color}) {
//   //   Random random = new Random();
//   //   int randomNumber = random.nextInt(1000);
//   //   print(randomNumber.toString());
//   //
//   //   PolylineId id = PolylineId(randomNumber.toString());
//   //   Polyline polyline = Polyline(
//   //     polylineId: id,
//   //     visible: true,
//   //     color: color == null ? Colors.deepPurpleAccent : color,
//   //     points: polylineCoordinates,
//   //     width: 4,
//   //   );
//   //   polyLines[id] = polyline;
//   //   multiplePolyLines.add(polyline);
//   // }
//
//   void _zoomIn() {
//     mapController?.animateCamera(CameraUpdate.zoomIn());
//   }
//
//   void _zoomOut() {
//     mapController?.animateCamera(CameraUpdate.zoomOut());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: key,
//       backgroundColor: backColor,
//       appBar: widget.displayAppBar
//           ? AppBar(
//               backgroundColor: barColor,
//               title: Text(
//                 "Map",
//                 style: TextStyle(color: headColor, fontFamily: custom_font),
//               ),
//             )
//           : null,
//       body: Stack(
//         children: [
//           GoogleMap(
//             //Map widget from google_maps_flutter package
//             zoomGesturesEnabled: false,
//             mapToolbarEnabled: false,
//             // myLocationEnabled: true,
//             zoomControlsEnabled: false,
//
//             //enable Zoom in, out on map
//             initialCameraPosition: cameraPosition ??
//                 CameraPosition(
//                   target: startCoordinate,
//                   zoom: 16.0,
//                 ),
//
//             markers: markers,
//             polylines: multiplePolyLines,
//             mapType: MapType.normal,
//             // myLocationButtonEnabled: true,
//             onMapCreated: (controller) {
//               //method called when map is created
//               mapController = controller;
//               mapController
//                   ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//                 //innital position in map
//                 target: startCoordinate,
//                 //initial position
//                 zoom: 16.0, //initial zoom level
//               )));
//
//               setState(() {});
//             },
//           ),
//           Positioned(
//             top: 16,
//             right: 16,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 40,
//                   width: 50,
//                   child: Material(
//                     borderRadius: BorderRadius.circular(10.0),
//                     color: barColor,
//                     elevation: 0.0,
//                     child: MaterialButton(
//                       onPressed: _zoomIn,
//                       child: Icon(
//                         MdiIcons.plus,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                   height: 40,
//                   width: 50,
//                   child: Material(
//                     borderRadius: BorderRadius.circular(10.0),
//                     color: barColor,
//                     elevation: 0.0,
//                     child: MaterialButton(
//                       onPressed: _zoomOut,
//                       child: Icon(
//                         MdiIcons.minus,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
