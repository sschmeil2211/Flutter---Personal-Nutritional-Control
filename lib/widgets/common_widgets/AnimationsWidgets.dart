import 'package:flutter/material.dart';

class SwitchAnimation extends StatelessWidget {

  final bool isPressed;
  final Widget newWidget;
  final Widget originalWidget;

  const SwitchAnimation({
    required this.isPressed,
    required this.newWidget,
    required this.originalWidget,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: isPressed
          ? AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
        ),
        child: this.newWidget,
      )
          : this.originalWidget,
    );
  }
}

class FadeAnimation extends StatefulWidget {

  final bool isFaded;
  final Widget child;

  const FadeAnimation({
    required this.isFaded,
    required this.child,
    super.key
  });

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  void _runFadedCheck() => widget.isFaded ? _controller.reverse() : _controller.forward();

  void prepareAnimations(){
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    prepareAnimations();
    _runFadedCheck();
    super.initState();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runFadedCheck();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class ExpandedAnimation extends StatefulWidget {

  final Widget child;
  final bool isExpanded;

  const ExpandedAnimation({
    this.isExpanded = false,
    required this.child,
    super.key
  });

  @override
  State<ExpandedAnimation> createState() => _ExpandedAnimationState();
}

class _ExpandedAnimationState extends State<ExpandedAnimation> with SingleTickerProviderStateMixin {

  late AnimationController expandController;
  late Animation<double> animation;

  void _runExpandCheck() => widget.isExpanded ? expandController.forward() : expandController.reverse();

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  @override
  void didUpdateWidget(ExpandedAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: animation,
        child: widget.child
    );
  }
}