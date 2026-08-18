import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus { online, offline }

class NetworkStatusNotifier extends Notifier<NetworkStatus> {
  Timer? _offlineTimer;

  @override
  NetworkStatus build() {
    return NetworkStatus.online;
  }

  void markOffline() {
    if (state != NetworkStatus.offline) {
      state = NetworkStatus.offline;
    }
    _resetOfflineTimer();
  }

  void markOnline() {
    if (state != NetworkStatus.online) {
      state = NetworkStatus.online;
    }
    _offlineTimer?.cancel();
  }

  void _resetOfflineTimer() {
    _offlineTimer?.cancel();
    // Auto-recover to online after 30 seconds to allow new attempts to clear the banner
    _offlineTimer = Timer(const Duration(seconds: 30), () {
      if (state == NetworkStatus.offline) {
        state = NetworkStatus.online;
      }
    });
  }
}

final networkStatusProvider =
    NotifierProvider<NetworkStatusNotifier, NetworkStatus>(() {
      return NetworkStatusNotifier();
    });
