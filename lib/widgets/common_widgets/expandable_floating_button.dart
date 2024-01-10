import 'package:flutter/material.dart';
import 'dart:math' as math;

@immutable
class ExpandableFab extends StatefulWidget {

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  const ExpandableFab({
    this.initialOpen,
    required this.distance,
    required this.children,
    super.key,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOutQuad, parent: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() => setState(() {
    _open = !_open;
    _open ? _controller.forward() : _controller.reverse();
  });

  @override
  Widget build(BuildContext context) {
    double diagonalValue = _open ? 0.7 : 1;
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Material(
              color: Colors.white12,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: InkWell(
                onTap: _toggle,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
          ..._buildExpandingActionButtons(),
          IgnorePointer(
            ignoring: _open,
            child: AnimatedContainer(
              transformAlignment: Alignment.center,
              transform: Matrix4.diagonal3Values(diagonalValue, diagonalValue, 1.0),
              duration: const Duration(milliseconds: 250),
              curve: const Interval(0, 0.5, curve: Curves.easeOut),
              child: AnimatedOpacity(
                opacity: _open ? 0 : 1,
                curve: const Interval(0.25, 1, curve: Curves.easeInOut),
                duration: const Duration(milliseconds: 250),
                child: FloatingActionButton(
                  onPressed: _toggle,
                  child: const Icon(Icons.create),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final List<Widget> children = [];
    final int count = widget.children.length;
    final double step = 90 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0; i < count; i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(directionInDegrees * (math.pi / 180), progress.value * maxDistance);
        return Positioned(
          right: 4 + offset.dx,
          bottom: 4 + offset.dy,
          child: Transform.rotate(angle: (1 - progress.value) * math.pi / 2, child: child!),
        );
      },
      child: FadeTransition(opacity: progress, child: child),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final Widget icon;

  const ActionButton({
    this.onPressed,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.white12,
      elevation: 4,
      child: IconButton(onPressed: onPressed, icon: icon),
    );
  }
}