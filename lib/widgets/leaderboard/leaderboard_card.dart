

import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/hexColor/hex_color.dart';
import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class LeaderboardCard extends StatelessWidget {
  final String? userName;
  final double? containerHeight;
  final double? cardHeight;
  final num points;
  final Widget bodyWidget;
  final EdgeInsetsGeometry? padding;
  final int rank;

  const LeaderboardCard({
    required this.bodyWidget,
    required this.userName,
    required this.points,
    required this.rank,
    this.cardHeight,
    this.containerHeight,
    this.padding,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight ?? 180,
      padding: padding,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 24),
            child: Container(
              width: 105,
              height: cardHeight ?? 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xFF006E94),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text("$userName"),
                  ),
                  const SizedBox(height: 5),
                  bodyWidget,
                  const SizedBox(height: 5),
                  Text("${"Score".tr()}: $points", style: TextStyle(
                      fontSize: fontSize14
                  ))
                ],
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 30,
            right: 30,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: secondaryColor
              ),
              child: Center(child: Text("${getFirstLetter('$userName')}", style: TextStyle(
                  fontSize: fontSize30
              ),)),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 30,
            right: 30,
            child: CircleAvatar(
              radius: 12,
              child: Text("$rank"),
            ),
          ),
        ],
      ),
    );
  }
}
