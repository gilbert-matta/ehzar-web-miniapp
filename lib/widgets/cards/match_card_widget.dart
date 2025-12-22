import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/match/live_score.dart';
import 'package:ahzir/widgets/teams/team_widget.dart';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';

class MatchCardWidget extends StatelessWidget {
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamImage;
  final String awayTeamImage;
  final String date;
  final PredictionStatus? predictionStatusHomeTeam;
  final PredictionStatus? predictionStatusAwayTeam;
  final Color? containerColor;
  final void Function()? onTap;
  final String? matchStatus;
  final String homeTeamScore;
  final String awayTeamScore;
  final bool showNotCountedMessage; //this will display a message that the prediction will not be counted because the prediction is postponed/suspended/canceled
  final String tournamentName;

  const MatchCardWidget(
      {required this.homeTeamName,
      required this.awayTeamName,
      required this.homeTeamImage,
      required this.awayTeamImage,
      required this.date,
      required this.onTap,
      required this.matchStatus,
      required this.homeTeamScore,
      required this.awayTeamScore,
      this.predictionStatusHomeTeam,
      this.predictionStatusAwayTeam,
      this.containerColor,
      this.showNotCountedMessage = false,
      required this.tournamentName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
          minHeight: showNotCountedMessage ? 80 : 75,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.2),
            color: containerColor ?? whiteOpacity5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.345,
                      maxWidth: MediaQuery.of(context).size.width * 0.345),
                  // width: MediaQuery.of(context).size.width * 0.345,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TeamWidget(
                        teamName: homeTeamName,
                        image: homeTeamImage,
                        isRightTeam: true,
                        predictionStatus: predictionStatusHomeTeam,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      widgetPerMatchStatus(
                          matchStatus: matchStatus,
                          homeTeamScore: homeTeamScore,
                          awayTeamScore: awayTeamScore,
                          date: date),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.19,
                          child: Text("${tournamentName} ", style: TextStyle(fontSize: fontSize7), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis))
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.345,
                      maxWidth: MediaQuery.of(context).size.width * 0.345),
                  // width: MediaQuery.of(context).size.width * 0.345,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TeamWidget(
                        teamName: awayTeamName,
                        image: awayTeamImage,
                        isRightTeam: false,
                        predictionStatus: predictionStatusAwayTeam,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            showNotCountedMessage && (matchStatus?.toLowerCase() == MatchStatus.suspended.name.toLowerCase() ||
                    matchStatus?.toLowerCase() == MatchStatus.postponed.name.toLowerCase() ||
                    matchStatus?.toLowerCase() == MatchStatus.canceled.name.toLowerCase())
                ?
            Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                      "${notCountedMessage.tr()} ${capitalizeFirstWord(matchStatus!.toLowerCase()).tr()}", style: TextStyle(
                                fontSize: fontSize10,
                    color: redColor
                              ),).tr(),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
