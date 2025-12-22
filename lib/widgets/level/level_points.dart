


import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/level_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:ui' as ui;

class LevelPoints extends StatelessWidget {
  final LevelModel level;

  const LevelPoints({
    required this.level,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text("Lvl. ${level.name}", style: TextStyle(
                  color: whiteColor,
                  fontSize: fontSize12
              ),),
              const SizedBox(width: 10),
              CachedImageNetwork(image: level.logo, width: 20, height: 20),
            ],
          ),
          const SizedBox(height: 5),
          LinearPercentIndicator(
            percent: (level.userTotalPoints - level.minPoints) / level.maxPoints,
            width: 110,
            animation: true,
            barRadius: Radius.circular(12),
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
          ),
          const SizedBox(height: 5),
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Text("${numberWithComma(level.userTotalPoints)} / ${level.maxPoints} pts", style: TextStyle(
                fontSize: fontSize12,
                color: whiteColor
            ),),
          )
        ],
      ),
    );
  }
}
