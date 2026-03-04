// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../widgets/walking_character.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (ctx, hp, _) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // ── Header ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROFILE',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: const Color(0xFF8A7F72),
                        ),
                      ),
                      const Icon(
                        Icons.settings_outlined,
                        color: Color(0xFF8A7F72),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ── Name ───────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NJ',
                            style: GoogleFonts.dmSans(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              height: 1,
                              color: const Color(0xFF1C1610),
                            ),
                          ),
                          Text(
                            '23 years old',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: const Color(0xFF8A7F72),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Character (upper body / waist crop) ───────────────────
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Soft beige blob behind character
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEE5D8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Character — show only top portion
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.62,
                        child: WalkingCharacter(isWalking: false, height: 300),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Daily Goals ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily goals',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8A7F72),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _GoalBar(
                        label: 'Calories',
                        emoji: '🔥',
                        color: const Color(0xFFFF6B35),
                        value: hp.calories.toInt(),
                        max: hp.calorieGoal.toInt(),
                        progress: hp.caloriesProgress,
                      ),
                      const SizedBox(height: 10),
                      _GoalBar(
                        label: 'Steps',
                        emoji: '👟',
                        color: const Color(0xFF7C4FFF),
                        value: hp.steps,
                        max: hp.stepGoal,
                        progress: hp.stepsProgress,
                      ),
                      const SizedBox(height: 10),
                      _GoalBar(
                        label: 'Sleep',
                        emoji: '🌙',
                        color: const Color(0xFF00BFFF),
                        value: hp.sleepHours.toInt(),
                        max: hp.sleepGoal.toInt(),
                        progress: hp.sleepProgress,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GoalBar extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final int value;
  final int max;
  final double progress;

  const _GoalBar({
    required this.label,
    required this.emoji,
    required this.color,
    required this.value,
    required this.max,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$value / $max',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
