import 'package:flutter/foundation.dart';
import '../../../core/models/oxyfeeder_status.dart';
import '../../../core/services/mock_bluetooth_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final MockBluetoothService _mockService;
  OxyFeederStatus _status = const OxyFeederStatus(
    dissolvedOxygen: 7.5,
    feedLevel: 80,
    batteryStatus: 90,
  );

  DashboardViewModel(this._mockService) {
    _mockService.statusStream.listen((event) {
      updateStatus(event);
    });
  }

  OxyFeederStatus get status => _status;

  void updateStatus(OxyFeederStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}


