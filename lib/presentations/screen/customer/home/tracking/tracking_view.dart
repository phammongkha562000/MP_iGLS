// import 'dart:async';
// // import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_routes/google_maps_routes.dart';
// import 'package:geolocator/geolocator.dart';
// // import 'package:igls_new/presentations/common/constants.dart' as constants;

// class TrackingView extends StatefulWidget {
//   const TrackingView({super.key});

//   @override
//   State<TrackingView> createState() => _TrackingViewState();
// }

// class _TrackingViewState extends State<TrackingView> {
//   List<LatLng> polylineCoordinates = [];
//   Position? currentPosition;
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   List<LatLng> points = [
//     const LatLng(10.80733286025087, 106.66425778073503),
//   ];
//   DistanceCalculator distanceCalculator = DistanceCalculator();
//   String totalDistance = 'No route';

//   Future<void> getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       currentPosition = position;
//     });

//     // const LocationSettings locationSettings = LocationSettings(
//     //   accuracy: LocationAccuracy.high,
//     //   distanceFilter: 100,
//     // );
//     // StreamSubscription<Position> positionStream =
//     //     Geolocator.getPositionStream(locationSettings: locationSettings)
//     //         .listen((Position? position) {
//     //   setState(() {
//     //     currentPosition = position;
//     //     points
//     //         .add(LatLng(currentPosition!.latitude, currentPosition!.longitude));
//     //     totalDistance =
//     //         distanceCalculator.calculateRouteDistance(points, decimals: 1);
//     //     points.length > 1
//     //         ? route.drawRoute(points, 'Test routes',
//     //             const Color.fromRGBO(130, 78, 210, 1.0), constants.apiKeyGGMap,
//     //             travelMode: TravelModes.driving)
//     //         : null;
//     //     log(points.length.toString());
//     //   });
//     // });
//   }

//   @override
//   void initState() {
//     getCurrentLocation();
//     super.initState();
//   }

//   MapsRoutes route = MapsRoutes();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tracking'),
//       ),
//       body: Stack(
//         children: [
//           currentPosition == null
//               ? const Center(child: Text('Loading'))
//               : GoogleMap(
//                   polylines: route.routes,
//                   initialCameraPosition: CameraPosition(
//                     zoom: 14.0,
//                     target: LatLng(
//                         currentPosition!.latitude, currentPosition!.longitude),
//                   ),
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller.complete(controller);
//                   },
//                   markers: {
//                     const Marker(
//                       markerId: MarkerId('source'),
//                       position: LatLng(10.80733286025087, 106.66425778073503),
//                     ),
//                     Marker(
//                       markerId: const MarkerId('current'),
//                       position: LatLng(currentPosition!.latitude,
//                           currentPosition!.longitude),
//                     ),
//                   },
//                   /* initialCameraPosition: CameraPosition(
//                       target: LatLng(currentLocation!.latitude!,
//                           currentLocation!.longitude!),
//                       zoom: 14.5),
//                   markers: {
//                     const Marker(
//                         markerId: MarkerId('source'), position: sourceLocation),
//                     const Marker(
//                         markerId: MarkerId('destination'), position: destination),
//                     const Marker(
//                         markerId: MarkerId('destination1'),
//                         position: destination1),
//                   },
//                   polylines: {
//                     const Polyline(
//                         polylineId: PolylineId('route'),
//                         points: [
//                           sourceLocation,
//                           destination,
//                           destination1
//                         ] /* polylineCoordinates */,
//                         color: Colors.blue)
//                   }, */
//                 ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                   width: 200,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15.0)),
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text(totalDistance,
//                         style: const TextStyle(fontSize: 25.0)),
//                   )),
//             ),
//           )
//         ],
//       ),

//       // body: BlocConsumer<GoogleMapsBloc, GoogleMapsState>(
//       //   listener: (context, state) {
//       //   },
//       //   builder: (context, state) {
//       //     if (state is GoogleMapsSuccess) return const Text('Location');

//       //     return const CircularProgressIndicator();
//       //   },
//       // ),
//     );
//   }
// }
