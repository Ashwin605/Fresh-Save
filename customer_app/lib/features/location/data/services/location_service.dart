import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/location_models.dart';

import 'package:dio/dio.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref.watch(dioProvider));
});

class LocationService {
  final Dio _dio;
  LocationService(this._dio);
  Future<LocationStatus> checkPermissionStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.servicesDisabled;
    }

    final permission = await Geolocator.checkPermission();
    return _mapPermission(permission);
  }

  Future<LocationStatus> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.servicesDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return _mapPermission(permission);
  }

  Future<UserLocation?> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
        source: LocationSource.gps,
      );
    } catch (e) {
      return null;
    }
  }

  /// Reverse geocode coordinates into a human-readable address name.
  /// Returns something like "Vellore, Tamil Nadu" or "Chennai, Tamil Nadu".
  Future<String?> reverseGeocode(double latitude, double longitude) async {
    try {
      // For web support, geocoding package does not work natively.
      // We will fallback to a free public API (Nominatim) for demonstration purposes.
      if (const bool.hasEnvironment('dart.library.js_util')) {
        return await _reverseGeocodeWeb(latitude, longitude);
      }

      final placemarks = await Geocoding().placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      final parts = <String>[];

      // Build a concise location name: locality/subLocality + administrativeArea
      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        parts.add(place.subLocality!);
      } else if (place.locality != null && place.locality!.isNotEmpty) {
        parts.add(place.locality!);
      }

      if (place.administrativeArea != null &&
          place.administrativeArea!.isNotEmpty) {
        // Avoid duplicating if locality == administrativeArea
        if (parts.isEmpty || parts.last != place.administrativeArea) {
          parts.add(place.administrativeArea!);
        }
      }

      if (parts.isEmpty && place.name != null && place.name!.isNotEmpty) {
        parts.add(place.name!);
      }

      return parts.isNotEmpty ? parts.join(', ') : null;
    } catch (e) {
      // If native geocoding fails (e.g. on web or missing Play Services), try web fallback
      try {
        return await _reverseGeocodeWeb(latitude, longitude);
      } catch (_) {
        return null;
      }
    }
  }

  Future<String?> _reverseGeocodeWeb(double lat, double lng) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lng,
          'zoom': 10,
          'addressdetails': 1,
        },
      );
      
      final data = response.data;
      if (data != null && data['address'] != null) {
        final address = data['address'];
        final city = address['city'] ?? address['town'] ?? address['village'] ?? address['county'];
        final state = address['state'];
        
        final parts = <String>[];
        if (city != null) parts.add(city.toString());
        if (state != null) parts.add(state.toString());
        
        if (parts.isNotEmpty) {
          return parts.join(', ');
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Forward geocode an address string into coordinates.
  Future<UserLocation?> forwardGeocode(String address) async {
    try {
      if (const bool.hasEnvironment('dart.library.js_util')) {
        return await _forwardGeocodeWeb(address);
      }

      final locations = await Geocoding().locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return UserLocation(
          latitude: loc.latitude,
          longitude: loc.longitude,
          accuracy: 0,
          timestamp: loc.timestamp ?? DateTime.now(),
          source: LocationSource.manual,
        );
      }
      return null;
    } catch (e) {
      try {
        return await _forwardGeocodeWeb(address);
      } catch (_) {
        return null;
      }
    }
  }

  Future<UserLocation?> _forwardGeocodeWeb(String address) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'format': 'json',
          'q': address,
          'limit': 1,
        },
      );
      final List data = response.data;
      if (data.isNotEmpty) {
        final first = data.first;
        return UserLocation(
          latitude: double.parse(first['lat'].toString()),
          longitude: double.parse(first['lon'].toString()),
          accuracy: 0,
          timestamp: DateTime.now(),
          source: LocationSource.manual,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<List<LocationSearchResult>> searchLocations(String query) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'format': 'json',
          'q': query,
          'limit': 5,
          'addressdetails': 1,
        },
      );
      final List data = response.data;
      return data.map((item) {
        final address = item['address'] ?? {};
        final name = item['name']?.toString() ?? '';
        final state = address['state']?.toString() ?? '';
        final country = address['country']?.toString() ?? '';
        
        final subtitleParts = <String>[];
        if (state.isNotEmpty && state != name) subtitleParts.add(state);
        if (country.isNotEmpty) subtitleParts.add(country);
        
        return LocationSearchResult(
          name: name,
          subtitle: subtitleParts.join(', '),
          latitude: double.tryParse(item['lat'].toString()) ?? 0.0,
          longitude: double.tryParse(item['lon'].toString()) ?? 0.0,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  LocationStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationStatus.available;
      case LocationPermission.denied:
        return LocationStatus.denied;
      case LocationPermission.deniedForever:
        return LocationStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationStatus.unknown;
    }
  }
}
