import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/location_models.dart';
import '../../data/services/location_service.dart';

class LocationState {
  final LocationStatus status;
  final UserLocation? location;
  final String? errorMessage;

  const LocationState({
    this.status = LocationStatus.unknown,
    this.location,
    this.errorMessage,
  });

  LocationState copyWith({
    LocationStatus? status,
    UserLocation? location,
    String? errorMessage,
  }) {
    return LocationState(
      status: status ?? this.status,
      location: location ?? this.location,
      errorMessage: errorMessage,
    );
  }
}

class LocationNotifier extends Notifier<LocationState>
    with WidgetsBindingObserver {
  @override
  LocationState build() {
    final observer = _LifecycleObserver(this);
    WidgetsBinding.instance.addObserver(observer);

    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(observer);
    });

    _init();
    return const LocationState();
  }

  Future<void> _init() async {
    await checkStatus();
  }

  Future<void> checkStatus() async {
    final service = ref.read(locationServiceProvider);
    final status = await service.checkPermissionStatus();

    if (status == LocationStatus.available && state.location == null) {
      await acquireLocation();
    } else {
      state = state.copyWith(status: status);
    }
  }

  Future<void> requestPermissionAndAcquire() async {
    state = state.copyWith(status: LocationStatus.detecting);
    final service = ref.read(locationServiceProvider);

    final status = await service.requestPermission();
    if (status == LocationStatus.available) {
      await acquireLocation();
    } else {
      state = state.copyWith(status: status);
    }
  }

  Future<void> acquireLocation() async {
    state = state.copyWith(status: LocationStatus.detecting);
    final service = ref.read(locationServiceProvider);
    final location = await service.getCurrentLocation();

    if (location != null) {
      // Set location immediately for responsiveness
      state = state.copyWith(
        status: LocationStatus.available,
        location: location,
      );

      // Then fetch address in background
      final address = await service.reverseGeocode(
        location.latitude,
        location.longitude,
      );

      if (address != null) {
        state = state.copyWith(
          location: location.copyWith(addressName: address),
        );
      }
    } else {
      // Handle the case where location is null (e.g., GPS timeout)
      state = state.copyWith(
        status: LocationStatus.error,
        errorMessage: 'Could not get your precise location. Please try again or choose manually.',
      );
    }
  }

  /// Resolve address name via reverse geocoding (non-blocking).
  Future<void> _resolveAddressName(UserLocation location) async {
    final service = ref.read(locationServiceProvider);
    final name = await service.reverseGeocode(
      location.latitude,
      location.longitude,
    );
    if (name != null && state.location != null) {
      state = state.copyWith(
        location: state.location!.copyWith(addressName: name),
      );
    }
  }

  Future<void> openSettingsForDeniedForever() async {
    final service = ref.read(locationServiceProvider);
    await service.openAppSettings();
  }

  Future<void> openSettingsForServicesDisabled() async {
    final service = ref.read(locationServiceProvider);
    await service.openLocationSettings();
  }

  // Set manual fallback location
  void setManualLocation(double lat, double lng, {String? addressName}) {
    final location = UserLocation(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      source: LocationSource.manual,
      addressName: addressName,
    );
    state = state.copyWith(
      status: LocationStatus.available,
      location: location,
    );

    // Resolve address name if not provided
    if (addressName == null) {
      _resolveAddressName(location);
    }
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  final LocationNotifier notifier;
  _LifecycleObserver(this.notifier);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check permission if user comes back from settings
      notifier.checkStatus();
    }
  }
}

final locationProvider = NotifierProvider<LocationNotifier, LocationState>(() {
  return LocationNotifier();
});
