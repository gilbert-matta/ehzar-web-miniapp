import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/match/live_score.dart';
import 'package:ahzir/widgets/teams/user_team_prediction.dart';

class TeamsMatchLive extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamImage;
  final String awayTeamImage;
  final String homeTeamScore;
  final String awayTeamScore;
  final TextStyle? textStyle;
  final double? imgWidth;
  final double? imgHeight;
  final PredictionStatus? predictionStatusHomeTeam;
  final PredictionStatus? predictionStatusAwayTeam;
  final String? userProfileImg;

  const TeamsMatchLive(
      {required this.homeTeamName,
      required this.awayTeamName,
      required this.homeTeamImage,
      required this.awayTeamImage,
      required this.homeTeamScore,
      required this.awayTeamScore,
      this.userProfileImg,
      this.textStyle,
      this.imgWidth,
      this.imgHeight,
      this.predictionStatusHomeTeam,
      this.predictionStatusAwayTeam,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        UserTeamPrediction(
          teamName: homeTeamName,
          image: homeTeamImage,
          imgHeight: 52,
          isRightTeam: false,
          predictionStatus: predictionStatusHomeTeam,
          profileImg: userProfileImg,
        ),
        LiveScore(teamOneScore: homeTeamScore, teamTwoScore: awayTeamScore, matchType: "Live"),
        UserTeamPrediction(
          teamName: awayTeamName,
          image: awayTeamImage,
          imgHeight: 52,
          isRightTeam: true,
          predictionStatus: predictionStatusAwayTeam,
          profileImg: userProfileImg,
        ),
      ],
    );
  }
}
