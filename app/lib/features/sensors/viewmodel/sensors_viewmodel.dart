import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/oxyfeeder_status.dart';
import '../../../core/services/bluetooth_service_interface.dart';

class SensorsViewModel extends ChangeNotifier {
  final BluetoothServiceInterface _bluetoothService;
  StreamSubscription<OxyFeederStatus>? _statusSubscription;

  OxyFeederStatus _currentStatus = const OxyFeederStatus(
    dissolvedOxygen: 6.5,
    feedLevel: 75,
    batteryStatus: 88,
  );

  final List<FlSpot> _historicalDoData = <FlSpot>[
    const FlSpot(0, 6.0),
    const FlSpot(1, 6.3),
    const FlSpot(2, 5.8),
    const FlSpot(3, 6.5),
    const FlSpot(4, 7.2),
    const FlSpot(5, 7.0),
    const FlSpot(6, 6.8),
  ];

  final String _lastCalibratedDate = '2025-10-26';
  final String _feedLoadCellRawValue = '12345';
  final String _batteryVoltage = '12.8V';

  SensorsViewModel(this._bluetoothService) {
    _statusSubscription = _bluetoothService.statusStream.listen((event) {
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
    // Append new Y value
    final List<double> ys = _historicalDoData.map((e) => e.y).toList()..add(doValue);
    // Keep sliding window of last 24 values
    const int window = 24;
    if (ys.length > window) {
      ys.removeRange(0, ys.length - window);
    }
    // Reindex X consecutively so the chart spans the full width
    _historicalDoData
      ..clear()
      ..addAll(List<FlSpot>.generate(ys.length, (i) => FlSpot(i.toDouble(), ys[i])));
    notifyListeners();
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }
}


