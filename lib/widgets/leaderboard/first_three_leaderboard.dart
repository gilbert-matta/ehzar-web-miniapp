

import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/leaderboard_user_result_model.dart';
import 'package:ahzir/widgets/leaderboard/leaderboard_card.dart';
import 'package:easy_localization/easy_localization.dart';

class FirstThreeLeaderboard extends StatelessWidget {
  final List<LeaderboardUserResultModel> leaderboardUser;

  const FirstThreeLeaderboard({
    required this.leaderboardUser,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LeaderboardCard(
          userName: leaderboardUser.length > 1 ? shorten(leaderboardUser[1].user!.firstName!, 8) : "None".tr(),
          points: leaderboardUser.length > 1 ? leaderboardUser[1].score! : 0,
          containerHeight: 200,
          cardHeight: 140,
          padding: const EdgeInsets.only(top: 8),
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 40),
              Icon(Icons.star, color: Colors.yellow, size: 40),
            ],
          ),
          rank: 2,
        ),
        LeaderboardCard(
          userName: shorten(leaderboardUser[0].user!.firstName!, 8),
          points: leaderboardUser[0].score!,
          containerHeight: 200,
          cardHeight: 150,
          bodyWidget: Icon(Icons.star, color: Colors.yellow, size: 60),
          rank: 1,
        ),
        LeaderboardCard(
          userName: leaderboardUser.length > 2 ? shorten(leaderboardUser[2].user!.firstName!, 8) : "None".tr(),
          points: leaderboardUser.length > 2 ? leaderboardUser[2].score! : 0,
          containerHeight: 200,
          cardHeight: 140,
          padding: const EdgeInsets.only(top: 8),
          bodyWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 35),
                Icon(Icons.star, color: Colors.yellow, size: 35),
                Icon(Icons.star, color: Colors.yellow, size: 35),
              ],
            ),
          ),
          rank: 3,
        ),
      ],
    );
  }
}
