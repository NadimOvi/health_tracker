// lib/screens/activity_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../widgets/walking_character.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (ctx, hp, _) {
        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ACTIVITY',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: const Color(0xFF8A7F72),
                      ),
                    ),
                    Text(
                      'Today',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: const Color(0xFFE84040),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Main area: character + side stat buttons ─────────────────
              Expanded(
                child: Stack(
                  children: [
                    // Character centered/left
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 80,
                      right: 110,
                      child: GestureDetector(
                        onTap: hp.toggleWalking,
                        child: WalkingCharacter(
                          isWalking: hp.isWalking,
                          height: double.infinity,
                        ),
                      ),
                    ),

                    // Side stat buttons (right)
                    Positioned(
                      right: 16,
                      top: 40,
                      child: Column(
                        children: [
                          _SideStatButton(
                            color: const Color(0xFFFF6B35),
                            emoji: '🔥',
                            label: 'Cal',
                            value: '${hp.calories.toInt()}',
                          ),
                          const SizedBox(height: 12),
                          _SideStatButton(
                            color: const Color(0xFF7C4FFF),
                            emoji: '👟',
                            label: 'Ste',
                            value: '${(hp.steps / 1000).toStringAsFixed(1)}k',
                          ),
                          const SizedBox(height: 12),
                          _SideStatButton(
                            color: const Color(0xFF00BFFF),
                            emoji: '🌙',
                            label: 'Sle',
                            value: '${hp.sleepHours}h',
                          ),
                        ],
                      ),
                    ),

                    // Activity log card (bottom left)
                    Positioned(
                      left: 24,
                      bottom: 20,
                      right: 130,
                      child: _ActivityLogCard(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SideStatButton extends StatelessWidget {
  final Color color;
  final String emoji;
  final String label;
  final String value;

  const _SideStatButton({
    required this.color,
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityLogCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '10.42',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFFB0A898),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Morning Walk',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1C1610),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '2km in 30 mins',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFFB0A898),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.directions_walk_rounded,
            color: Color(0xFFE84040),
            size: 22,
          ),
        ],
      ),
    );
  }
}
