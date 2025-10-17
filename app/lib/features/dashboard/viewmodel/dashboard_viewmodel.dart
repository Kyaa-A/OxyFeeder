import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../core/models/oxyfeeder_status.dart';

class DashboardViewModel extends ChangeNotifier {
  Timer? _timer;
  OxyFeederStatus _status = const OxyFeederStatus(
    dissolvedOxygen: 7.5,
    feedLevel: 80,
    batteryStatus: 90,
  );

  DashboardViewModel() {
    _startMockDataStream();
  }

  OxyFeederStatus get status => _status;

  void updateStatus(OxyFeederStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void _startMockDataStream() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      final random = Random();
      final double dissolvedOxygen = 5.0 + random.nextDouble() * (8.5 - 5.0);
      final int feedLevel = random.nextInt(101);
      final int batteryStatus = random.nextInt(101);

      updateStatus(OxyFeederStatus(
        dissolvedOxygen: dissolvedOxygen,
        feedLevel: feedLevel,
        batteryStatus: batteryStatus,
      ));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}


