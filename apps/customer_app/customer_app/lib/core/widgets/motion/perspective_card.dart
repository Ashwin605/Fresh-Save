import 'package:flutter/material.dart';

class PerspectiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const PerspectiveCard({super.key, required this.child, this.onTap});

  @override
  State<PerspectiveCard> createState() => _PerspectiveCardState();
}

class _PerspectiveCardState extends State<PerspectiveCard> {
  double _xRotation = 0;
  double _yRotation = 0;
  bool _isPressed = false;

  void _updateRotation(Offset localPosition, Size size) {
    setState(() {
      // Rotate maximally by 0.05 radians
      _yRotation = ((localPosition.dx - size.width / 2) / size.width) * 0.1;
      _xRotation = ((size.height / 2 - localPosition.dy) / size.height) * 0.1;
      _isPressed = true;
    });
  }

  void _resetRotation() {
    setState(() {
      _xRotation = 0;
      _yRotation = 0;
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        _updateRotation(details.localPosition, renderBox.size);
      },
      onPanUpdate: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        _updateRotation(details.localPosition, renderBox.size);
      },
      onPanEnd: (_) => _resetRotation(),
      onTapUp: (_) {
        _resetRotation();
        widget.onTap?.call();
      },
      onTapCancel: _resetRotation,
      child: TweenAnimationBuilder<Matrix4>(
        duration: const Duration(milliseconds: 150),
        tween: Matrix4Tween(
          begin: Matrix4.identity(),
          end: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(_xRotation)
            ..rotateY(_yRotation),
        ),
        builder: (context, transform, child) {
          return Transform.scale(
            scale: _isPressed ? 0.98 : 1.0,
            child: Transform(
              transform: transform,
              alignment: FractionalOffset.center,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
