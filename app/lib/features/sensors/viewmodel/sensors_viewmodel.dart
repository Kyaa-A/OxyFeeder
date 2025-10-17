import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/oxyfeeder_status.dart';
import '../../../core/services/mock_bluetooth_service.dart';

class SensorsViewModel extends ChangeNotifier {
  final MockBluetoothService _mockService;
  OxyFeederStatus _currentStatus = const OxyFeederStatus(
    dissolvedOxygen: 6.5,
    feedLevel: 75,
    batteryStatus: 88,
  );

  final List<FlSpot> _historicalDoData = <FlSpot>[
    const FlSpot(0, 6.0),
    const FlSpot(4, 6.3),
    const FlSpot(8, 5.8),
    const FlSpot(12, 6.5),
    const FlSpot(16, 7.2),
    const FlSpot(20, 7.0),
    const FlSpot(24, 6.8),
  ];

  final String _lastCalibratedDate = '2025-10-26';
  final String _feedLoadCellRawValue = '12345';
  final String _batteryVoltage = '12.8V';

  SensorsViewModel(this._mockService) {
    _mockService.statusStream.listen((event) {
      updateLiveData(event);
      addHistoricalDoData(event.dissolvedOxygen);
    });
  }

  // Getters
  OxyFeederStatus get currentStatus => _currentStatus;
  List<FlSpot> get historicalDoData => List<FlSpot>.unmodifiable(_historicalDoData);
  String get lastCalibratedDate => _lastCalibratedDate;
  String get feedLoadCellRawValue => _feedLoadCellRawValue;
  String get batteryVoltage => _batteryVoltage;

  void updateLiveData(OxyFeederStatus newStatus) {
    _currentStatus = newStatus;
    notifyListeners();
  }

  void addHistoricalDoData(double doValue) {
    // Use next X based on last point + 1 (hour) for demo purposes
    final double nextX = _historicalDoData.isEmpty ? 0 : _historicalDoData.last.x + 1;
    _historicalDoData.add(FlSpot(nextX, doValue));
    // Keep only the last 24 points
    if (_historicalDoData.length > 24) {
      _historicalDoData.removeRange(0, _historicalDoData.length - 24);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}


