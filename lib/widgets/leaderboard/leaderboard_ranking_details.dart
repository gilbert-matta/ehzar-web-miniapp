

import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class LeaderboardRankingDetails extends StatelessWidget {
  final int rank;
  final String? userName;
  final num score;

  const LeaderboardRankingDetails({
    required this.userName,
    required this.rank,
    required this.score,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteOpacity5,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        minTileHeight: 60,
        leading: Text('$rank', style: TextStyle(
            fontSize: fontSize18,
            shadows: [
              Shadow(color: secondaryColor, blurRadius: 3, offset: Offset(1, 1)),
            ]
        ),),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: ui.TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('$userName'),
            const SizedBox(width: 10),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: secondaryColor,
              ),
              child: Center(
                child: Text(
                  userName != null ? getFirstLetter('$userName') : '',
                  style: TextStyle(fontSize: fontSize30, height: 1.2),
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Score").tr(),
            Text("$score")
          ],
        ),
      ),
    );
  }
}
