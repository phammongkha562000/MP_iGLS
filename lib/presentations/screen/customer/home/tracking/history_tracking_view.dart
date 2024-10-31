// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_routes/google_maps_routes.dart';
// import 'package:igls_new/businesses_logics/bloc/tracking/history_tracking/history_tracking_bloc.dart';
// import 'package:igls_new/presentations/widgets/app_bar_custom.dart';
// import 'package:igls_new/presentations/common/constants.dart' as constants;

// import '../../../../presentations.dart';

// class HistoryTrackingView extends StatefulWidget {
//   const HistoryTrackingView({super.key});

//   @override
//   State<HistoryTrackingView> createState() => _HistoryTrackingViewState();
// }

// class _HistoryTrackingViewState extends State<HistoryTrackingView> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   MapsRoutes route = MapsRoutes();
//   late HistoryTrackingBloc _bloc;
//   List<LatLng> latLngLst = [];
//   @override
//   void initState() {
//     _bloc = BlocProvider.of<HistoryTrackingBloc>(context);
//     _bloc.add(HistoryTrackingViewLoaded());

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarCustom(
//         title: const Text('History Tracking'), //hardcode
//       ),
//       body: BlocConsumer<HistoryTrackingBloc, HistoryTrackingState>(
//         listener: (context, state) async {
//           /* if (state is HistoryTrackingSuccess) {
//             await route.drawRoute(state.latLngLst, 'Test routes',
//                 const Color.fromRGBO(130, 78, 210, 1.0), constants.apiKeyGGMap,
//                 travelMode: TravelModes.driving);
//           } */
//         },
//         builder: (context, state) {
//           if (state is HistoryTrackingSuccess) {
//             latLngLst = state.latLngLst;
//             route.drawRoute(state.latLngLst, 'Test routes',
//                 const Color.fromRGBO(130, 78, 210, 1.0), constants.apiKeyGGMap,
//                 travelMode: TravelModes.driving);
//             return GoogleMap(
//               polylines: route.routes,
//               initialCameraPosition: CameraPosition(
//                 zoom: 10.0,
//                 target: latLngLst.first,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//               markers: {
//                 ...List.generate(
//                     latLngLst.length,
//                     (index) => Marker(
//                         markerId: MarkerId('destination$index'),
//                         position: latLngLst[index])),
//               },
//             );
//           }
//           return const ItemLoading();
//         },
//       ),
//     );
//   }
// }
