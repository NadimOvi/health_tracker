// lib/providers/health_provider.dart
import 'package:flutter/material.dart';

class HealthProvider extends ChangeNotifier {
  bool _isWalking = true;
  int _steps = 5248;
  double _calories = 1880;
  double _sleepHours = 5.6;
  int _dailyGoalPercent = 87;

  bool get isWalking => _isWalking;
  int get steps => _steps;
  double get calories => _calories;
  double get sleepHours => _sleepHours;
  int get dailyGoalPercent => _dailyGoalPercent;

  // Goal targets
  int get stepGoal => 10000;
  double get calorieGoal => 2500;
  double get sleepGoal => 8.0;

  double get stepsProgress => (_steps / stepGoal).clamp(0.0, 1.0);
  double get caloriesProgress => (_calories / calorieGoal).clamp(0.0, 1.0);
  double get sleepProgress => (_sleepHours / sleepGoal).clamp(0.0, 1.0);

  void toggleWalking() {
    _isWalking = !_isWalking;
    notifyListeners();
  }

  void addSteps(int s) {
    _steps += s;
    _dailyGoalPercent = ((_steps / stepGoal) * 100).round().clamp(0, 100);
    notifyListeners();
  }
}
