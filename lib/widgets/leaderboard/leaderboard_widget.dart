

import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/leaderboard_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/leaderboard/leaderboard_user_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<LeaderBoardModel> leaderboard;

  const LeaderboardWidget({
    required this.leaderboard,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 305,
      height: 230,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 305,
              height: 150,
              decoration: BoxDecoration(
                  color: whiteOpacity5,
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250, // Width for the entire layout
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("$staticImgUrl/stars.png"), fit: BoxFit.cover)
              ),
              child: Stack(
                clipBehavior: Clip.none, // Allow overflow for overlap
                children: [
                  // Left circle
                  Positioned(
                    left: 5,
                    top: 45, // Lower than the middle one
                    child: Column(
                      children: [
                        SizedBox(
                          height: 92,
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: grey94,
                                    shape: BoxShape.circle
                                ),
                                child: Center(
                                  child: leaderboard[0].leaderboardResults!.length > 1 ? Text("${getFirstLetter(leaderboard[0].leaderboardResults![1].user!.firstName!)}", style: TextStyle(fontSize: fontSize36)) : Icon(Icons.person_outline, size: 55, color: whiteColor)//CachedImageNetwork(image: leaderboard[1].image, fit: BoxFit.cover), // Replace with your image
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: grey94,
                                  child: Text("2", style: TextStyle(color: whiteColor)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        leaderboard[0].leaderboardResults!.length > 1 ? LeaderboardUserInfo(name: leaderboard[0].leaderboardResults![1].user!.firstName!, winningMatches: leaderboard[0].leaderboardResults![1].successCount!, totalMatches: leaderboard[0].leaderboardResults![1].matchesCount!) : NoWinner(),
                      ],
                    ),
                  ),

                  // Right circle
                  Positioned(
                    right: 5,
                    top: 40, // Lower than the middle one
                    child: Column(
                      children: [
                        SizedBox(
                          height: 92,
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: yellowA1,
                                    shape: BoxShape.circle
                                ),
                                child: Center(
                                  child: leaderboard[0].leaderboardResults!.length > 2 ? Text("${getFirstLetter(leaderboard[0].leaderboardResults![2].user!.firstName!)}", style: TextStyle(fontSize: fontSize36)) : Icon(Icons.person_outline, size: 55, color: whiteColor)//CachedImageNetwork(image: leaderboard[2].image, fit: BoxFit.cover), // Replace with your image
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: yellowA1,
                                  child: Text("3"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        leaderboard[0].leaderboardResults!.length > 2 ? LeaderboardUserInfo(name: leaderboard[0].leaderboardResults![2].user!.firstName!, winningMatches: leaderboard[0].leaderboardResults![2].successCount!, totalMatches: leaderboard[0].leaderboardResults![2].matchesCount!) : NoWinner(),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipOval(
                              child: Container(
                                  height: 50,
                                  child: CachedImageNetwork(image: leaderboard[0].championship?.icon)),
                          ),
                        ),
                      ),
                    )
                  ),

                  // Middle circle
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      gradient: blueMauveLinearGrad,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(
                                    child: leaderboard[0].leaderboardResults!.length > 0 ? Text("${getFirstLetter(leaderboard[0].leaderboardResults![0].user!.firstName!)}", style: TextStyle(fontSize: fontSize50),) : Icon(Icons.person_outline, size: 80, color: primaryColor)
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 2),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    gradient: blueMauveLinearGrad,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: Text("1", style: TextStyle(color: whiteColor, fontSize: fontSize16))),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: SvgPicture.asset("assets/images/crown.svg"),
                              ),
                            ],
                          ),
                        ),
                        leaderboard[0].leaderboardResults!.length > 0 ? LeaderboardUserInfo(name: "${leaderboard[0].leaderboardResults![0].user!.firstName!}", winningMatches: leaderboard[0].leaderboardResults![0].successCount!, totalMatches: leaderboard[0].leaderboardResults![0].matchesCount!) : NoWinner(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget NoWinner(){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text("___").tr(),
    );
  }
}
