// lib/models/health_data.dart

class DailyHealth {
  final DateTime date;
  final int steps;
  final double distanceKm;
  final int caloriesBurned;
  final int activeMinutes;

  DailyHealth({
    required this.date,
    required this.steps,
    required this.distanceKm,
    required this.caloriesBurned,
    required this.activeMinutes,
  });

  /// Approximate: 0.762m avg stride, ~0.04 cal/step
  factory DailyHealth.fromSteps(int steps, {DateTime? date}) {
    return DailyHealth(
      date: date ?? DateTime.now(),
      steps: steps,
      distanceKm: double.parse((steps * 0.000762).toStringAsFixed(2)),
      caloriesBurned: (steps * 0.04).round(),
      activeMinutes: (steps / 100).round(),
    );
  }

  double get goalProgress => (steps / 10000).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'steps': steps,
    'distanceKm': distanceKm,
    'caloriesBurned': caloriesBurned,
    'activeMinutes': activeMinutes,
  };

  factory DailyHealth.fromJson(Map<String, dynamic> json) => DailyHealth(
    date: DateTime.parse(json['date']),
    steps: json['steps'],
    distanceKm: json['distanceKm'],
    caloriesBurned: json['caloriesBurned'],
    activeMinutes: json['activeMinutes'],
  );
}
