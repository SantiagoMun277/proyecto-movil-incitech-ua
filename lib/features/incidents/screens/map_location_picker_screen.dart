import 'package:flutter/material.dart';
import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app_incitech_ua/features/incidents/models/selected_map_location.dart';

class MapLocationPickerScreen extends StatefulWidget {
  const MapLocationPickerScreen({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  final double initialLatitude;
  final double initialLongitude;

  @override
  State<MapLocationPickerScreen> createState() => _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  late LatLng _selectedPoint;

  @override
  void initState() {
    super.initState();
    _selectedPoint = LatLng(widget.initialLatitude, widget.initialLongitude);
  }

  void _confirmLocation() {
    Navigator.pop(
      context,
      SelectedMapLocation(
        latitude: _selectedPoint.latitude,
        longitude: _selectedPoint.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontSize = w * 0.040;

    return Scaffold(
      backgroundColor: AppColors.backgroundGreen,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundGreen,
        elevation: 0,
        title: const Text(
          'Seleccionar ubicación',
          style: TextStyle(
            color: Colors.black,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _selectedPoint,
                initialZoom: 18,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedPoint = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'my_app_incitech_ua',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        size: 42,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.softWhite,
            child: Column(
              children: [
                Text(
                  'Toca el mapa para mover la ubicación.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: AppTextStyles.fontFamily,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Lat: ${_selectedPoint.latitude.toStringAsFixed(6)}\nLng: ${_selectedPoint.longitude.toStringAsFixed(6)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize * 0.95,
                    fontFamily: AppTextStyles.fontFamily,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreenAlt,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Confirmar ubicación',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),
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


