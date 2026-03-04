// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../main.dart' show precacheWalkingFrames;
import '../utils/health_provider.dart';
import '../widgets/walking_animation_widget.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheWalkingFrames(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: Consumer<HealthProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            );
          }

          final today = provider.today;

          return CustomScrollView(
            slivers: [
              // ─── App Bar ───────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: const Color(0xFF6C63FF),
                flexibleSpace: FlexibleSpaceBar(
                  background: _HeroSection(
                    provider: provider,
                    steps: today.steps,
                    goalProgress: today.goalProgress,
                  ),
                ),
                title: Text(
                  'Health Tracker',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    tooltip: 'Reset today',
                    onPressed: () => provider.resetToday(),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // ─── Stats Grid ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildListDelegate([
                    StatCard(
                      label: 'Steps',
                      value: _fmt(today.steps),
                      unit: '/ 10,000 goal',
                      icon: Icons.directions_walk_rounded,
                      color: const Color(0xFF6C63FF),
                    ),
                    StatCard(
                      label: 'Distance',
                      value: today.distanceKm.toStringAsFixed(2),
                      unit: 'kilometers',
                      icon: Icons.map_rounded,
                      color: const Color(0xFF00BFA5),
                    ),
                    StatCard(
                      label: 'Calories',
                      value: _fmt(today.caloriesBurned),
                      unit: 'kcal burned',
                      icon: Icons.local_fire_department_rounded,
                      color: const Color(0xFFFF6B6B),
                    ),
                    StatCard(
                      label: 'Active Time',
                      value: '${today.activeMinutes}',
                      unit: 'minutes',
                      icon: Icons.timer_rounded,
                      color: const Color(0xFFFFA726),
                    ),
                  ]),
                ),
              ),

              // ─── Weekly Chart ──────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: WeeklyChart(data: provider.weeklyData),
                ),
              ),

              // ─── Weekly Summary ────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _WeeklySummaryCard(provider: provider),
                ),
              ),

              // ─── Add Steps Button ──────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                sliver: SliverToBoxAdapter(
                  child: _AddStepsSection(provider: provider),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _fmt(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    }
    return '$n';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Section (animated walking figure + circular progress)
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final HealthProvider provider;
  final int steps;
  final double goalProgress;

  const _HeroSection({
    required this.provider,
    required this.steps,
    required this.goalProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: walking figure + toggle
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: provider.toggleWalking,
                        child: WalkingAnimationWidget(
                          isWalking: provider.isWalking,
                          size: 110,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: provider.isWalking
                              ? Colors.white.withOpacity(0.25)
                              : Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          provider.isWalking ? '🚶 Walking' : '💤 Idle',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Right: circular step counter
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 70,
                          lineWidth: 10,
                          percent: goalProgress,
                          animation: true,
                          animationDuration: 800,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$steps',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'steps',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${(goalProgress * 100).toStringAsFixed(0)}% of daily goal',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Weekly Summary Card
// ─────────────────────────────────────────────────────────────────────────────

class _WeeklySummaryCard extends StatelessWidget {
  final HealthProvider provider;

  const _WeeklySummaryCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final avg = provider.weeklyAvgSteps.round();
    final total = provider.totalWeeklySteps;
    final daysGoalMet = provider.weeklyData
        .where((d) => d.steps >= 10000)
        .length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem(
                'Total Steps',
                _fmt(total),
                const Color(0xFF6C63FF),
                Icons.directions_walk,
              ),
              _divider(),
              _summaryItem(
                'Daily Avg',
                _fmt(avg),
                const Color(0xFF00BFA5),
                Icons.show_chart,
              ),
              _divider(),
              _summaryItem(
                'Goals Met',
                '$daysGoalMet/7',
                const Color(0xFFFFA726),
                Icons.emoji_events_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _divider() =>
      Container(height: 40, width: 1, color: Colors.grey.shade200);

  static String _fmt(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return '$n';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Steps Section
// ─────────────────────────────────────────────────────────────────────────────

class _AddStepsSection extends StatelessWidget {
  final HealthProvider provider;

  const _AddStepsSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Log Activity',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StepButton(
              label: '+500',
              steps: 500,
              color: const Color(0xFF6C63FF),
              provider: provider,
            ),
            const SizedBox(width: 10),
            _StepButton(
              label: '+1K',
              steps: 1000,
              color: const Color(0xFF00BFA5),
              provider: provider,
            ),
            const SizedBox(width: 10),
            _StepButton(
              label: '+2K',
              steps: 2000,
              color: const Color(0xFFFF6B6B),
              provider: provider,
            ),
            const SizedBox(width: 10),
            _StepButton(
              label: '+5K',
              steps: 5000,
              color: const Color(0xFFFFA726),
              provider: provider,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final String label;
  final int steps;
  final Color color;
  final HealthProvider provider;

  const _StepButton({
    required this.label,
    required this.steps,
    required this.color,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.addSteps(steps),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
