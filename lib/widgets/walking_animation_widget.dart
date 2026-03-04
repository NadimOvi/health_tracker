// lib/widgets/walking_animation_widget.dart

import 'package:flutter/material.dart';

class WalkingAnimationWidget extends StatefulWidget {
  final bool isWalking;
  final double size;

  const WalkingAnimationWidget({
    super.key,
    required this.isWalking,
    this.size = 160,
  });

  @override
  State<WalkingAnimationWidget> createState() => _WalkingAnimationWidgetState();
}

class _WalkingAnimationWidgetState extends State<WalkingAnimationWidget>
    with SingleTickerProviderStateMixin {
  static const int _totalFrames = 39;
  static const double _fps = 24.0;

  late AnimationController _controller;
  int _currentFrame = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_totalFrames / _fps * 1000).round()),
    );

    _controller.addListener(() {
      final frame = (_controller.value * _totalFrames).floor() % _totalFrames;
      if (frame != _currentFrame) {
        setState(() => _currentFrame = frame);
      }
    });

    if (widget.isWalking) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(WalkingAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isWalking && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isWalking && _controller.isAnimating) {
      _controller.stop();
      setState(() => _currentFrame = 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _framePath =>
      'assets/walking/frame_${_currentFrame.toString().padLeft(4, '0')}.png';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.6,
      child: Image.asset(
        _framePath,
        fit: BoxFit.contain,
        key: ValueKey(_currentFrame),
      ),
    );
  }
}
