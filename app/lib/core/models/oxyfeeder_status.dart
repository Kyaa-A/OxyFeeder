class OxyFeederStatus {
  final double dissolvedOxygen; // mg/L
  final int feedLevel; // percentage 0-100
  final int batteryStatus; // percentage 0-100

  const OxyFeederStatus({
    required this.dissolvedOxygen,
    required this.feedLevel,
    required this.batteryStatus,
  });

  OxyFeederStatus copyWith({
    double? dissolvedOxygen,
    int? feedLevel,
    int? batteryStatus,
  }) {
    return OxyFeederStatus(
      dissolvedOxygen: dissolvedOxygen ?? this.dissolvedOxygen,
      feedLevel: feedLevel ?? this.feedLevel,
      batteryStatus: batteryStatus ?? this.batteryStatus,
    );
  }
}


