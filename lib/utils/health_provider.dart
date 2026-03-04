// lib/utils/health_provider.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_data.dart';

class HealthProvider extends ChangeNotifier {
  static const int dailyGoal = 10000;
  static const String _prefsKey = 'weekly_data';

  List<DailyHealth> _weeklyData = [];
  bool _isWalking = false;
  bool _isLoading = true;

  List<DailyHealth> get weeklyData => _weeklyData;
  bool get isWalking => _isWalking;
  bool get isLoading => _isLoading;

  DailyHealth get today =>
      _weeklyData.isNotEmpty ? _weeklyData.last : DailyHealth.fromSteps(0);

  int get totalWeeklySteps => _weeklyData.fold(0, (sum, d) => sum + d.steps);

  double get weeklyAvgSteps =>
      _weeklyData.isEmpty ? 0 : totalWeeklySteps / _weeklyData.length;

  HealthProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      _weeklyData = decoded.map((e) => DailyHealth.fromJson(e)).toList();
    } else {
      _weeklyData = _generateMockWeek();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(_weeklyData.map((e) => e.toJson()).toList()),
    );
  }

  void addSteps(int steps) {
    if (_weeklyData.isEmpty) return;
    final last = _weeklyData.last;
    _weeklyData[_weeklyData.length - 1] = DailyHealth.fromSteps(
      last.steps + steps,
      date: last.date,
    );
    _saveData();
    notifyListeners();
  }

  void toggleWalking() {
    _isWalking = !_isWalking;
    notifyListeners();
  }

  void resetToday() {
    if (_weeklyData.isEmpty) return;
    _weeklyData[_weeklyData.length - 1] = DailyHealth.fromSteps(
      0,
      date: _weeklyData.last.date,
    );
    _saveData();
    notifyListeners();
  }

  List<DailyHealth> _generateMockWeek() {
    final rng = Random();
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      final steps = i == 6
          ? 3240 // today starts with some steps
          : 4000 + rng.nextInt(8000);
      return DailyHealth.fromSteps(steps, date: day);
    });
  }
}
