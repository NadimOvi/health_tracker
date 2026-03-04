// lib/screens/home_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../widgets/walking_character.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (ctx, hp, _) {
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // ── Header ──────────────────────────────────────────
                        Text(
                          'DAILY GOAL',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: const Color(0xFF8A7F72),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${hp.dailyGoalPercent}',
                              style: GoogleFonts.dmSans(
                                fontSize: 72,
                                fontWeight: FontWeight.w900,
                                height: 1,
                                color: const Color(0xFF1C1610),
                              ),
                            ),
                            Text(
                              '%',
                              style: GoogleFonts.dmSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8A7F72),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ── Main section: stats + character + rings ──────────
                        SizedBox(
                          height: 380,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Concentric arc rings (bottom)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: _ArcRings(hp: hp),
                              ),
                              // Walking character (center)
                              Positioned(
                                top: 0,
                                right: 20,
                                child: GestureDetector(
                                  onTap: hp.toggleWalking,
                                  child: WalkingCharacter(
                                    isWalking: hp.isWalking,
                                    height: 300,
                                  ),
                                ),
                              ),
                              // Stats column (left)
                              Positioned(
                                left: 0,
                                top: 60,
                                child: _StatsList(hp: hp),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Tip card ─────────────────────────────────────────
                        _TipCard(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Arc Rings ────────────────────────────────────────────────────────────────

class _ArcRings extends StatelessWidget {
  final HealthProvider hp;
  const _ArcRings({required this.hp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: CustomPaint(
        painter: _ArcRingsPainter(
          caloriesProgress: hp.caloriesProgress,
          stepsProgress: hp.stepsProgress,
          sleepProgress: hp.sleepProgress,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ArcRingsPainter extends CustomPainter {
  final double caloriesProgress;
  final double stepsProgress;
  final double sleepProgress;

  _ArcRingsPainter({
    required this.caloriesProgress,
    required this.stepsProgress,
    required this.sleepProgress,
  });

  void _drawArc(
    Canvas canvas,
    Rect rect,
    Color trackColor,
    Color progressColor,
    double progress,
  ) {
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    final progPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Draw from -160° to -20° (bottom arc, 140° span)
    const startAngle = math.pi * 0.9;
    const sweepAngle = math.pi * 1.2;

    canvas.drawArc(rect, startAngle, sweepAngle, false, trackPaint);
    canvas.drawArc(rect, startAngle, sweepAngle * progress, false, progPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2 + 30; // shift right to be under character
    final cy = size.height + 20;
    final radii = [size.height * 0.85, size.height * 0.65, size.height * 0.45];

    final configs = [
      (const Color(0xFFFFDDD5), const Color(0xFFFF6B35), caloriesProgress),
      (const Color(0xFFDDD5FF), const Color(0xFF7C4FFF), stepsProgress),
      (const Color(0xFFCCF0FF), const Color(0xFF00BFFF), sleepProgress),
    ];

    for (int i = 0; i < 3; i++) {
      final r = radii[i];
      final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
      _drawArc(canvas, rect, configs[i].$1, configs[i].$2, configs[i].$3);
    }
  }

  @override
  bool shouldRepaint(_ArcRingsPainter old) => true;
}

// ── Stats List ───────────────────────────────────────────────────────────────

class _StatsList extends StatelessWidget {
  final HealthProvider hp;
  const _StatsList({required this.hp});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatRow(
          emoji: '🔥',
          color: const Color(0xFFFF6B35),
          value: hp.calories.toInt().toString(),
          label: 'Calories',
        ),
        const SizedBox(height: 20),
        _StatRow(
          emoji: '👟',
          color: const Color(0xFF7C4FFF),
          value: '${(hp.steps / 1000).toStringAsFixed(1)}k',
          label: 'steps',
        ),
        const SizedBox(height: 20),
        _StatRow(
          emoji: '🌙',
          color: const Color(0xFF00BFFF),
          value: hp.sleepHours.toString(),
          label: 'hours',
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String emoji;
  final Color color;
  final String value;
  final String label;

  const _StatRow({
    required this.emoji,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1C1610),
                height: 1,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: const Color(0xFFB0A898),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Tip Card ─────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD8C8), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4D6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('🍕', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A Simple way to stay healthy',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1C1610),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'DR Melissa',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: const Color(0xFFB0A898),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.bookmark_border_rounded,
            color: Color(0xFFE84040),
            size: 20,
          ),
        ],
      ),
    );
  }
}
