import 'package:flutter/foundation.dart';
import '../../../core/models/app_settings.dart';

class SettingsViewModel extends ChangeNotifier {
  AppSettings _appSettings = AppSettings.defaults();

  // Getters
  List<FeedingSchedule> get feedingSchedules => _appSettings.feedingSchedules;
  double get minDissolvedOxygen => _appSettings.minDissolvedOxygen;
  int get lowFeedThreshold => _appSettings.lowFeedThreshold;
  int get lowBatteryThreshold => _appSettings.lowBatteryThreshold;
  bool get notificationsEnabled => _appSettings.notificationsEnabled;

  // Updaters
  void updateMinDissolvedOxygen(double value) {
    _appSettings = _appSettings.copyWith(minDissolvedOxygen: value);
    notifyListeners();
  }

  void updateLowFeedThreshold(int value) {
    _appSettings = _appSettings.copyWith(lowFeedThreshold: value);
    notifyListeners();
  }

  void updateLowBatteryThreshold(int value) {
    _appSettings = _appSettings.copyWith(lowBatteryThreshold: value);
    notifyListeners();
  }

  void updateNotificationsEnabled(bool enabled) {
    _appSettings = _appSettings.copyWith(notificationsEnabled: enabled);
    notifyListeners();
  }

  void toggleScheduleEnabled(int index, bool enabled) {
    final schedules = List<FeedingSchedule>.from(_appSettings.feedingSchedules);
    final item = schedules[index].copyWith(enabled: enabled);
    schedules[index] = item;
    _appSettings = _appSettings.copyWith(feedingSchedules: schedules);
    notifyListeners();
  }

  void addSchedule({required String timeLabel, required int durationSeconds, bool enabled = true}) {
    final schedules = List<FeedingSchedule>.from(_appSettings.feedingSchedules)
      ..add(FeedingSchedule(timeLabel: timeLabel, durationSeconds: durationSeconds, enabled: enabled));
    _appSettings = _appSettings.copyWith(feedingSchedules: schedules);
    notifyListeners();
  }

  void removeSchedule(int index) {
    final schedules = List<FeedingSchedule>.from(_appSettings.feedingSchedules)
      ..removeAt(index);
    _appSettings = _appSettings.copyWith(feedingSchedules: schedules);
    notifyListeners();
  }
}


