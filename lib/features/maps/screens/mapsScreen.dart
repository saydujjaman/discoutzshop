import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:latlong2/latlong.dart';

class MapLocationScreen extends StatefulWidget {
  @override
  _MapLocationScreenState createState() => _MapLocationScreenState();
}

class _MapLocationScreenState extends State<MapLocationScreen> {
  String selectedDivision = '';
  List<String> zones = ['No Area Available'];
  GeoJSONFeatureCollection? geoJsonFeatures;
  bool isGeoJsonLoaded = false;
  // Add MapController for zoom control
  final MapController mapController = MapController();

  final List<Map<String, dynamic>> divisions = [
    {'id': 'bd-da', 'name': 'Dhaka', 'value': 0},
    {'id': 'bd-sy', 'name': 'Sylhet', 'value': 1},
    {'id': 'bd-bk', 'name': 'Barisal', 'value': 2},
    {'id': 'bd-kh', 'name': 'Khulna', 'value': 3},
    {'id': 'bd-ba', 'name': 'Barisal', 'value': 4},
    {'id': 'bd-cg', 'name': 'Chittagong', 'value': 5},
    {'id': 'bd-rp', 'name': 'Rangpur', 'value': 6},
    {'id': 'bd-rj', 'name': 'Rajshahi', 'value': 7},
  ];

  final Map<String, List<String>> staticZones = {
    'Dhaka': ['Zone A', 'Zone B', 'Zone C'],
    'Sylhet': ['Zone X', 'Zone Y'],
    'Barisal': ['Zone 1', 'Zone 2', 'Zone 3'],
    'Khulna': ['Zone K1', 'Zone K2'],
    'Chittagong': ['Zone C1', 'Zone C2'],
    'Rangpur': ['Zone R1'],
    'Rajshahi': ['Zone RJ1', 'Zone RJ2'],
  };

  @override
  void initState() {
    super.initState();
    loadGeoJson();
  }

  Future<void> loadGeoJson() async {
    try {
      final geoJsonString = await DefaultAssetBundle.of(context).loadString('assets/bangladesh_divisions.geojson');
      final geoJson = GeoJSON.fromJSON(geoJsonString);
      if (geoJson is GeoJSONFeatureCollection) {
        geoJsonFeatures = geoJson;
        print('GeoJSON loaded successfully with ${geoJsonFeatures!.features.length} features');
      } else {
        throw Exception('GeoJSON is not a FeatureCollection');
      }
      setState(() {
        isGeoJsonLoaded = true;
      });
    } catch (e) {
      print('Error loading GeoJSON: $e');
      setState(() {
        isGeoJsonLoaded = true;
        zones = ['Error loading map data: $e'];
      });
    }
  }

  void updateZones(String division) {
    setState(() {
      zones = staticZones[division] ?? ['No zones available'];
    });
  }

  // Zoom in function
  void zoomIn() {
    final currentZoom = mapController.zoom;
    mapController.move(mapController.center, currentZoom + 1);
  }

  // Zoom out function
  void zoomOut() {
    final currentZoom = mapController.zoom;
    if (currentZoom > 1) { // Prevent zooming out too far
      mapController.move(mapController.center, currentZoom - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFEBEBEB)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar (commented out for now)
                /*
                Container(
                  width: 120,
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            'All of $selectedDivision',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: zones.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                zones[index],
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                */
                // Main Content
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Grab By Location',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.string(
                              '''
                              <svg xmlns="http://www.w3.org/2000/svg" width="22" height="31" viewBox="0 0 22 31" fill="none">
                                <path d="M10.263 30.2372C9.84392 29.7675 0 18.6461 0 11.0705C5.93225e-05 4.96621 4.93463 0 11.0001 0C17.0655 0 22 4.96621 22 11.0705C22 18.6461 12.1561 29.7675 11.737 30.2372C11.3432 30.6786 10.6559 30.6777 10.263 30.2372Z" fill="#F15A2D"/>
                                <path d="M21.9999 11.0705C21.9999 4.96621 17.0653 0 11 0V30.5679C11.27 30.5679 11.5402 30.4579 11.737 30.2372C12.156 29.7675 21.9999 18.6461 21.9999 11.0705Z" fill="#F15A2D"/>
                                <path d="M10.9986 16.6402C7.94694 16.6402 5.46436 14.1416 5.46436 11.0704C5.46436 7.99912 7.94706 5.50049 10.9986 5.50049C14.0502 5.50049 16.5329 7.99912 16.5329 11.0704C16.5329 14.1416 14.0502 16.6402 10.9986 16.6402Z" fill="#F9F9F9"/>
                                <path d="M11 5.50049V16.6402C14.0517 16.6402 16.5343 14.1415 16.5343 11.0703C16.5343 7.99906 14.0515 5.50049 11 5.50049Z" fill="#C5D8DF"/>
                              </svg>
                              ''',
                              width: 22,
                              height: 31,
                            ),
                          ],
                        ),
                      ),
                      // Map with Zoom Buttons
                      Expanded(
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                center: const LatLng(23.7, 90.4),
                                zoom: 10.0,
                                minZoom: 5.0,
                                maxZoom: 18.0,
                                onTap: (tapPosition, point) {
                                  if (geoJsonFeatures == null) return;
                                  for (var feature in geoJsonFeatures!.features) {
                                    final geometry = feature!.geometry as GeoJSONPolygon?;
                                    if (geometry == null) continue;
                                    final name = feature.properties!['name'] ?? '';
                                    if (divisions.any((d) => d['name'] == name)) {
                                      bool isInside = false;
                                      final points = geometry.coordinates[0].map((c) => LatLng(c[1], c[0])).toList();
                                      for (int i = 0, j = points.length - 1; i < points.length; j = i++) {
                                        if (((points[i].latitude > point.latitude) != (points[j].latitude > point.latitude)) &&
                                            (point.longitude < (points[j].longitude - points[i].longitude) * (point.latitude - points[i].latitude) / (points[j].latitude - points[i].latitude) + points[i].longitude)) {
                                          isInside = !isInside;
                                        }
                                      }
                                      if (isInside) {
                                        setState(() {
                                          selectedDivision = name;
                                        });
                                        updateZones(name);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Selected: $name')),
                                        );
                                        break;
                                      }
                                    }
                                  }
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: const ['a', 'b', 'c'],
                                ),
                                PolygonLayer(
                                  polygons: geoJsonFeatures != null
                                      ? geoJsonFeatures!.features
                                      .where((feature) => feature!.geometry != null)
                                      .map((feature) {
                                    final name = feature!.properties!['name'] ?? '';
                                    final geometry = feature.geometry as GeoJSONPolygon;
                                    return Polygon(
                                      points: geometry.coordinates[0].map((c) => LatLng(c[1], c[0])).toList(),
                                      color: selectedDivision == name
                                          ? const Color(0xFFF15A2D).withOpacity(0.8)
                                          : Colors.grey.withOpacity(0.5),
                                      isFilled: true,
                                      borderColor: Colors.black,
                                      borderStrokeWidth: 2,
                                      label: name,
                                    );
                                  })
                                      .toList()
                                      : [],
                                ),
                              ],
                            ),
                            // Zoom Buttons
                            Positioned(
                              right: 10,
                              bottom: 10,
                              child: Column(
                                children: [
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: zoomIn,
                                    child: const Icon(Icons.zoom_in),
                                  ),
                                  const SizedBox(height: 10),
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: zoomOut,
                                    child: const Icon(Icons.zoom_out),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}