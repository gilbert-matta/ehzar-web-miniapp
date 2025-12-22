

import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class LiveScore extends StatelessWidget {
  final String teamOneScore;
  final String teamTwoScore;
  final String matchType;
  final double? scoreFontSize;
  final double? typeFontSize;

  const LiveScore({
    super.key,
    required this.teamOneScore,
    required this.teamTwoScore,
    required this.matchType,
    this.scoreFontSize,
    this.typeFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$teamOneScore - $teamTwoScore",
            style: TextStyle(
                fontSize: scoreFontSize ?? fontSize24, fontWeight: FontWeight.w400)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(2)),
          child: Center(
            child: Text(
              matchType,
              style: TextStyle(
                  fontSize: typeFontSize ?? fontSize12, fontWeight: FontWeight.w400),
            ).tr(),
          ),
        )
      ],
    );
  }
}
