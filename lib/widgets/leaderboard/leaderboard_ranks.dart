


import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/leaderboard_user_result_model.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/leaderboard/first_three_leaderboard.dart';
import 'package:ahzir/widgets/leaderboard/leaderboard_banner.dart';
import 'package:ahzir/widgets/leaderboard/leaderboard_ranking_details.dart';

class LeaderboardRanks extends StatelessWidget {
  final List<LeaderboardUserResultModel> leaderboardFirstThree;
  final String leaderboardBannerTitle;
  final ScrollController? controller;
  final int? itemCount;
  final List<LeaderboardUserResultModel> leaderboards;
  final bool isLoadingData;

  const LeaderboardRanks({
    required this.leaderboardFirstThree,
    required this.leaderboardBannerTitle,
    required this.controller,
    required this.itemCount,
    required this.leaderboards,
    required this.isLoadingData,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20.0),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: darkBlue09,
                  ),
                  child: FirstThreeLeaderboard(leaderboardUser: leaderboardFirstThree),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: LeaderboardBanner(title: leaderboardBannerTitle),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            controller: controller,
            itemCount: (itemCount ?? 0) + (isLoadingData && isMobile(context) ? 1 : 0),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            itemBuilder: (context, i) {
              // var leader = i + 3;
              // return Padding(
              //   padding: const EdgeInsets.only(bottom: 8.0),
              //   child: LeaderboardRankingDetails(
              //       userName: leaderboards[leader].user!.firstName!,
              //       rank: i + 4,
              //       score: leaderboards[leader].score!
              //   ),
              // );


                      // Show loading spinner at the end (only for mobile)
                      if (isLoadingData &&
                          isMobile(context) &&
                          i == leaderboards.length - 3) {
                        return const CircularProgressWidget();
                      }

                      final leaderIndex = i + 3;
                      if (leaderIndex < leaderboards.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: LeaderboardRankingDetails(
                            userName: leaderboards[leaderIndex].user!.firstName!,
                            rank: i + 4,
                            score: leaderboards[leaderIndex].score!,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
            },
          ),
        )
      ],
    );
  }
}
