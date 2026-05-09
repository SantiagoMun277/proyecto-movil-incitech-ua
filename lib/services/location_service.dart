import 'package:geolocator/geolocator.dart';

class GpsLocationResult {
  const GpsLocationResult({
    required this.success,
    required this.message,
    this.latitude,
    this.longitude,
  });

  final bool success;
  final String message;
  final double? latitude;
  final double? longitude;
}

class LocationService {
  Future<GpsLocationResult> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const GpsLocationResult(
          success: false,
          message: 'El GPS del dispositivo está apagado.',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const GpsLocationResult(
          success: false,
          message: 'El usuario negó el permiso de ubicación.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const GpsLocationResult(
          success: false,
          message:
              'El permiso fue denegado permanentemente. Debes habilitarlo desde ajustes.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return GpsLocationResult(
        success: true,
        message: 'Ubicación obtenida correctamente.',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return GpsLocationResult(
        success: false,
        message: 'No se pudo obtener la ubicación: $e',
      );
    }
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
