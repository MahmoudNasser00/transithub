import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'location_service.dart';

class MapScreen extends StatefulWidget {
  final String startLocation;
  final String endLocation;

  const MapScreen({
    required this.startLocation,
    required this.endLocation,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _startLatLng;
  LatLng? _endLatLng;
  List<LatLng> _routePoints = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeLocations();
  }

  void _initializeLocations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _startLatLng = await getLatLng(widget.startLocation);
      _endLatLng = await getLatLng(widget.endLocation);
      setState(() {
        _startLatLng;
        _endLatLng;
      });
      if (_startLatLng != null && _endLatLng != null) {
        await _calculateRoute();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize locations: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _calculateRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_startLatLng != null && _endLatLng != null) {
        final routePoints = await getRoute(_startLatLng!, _endLatLng!);
        setState(() {
          _routePoints = routePoints;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to calculate route: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_startLatLng != null && _endLatLng != null)
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _startLatLng!,
                initialZoom: 10.0,
                minZoom: 5,
                maxZoom: 100,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    if (_startLatLng != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _startLatLng!,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                      ),
                    if (_endLatLng != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _endLatLng!,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        if (_isLoading) const CircularProgressIndicator(),
        if (_errorMessage != null)
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
