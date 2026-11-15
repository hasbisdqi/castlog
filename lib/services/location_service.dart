import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String province;
  final String city;
  final String formattedRegion;
  final String displayCoordinates;

  LocationResult({
    required this.latitude,
    required this.longitude,
    required this.province,
    required this.city,
    required this.formattedRegion,
    required this.displayCoordinates,
  });
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Request permission and acquire the current GPS position
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi (GPS) tidak aktif. Mohon aktifkan GPS perangkat Anda.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin akses lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin akses lokasi ditolak secara permanen. Mohon aktifkan izin lewat Pengaturan Aplikasi.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 12),
      ),
    );
  }

  /// Detect user location and map it to CastLog region
  Future<LocationResult> detectUserRegion() async {
    final position = await getCurrentPosition();
    final lat = position.latitude;
    final lng = position.longitude;

    String province = 'DI Yogyakarta';
    String city = 'Kota Yogyakarta';

    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final admin = place.administrativeArea ?? '';
        final subAdmin = place.subAdministrativeArea ?? place.locality ?? '';

        province = _normalizeProvince(admin, lat: lat, lng: lng);
        city = subAdmin.isNotEmpty ? subAdmin : _defaultCityForProvince(province);
      } else {
        province = _fallbackProvinceFromCoordinates(lat, lng);
        city = _defaultCityForProvince(province);
      }
    } catch (e) {
      log('Reverse geocoding error: $e, using coordinate fallback');
      province = _fallbackProvinceFromCoordinates(lat, lng);
      city = _defaultCityForProvince(province);
    }

    final formattedRegion = '$city, $province';
    final displayCoords = '${lat.toStringAsFixed(4)}°, ${lng.toStringAsFixed(4)}°';

    return LocationResult(
      latitude: lat,
      longitude: lng,
      province: province,
      city: city,
      formattedRegion: formattedRegion,
      displayCoordinates: displayCoords,
    );
  }

  String _normalizeProvince(String admin, {required double lat, required double lng}) {
    final lower = admin.toLowerCase();
    if (lower.contains('yogyakarta') || lower.contains('jogja')) {
      return 'DI Yogyakarta';
    } else if (lower.contains('jakarta')) {
      return 'DKI Jakarta';
    } else if (lower.contains('jawa barat') || lower.contains('west java')) {
      return 'Jawa Barat';
    } else if (lower.contains('jawa timur') || lower.contains('east java')) {
      return 'Jawa Timur';
    } else if (lower.contains('bali')) {
      return 'Bali';
    }
    return _fallbackProvinceFromCoordinates(lat, lng);
  }

  String _fallbackProvinceFromCoordinates(double lat, double lng) {
    // Rough bounding boxes for Indonesian regions in case offline/emulator
    if (lat >= -8.3 && lat <= -7.5 && lng >= 110.0 && lng <= 110.7) {
      return 'DI Yogyakarta';
    } else if (lat >= -6.4 && lat <= -6.0 && lng >= 106.6 && lng <= 107.0) {
      return 'DKI Jakarta';
    } else if (lat >= -7.8 && lat <= -5.9 && lng >= 106.3 && lng <= 108.8) {
      return 'Jawa Barat';
    } else if (lat >= -8.8 && lat <= -6.8 && lng >= 111.0 && lng <= 114.6) {
      return 'Jawa Timur';
    } else if (lat >= -8.9 && lat <= -8.0 && lng >= 114.4 && lng <= 115.7) {
      return 'Bali';
    }
    // Default regional community center
    return 'DI Yogyakarta';
  }

  String _defaultCityForProvince(String province) {
    switch (province) {
      case 'DI Yogyakarta':
        return 'Kota Yogyakarta';
      case 'DKI Jakarta':
        return 'Jakarta Selatan';
      case 'Jawa Barat':
        return 'Bandung';
      case 'Jawa Timur':
        return 'Surabaya';
      case 'Bali':
        return 'Denpasar';
      default:
        return 'Kota Yogyakarta';
    }
  }
}
