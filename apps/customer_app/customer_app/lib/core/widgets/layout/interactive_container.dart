import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_motion.dart';

class InteractiveContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final bool enableFeedback;

  const InteractiveContainer({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.98,
    this.enableFeedback = true,
  });

  @override
  State<InteractiveContainer> createState() => _InteractiveContainerState();
}

class _InteractiveContainerState extends State<InteractiveContainer> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = false);
    if (widget.enableFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onTap!();
  }

  void _handleTapCancel() {
    if (widget.onTap == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleDown : 1.0,
        duration: AppMotion.micro,
        curve: AppMotion.standard,
        child: widget.child,
      ),
    );
  }
}
