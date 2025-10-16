import 'package:flutter/foundation.dart';
import '../../../core/models/oxyfeeder_status.dart';

class DashboardViewModel extends ChangeNotifier {
  OxyFeederStatus _status = const OxyFeederStatus(
    dissolvedOxygen: 7.5,
    feedLevel: 80,
    batteryStatus: 90,
  );

  OxyFeederStatus get status => _status;

  void updateStatus(OxyFeederStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}


