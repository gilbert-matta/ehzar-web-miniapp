import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LeaderboardBanner extends StatelessWidget {
  final String title;

  const LeaderboardBanner({
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
            color: Color(0xFF006E94),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: whiteColor, // pale yellow text
            letterSpacing: 1,
            shadows: [
              Shadow(
                color: Colors.black38,
                offset: Offset(1, 2),
                blurRadius: 2,
              )
            ],
          ),
        ).tr(),
      ),
    );
  }
}
