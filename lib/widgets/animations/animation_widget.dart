import 'package:flutter/material.dart';

class AnimationWidget extends StatefulWidget {
  Widget animationWidget1;
  Widget animationWidget2;
  Widget animationWidget3;
  MainAxisAlignment? mainAxisAlignment;

  AnimationWidget({
    required this.animationWidget1,
    required this.animationWidget2,
    required this.animationWidget3,
    this.mainAxisAlignment,
    super.key
  });

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeInOut)),
    );

    _animation2 = Tween(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)),
    );

    _animation3 = Tween(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animation1,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation1.value),
              child: child,
            );
          },
          child: widget.animationWidget1,
        ),
        AnimatedBuilder(
          animation: _animation2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation2.value),
              child: child,
            );
          },
          child: widget.animationWidget2,
        ),
        AnimatedBuilder(
          animation: _animation3,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation3.value),
              child: child,
            );
          },
          child: widget.animationWidget3,
        ),
      ],
    );
  }
}
