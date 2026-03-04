// lib/widgets/walking_character.dart
import 'package:flutter/material.dart';

class WalkingCharacter extends StatefulWidget {
  final bool isWalking;
  final double height;

  const WalkingCharacter({
    super.key,
    required this.isWalking,
    this.height = 280,
  });

  @override
  State<WalkingCharacter> createState() => _WalkingCharacterState();
}

class _WalkingCharacterState extends State<WalkingCharacter>
    with SingleTickerProviderStateMixin {
  static const int _totalFrames = 39;
  static const double _fps = 24.0;

  late AnimationController _ctrl;
  int _frame = 0;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(
          vsync: this,
          duration: Duration(
            milliseconds: (_totalFrames / _fps * 1000).round(),
          ),
        )..addListener(() {
          final f = (_ctrl.value * _totalFrames).floor() % _totalFrames;
          if (f != _frame) setState(() => _frame = f);
        });
    if (widget.isWalking) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(WalkingCharacter old) {
    super.didUpdateWidget(old);
    if (widget.isWalking && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.isWalking && _ctrl.isAnimating) {
      _ctrl.stop();
      setState(() => _frame = 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pre-cache on first build
    for (int i = 0; i < _totalFrames; i++) {
      precacheImage(
        AssetImage('assets/walking/frame_${i.toString().padLeft(4, '0')}.png'),
        context,
      );
    }

    final path =
        'assets/walking/frame_${_frame.toString().padLeft(4, '0')}.png';
    return SizedBox(
      height: widget.height,
      child: Image.asset(path, fit: BoxFit.contain, key: ValueKey(_frame)),
    );
  }
}
