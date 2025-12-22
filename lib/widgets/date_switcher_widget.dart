

import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class DateSwitcherWidget extends StatelessWidget {
  final void Function()? onPressedBack;
  final void Function()? onPressedForward;
  final DateTime currentMonth;

  const DateSwitcherWidget({
    required this.onPressedBack,
    required this.onPressedForward,
    required this.currentMonth,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Left button
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: whiteColor),
          onPressed: onPressedBack,
        ),
        /// Center month text with animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Text(
            DateFormat.yMMMM().format(currentMonth), // eg. April 2025
            key: ValueKey<String>(DateFormat.yMMMM().format(currentMonth)),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        /// Right button
        IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: whiteColor),
          onPressed: onPressedForward,
        ),
      ],
    );
  }
}
