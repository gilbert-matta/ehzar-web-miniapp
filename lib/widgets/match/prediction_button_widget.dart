import 'package:flutter/material.dart';
import 'package:ahzir/globals/colors.dart';

class PredictionButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final bool isSelected;

  const PredictionButtonWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: whiteColor),
        borderRadius: BorderRadius.circular(12.0),
        color: isSelected ? secondaryColor : backgroundColor,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: child,
      ),
    );
  }
}