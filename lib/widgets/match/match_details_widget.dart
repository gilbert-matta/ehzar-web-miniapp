import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:flutter/material.dart';
import 'package:ahzir/globals/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class MatchDetailsWidget extends StatelessWidget {
  final String title;
  final String matchDate;
  final String startingAt;
  final String championshipName;
  final DateTime endTime;

  const MatchDetailsWidget({
    super.key,
    required this.title,
    required this.matchDate,
    required this.startingAt,
    required this.championshipName,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: whiteOpacity5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title").tr(),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, color: whiteColor),
              const VerticalDivider(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: grey38, // Background color
                  borderRadius:
                  BorderRadius.circular(8.0), // Rounded corners
                ),
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Text(convertToDateTime(matchDate, startingAt),
                    style: TextStyle(
                      fontSize: fontSize12,
                      color: Colors.white, // Text color
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.sports, color: whiteColor),
              const VerticalDivider(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: grey38, // Background color
                  borderRadius:
                  BorderRadius.circular(8.0), // Rounded corners
                ),
                child: Text(
                  "$championshipName",
                  style: TextStyle(
                    fontSize: fontSize12,
                    color: Colors.white, // Text color
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.timer, color: whiteColor),
              const VerticalDivider(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: grey38, // Background color
                  borderRadius:
                  BorderRadius.circular(8.0), // Rounded corners
                ),
                child: Row(
                  children: [
                    Text(
                      "Time left to predict:",
                      style: TextStyle(
                        fontSize: fontSize12,
                        color: Colors.white, // Text color
                        height: 1.5,
                      ),
                    ).tr(),
                    const SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: TimerCountdown(
                          format: CountDownTimerFormat.daysHoursMinutesSeconds,
                          endTime: endTime,
                          onEnd: () {
                            // debugPrint("Timer finished");
                          },
                          enableDescriptions: false,
                          colonsTextStyle: TextStyle(
                              fontSize: fontSize12,
                              height: 1,
                              
                          ),
                          timeTextStyle: TextStyle(
                              fontSize: fontSize12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}