// import 'package:circular_menu/circular_menu.dart';
import 'dart:convert';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:igls_new/data/services/services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../../../widgets/app_bar_custom.dart';
import 'package:igls_new/presentations/common/colors.dart' as colors;
import 'package:igls_new/presentations/common/constants.dart' as constants;

import 'package:http/http.dart' as http;

class MapView extends StatefulWidget {
  const MapView(
      {super.key,
      required this.picLat,
      required this.picLon,
      required this.shpLat,
      required this.shpLon});
  final double picLat;
  final double picLon;
  final double shpLat;
  final double shpLon;
  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  double lat = 0;
  double lon = 0;
  late LatLng startPoint;
  late LatLng endPoint;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late GoogleMapController _mapController;
  @override
  void initState() {
    startPoint = LatLng(widget.picLat, widget.picLon);
    endPoint = LatLng(widget.shpLat, widget.shpLon);
    _getPolyline();
    _markers.add(Marker(
      markerId: const MarkerId('startPoint'),
      position: startPoint,
      infoWindow: const InfoWindow(
        title: 'Điểm bắt đầu',
      ),
    ));

    _markers.add(Marker(
      markerId: const MarkerId('endPoint'),
      position: endPoint,
      infoWindow: const InfoWindow(title: 'Điểm kết thúc'),
    ));
    super.initState();
  }

  Future<void> _getPolyline() async {
    String googleApiKey = constants.apiKeyGGMap; // googleApiKey
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        var points = routes[0]['overview_polyline']['points'];
        List<LatLng> polylineCoordinates = _decodePoly(points);
        _addPolyLine(polylineCoordinates);
        _moveCameraToFitMarkers();
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> _decodePoly(String poly) {
    List<LatLng> coordinates = [];
    var index = 0;
    var len = poly.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return coordinates;
  }

  void _addPolyLine(List<LatLng> coordinates) {
    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('polyline'),
        points: coordinates,
        color: colors.defaultColor,
        width: 5,
      ));
    });
  }

  void _moveCameraToFitMarkers() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(startPoint.latitude, endPoint.latitude),
        min(startPoint.longitude, endPoint.longitude),
      ),
      northeast: LatLng(
        max(startPoint.latitude, endPoint.latitude),
        max(startPoint.longitude, endPoint.longitude),
      ),
    );

    _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 200)); // 200 là độ đệm xung quanh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(title: Text('5201'.tr())),
        body: SizedBox(
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: startPoint,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
              polylines: _polylines,
            ),
          ]),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBtnDirection(
                lat: widget.picLat,
                lon: widget.picLon,
                text: '5202'.tr(),
                isPick: true),
            const SizedBox(
              width: 4,
            ),
            _buildBtnDirection(
                lat: widget.shpLat,
                lon: widget.shpLon,
                text: '5203'.tr(),
                isPick: false),
          ],
        ));
  }

  onDirectionMap({required double lat, required double lon}) {
    String url = 'google.navigation:q=$lat,$lon';
    Platform.isIOS ? MapsLauncher.launchCoordinates(lat, lon) : _launchURL(url);
  }

  Widget _buildBtnDirection(
      {required double lat,
      required double lon,
      required String text,
      bool? isPick}) {
    return ElevatedButton(
        onPressed: () async {
          String url = 'google.navigation:q=$lat,$lon';
          Platform.isIOS
              ? MapsLauncher.launchCoordinates(lat, lon)
              : _launchURL(url);
        },
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(100, 55)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: isPick ?? false
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        bottomLeft: Radius.circular(32))
                    : const BorderRadius.only(
                        topRight: Radius.circular(32),
                        bottomRight: Radius.circular(32)))),
            backgroundColor: MaterialStateProperty.all(colors.defaultColor)),
        child: Text(
          text,
          style: const TextStyle(
              color: colors.textWhite, fontWeight: FontWeight.bold),
        ));
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
