import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/user.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/model/vod_model.dart';
import 'package:ahzir/pages/auth/login.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/widgets/alert_dialogs/alert_dialog.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/error/errorDialog.dart';
import 'package:ahzir/widgets/match/match_details_widget.dart';
import 'package:ahzir/widgets/match/prediction_button_widget.dart';
import 'package:ahzir/widgets/prediction/team_score_prediction.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/teams/team_info_vertical.dart';
import 'package:ahzir/widgets/dialogs/championship_packages_dialog.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'match_highlights.dart';

class MatchPrediction extends StatefulWidget {
  final MatchModel matchInfo;
  final int matchId;

  const MatchPrediction(
      {required this.matchInfo, required this.matchId, super.key});

  @override
  State<MatchPrediction> createState() => _MatchPredictionState();
}

class _MatchPredictionState extends State<MatchPrediction> {
  MatchViewModel? matchProvider;
  StoreViewModel? storeProvider;
  MatchModel? _match;
  DataLoadState matchState = DataLoadState.loading;
  var predictionTeam; //predict if draw, team_one, team_two
  int homeTeamScore = 0;
  int awayTeamScore = 0;
  bool isLoading = false;
  bool isPredicted =
      false; //if the user have predicted once, he can not retry predicting the same one
  int _pageVideos = 1;
  int _limitVideos = 2;
  List<VodModel> vodList = [];
  YoutubePlayerController? youtubeController;
  String? currentTime;

  @override
  void initState() {
    matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    storeProvider = Provider.of<StoreViewModel>(context, listen: false);
    getMatchInfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (youtubeController != null) {
      youtubeController?.dispose(); // Dispose the controller properly
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _close(); // Your custom logic to handle back press
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: whiteOpacity5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TeamInfoVertical(
                            teamName: "${widget.matchInfo.homeTeam?.name}",
                            teamImage: "${widget.matchInfo.homeTeam?.imgUrl}"),
                        matchState == DataLoadState.loaded
                            ? widgetPerMatchStatus(
                                matchStatus: _match!.status,
                                homeTeamScore: _match!.homeTeamScore,
                                awayTeamScore: _match!.awayTeamScore,
                                date: convertToDateTime(_match!.matchDate,
                                    widget.matchInfo.startingAt))
                            : matchDetailsSkeleton(context: context),
                        TeamInfoVertical(
                            teamName: "${widget.matchInfo.awayTeam?.name}",
                            teamImage: "${widget.matchInfo.awayTeam?.imgUrl}"),
                      ],
                    ),
                    if (_isMatchNotCounted)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "${notCountedMessage.tr()} ${capitalizeFirstWord(_match!.status.toLowerCase()).tr()}",
                          style:
                              TextStyle(fontSize: fontSize11, color: redColor),
                        ).tr(),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              defaultSkeleton(
                context: context,
                loadState: matchState,
                errorWidget: predictionSkeleton(context: context),
                loadingWidget: predictionSkeleton(context: context),
                dataWidget: _isScheduledMatch
                    ? Column(
                        //if the match is not live or inplay, show the predictions, else do not show
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _match!.predictionType.any((field) => field.fields.any(
                                  (key) => key == PredictionType.result.name))
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: whiteOpacity5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Who will win?").tr(),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          PredictionButtonWidget(
                                            backgroundColor: predictionTeam ==
                                                    _match?.homeTeam?.id
                                                ? secondaryColor
                                                : null,
                                            onPressed: isPredicted ||
                                                    predictionTeam != null
                                                ? null
                                                : () => predictMatch(
                                                    predictType:
                                                        _match?.homeTeam?.id),
                                            child: CachedImageNetwork(
                                              image:
                                                  "${widget.matchInfo.homeTeam?.imgUrl}",
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                          PredictionButtonWidget(
                                            backgroundColor:
                                                predictionTeam == "draw"
                                                    ? secondaryColor
                                                    : null,
                                            onPressed: isPredicted ||
                                                    predictionTeam != null
                                                ? null
                                                : () => predictMatch(
                                                    predictType: 'draw'),
                                            child: Text("Draw",
                                                    style: TextStyle(
                                                        fontSize: fontSize12,
                                                        color: whiteColor))
                                                .tr(),
                                          ),
                                          PredictionButtonWidget(
                                            backgroundColor: predictionTeam ==
                                                    _match?.awayTeam?.id
                                                ? secondaryColor
                                                : null,
                                            onPressed: isPredicted ||
                                                    predictionTeam != null
                                                ? null
                                                : () => predictMatch(
                                                    predictType:
                                                        _match?.awayTeam?.id),
                                            child: CachedImageNetwork(
                                              image:
                                                  "${widget.matchInfo.awayTeam?.imgUrl}",
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : _match!.predictionType.any((field) =>
                                      _match!.predictionType.any((field) =>
                                          field.fields.any((key) =>
                                              key ==
                                              PredictionType.home.name)) &&
                                      _match!.predictionType.any((field) =>
                                          field.fields.any((key) =>
                                              key == PredictionType.away.name)))
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: whiteOpacity5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Predict Match Result")
                                              .tr(),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment: isMobile(context)
                                                ? MainAxisAlignment.spaceBetween
                                                : MainAxisAlignment.spaceAround,
                                            children: [
                                              TeamScorePrediction(
                                                  image:
                                                      "${widget.matchInfo.homeTeam?.imgUrl}",
                                                  teamScore: homeTeamScore,
                                                  onPlusPressed: isPredicted
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            homeTeamScore++;
                                                          });
                                                        },
                                                  onMinusPressed: isPredicted
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            if (homeTeamScore >
                                                                0) {
                                                              homeTeamScore--;
                                                            }
                                                          });
                                                        }),
                                              const SizedBox(width: 71),
                                              TeamScorePrediction(
                                                  image:
                                                      "${widget.matchInfo.awayTeam?.imgUrl}",
                                                  teamScore: awayTeamScore,
                                                  onPlusPressed: isPredicted
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            awayTeamScore++;
                                                          });
                                                        },
                                                  onMinusPressed: isPredicted
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            if (awayTeamScore >
                                                                0) {
                                                              awayTeamScore--;
                                                            }
                                                          });
                                                        })
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              isPredicted
                                                  ? Container()
                                                  : AppButton(
                                                      onPressed: () =>
                                                          predictMatch(),
                                                      text: 'Submit',
                                                      color: secondaryColor,
                                                      width: 120,
                                                      isLoading: isLoading)
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container()
                        ],
                      )
                    : Container(),
              ),

              // Only display the YouTube player when it's initialized
              if (youtubeController != null)
                if (vodList.length > 1)
                  ListTile(
                    title: Text("More").tr(),
                    trailing: IconButton(
                        onPressed: () => nextScreen(
                            context, MatchHighlights(matchId: widget.matchId)),
                        icon: Icon(Icons.arrow_forward_ios, color: whiteColor),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent),
                    contentPadding: EdgeInsets.zero,
                  ),
              if (vodList.length > 0)
                Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: Theme.of(context).textTheme.apply(
                              bodyColor: Colors.black, // Main text color
                              displayColor:
                                  Colors.black, // For headers/titles if any
                            ),
                      ),
                      child: YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: youtubeController!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: primaryColor,
                          progressColors: ProgressBarColors(
                            playedColor: primaryColor,
                            handleColor: primaryColor,
                          ),
                          onEnded: (metaData) {
                            // Unlock orientation after the video ends
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                            ]);
                          },
                        ),
                        builder: (context, player) {
                          return player;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              const SizedBox(height: 20),
              currentTime != null
                  ? MatchDetailsWidget(
                      title: "Match Details",
                      matchDate: widget.matchInfo.matchDate,
                      startingAt: widget.matchInfo.startingAt,
                      championshipName:
                          "${widget.matchInfo.championship?.name}",
                      endTime: convertUtcToLocal(currentTime!))
                  : Container(),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  getMatchInfo() async {
    final results = await Future.wait<dynamic>([
      matchProvider?.getMatchPerId(id: widget.matchId),
      matchProvider?.getVideosPerMatchId(
          matchId: widget.matchId, page: _pageVideos, limit: _limitVideos)
    ]);
    final matchResponse = results[0] as Response;
    final videosResponse = results[1] as Response;

    if (matchResponse.statusCode != null &&
        (matchResponse.statusCode! >= 200 &&
            matchResponse.statusCode! <= 399)) {
      List<dynamic> vodTemp = videosResponse.data['data'];
      vodList = vodTemp.map((e) => VodModel.fromJson(e)).toList();
      if (vodList.isNotEmpty && youtubeController == null) {
        String? videoId = YoutubePlayer.convertUrlToId(vodList[0].link);
        if (videoId != null) {
          youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(
              autoPlay: false,
              isLive: false,
              loop: false,
            ),
          );
        }
      }
    }

    if (matchResponse.statusCode != null &&
        (matchResponse.statusCode! >= 200 &&
            matchResponse.statusCode! <= 399)) {
      var dataValue = matchResponse.data;
      _match = MatchModel.fromJson(dataValue);
      currentTime = dataValue['currentTime'];
      matchState = DataLoadState.loaded;
      if (_match != null && _match!.predictionValues.length > 0) {
        predictionTeam = _match?.predictionValues[0].predictionValue['result'];
        if (_match?.predictionValues[0].predictionValue['home'] != null ||
            _match?.predictionValues[0].predictionValue['away'] != null) {
          homeTeamScore = _match?.predictionValues[0].predictionValue['home'];
          awayTeamScore = _match?.predictionValues[0].predictionValue['away'];
          isPredicted = true;
        }
      }
    } else {
      appSnackBar(
          context: context, msg: matchResponse.data['message'], isError: true);
      matchState = DataLoadState.error;
    }

    setState(() {
      matchState;
      _match;
      vodList;
      predictionTeam;
      homeTeamScore;
      awayTeamScore;
      isPredicted;
      currentTime;
    });
  }


  predictMatch({var predictType}) async {
    bool isLoggedIn = await checkUserIfLoggedIn();
    if (isLoggedIn) {
      if (!isPredicted) {
        AlertDialogWidget(
            context: context,
            title: 'Warning',
            content: 'Are you sure you want to confirm this prediction?',
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                predictionTeam = predictType;
                submitMatchResult(predictType);
              });
            });
      }
    } else {
      ErrorDialog(
          context: context,
          title: 'UnAuthorized',
          error: 'You are not logged in!',
          onPressed: () {
            Navigator.pop(context);
            nextScreen(context, Login());
          });
    }
  }

  submitMatchResult(var predictType) async {
    setState(() {
      isLoading = true;
    });
    var data;
    if (_match!.predictionType.any((field) =>
        field.fields.any((key) => key == PredictionType.result.name))) {
      data = {
        'matchId': _match?.id,
        'championshipId': widget.matchInfo.championshipId,
        'campaignId': _match?.campaign?.id,
        'typeId': _match?.predictionType[0]
            .id, //it returns a list of prediction types, but here in this page we will need only one so it will be the first one, this model returns list of predictiontypes for the daily challenges
        "predictionValue": {
          "result": predictionTeam,
        }
      };
    } else if (_match!.predictionType.any((field) =>
            field.fields.any((key) => key == PredictionType.home.name)) &&
        _match!.predictionType.any((field) =>
            field.fields.any((key) => key == PredictionType.away.name))) {
      data = {
        'matchId': _match?.id,
        'championshipId': widget.matchInfo.championshipId,
        'campaignId': _match?.campaign?.id,
        'typeId': _match?.predictionType[0].id,
        "predictionValue": {
          "home": homeTeamScore,
          "away": awayTeamScore,
        }
      };
    }
    debugPrint("data: $data");
    Response response = await matchProvider?.setMatchPrediction(data: data);
    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      appSnackBar(context: context, msg: "Voted Successfully!");
      isPredicted = true;

    } else {
      appSnackBar(
          context: context, msg: response.data['message'], isError: true);
      isPredicted = false;
      predictionTeam = null; // Clear blue highlight for other errors
    }
    setState(() {
      isLoading = false;
      isPredicted;
      predictionTeam;
    });
  }

  bool get _isMatchNotCounted =>
      _match?.status.toLowerCase() ==
          MatchStatus.suspended.name.toLowerCase() ||
      _match?.status.toLowerCase() ==
          MatchStatus.postponed.name.toLowerCase() ||
      _match?.status.toLowerCase() == MatchStatus.canceled.name.toLowerCase();

  bool get _isScheduledMatch =>
      _match?.status.toLowerCase() == MatchStatus.scheduled.name ||
      _match?.status.toLowerCase() == MatchStatus.timed.name;

  _close() {
    if (!isLoading) {
      Navigator.pop(context, isPredicted);
    }
  }
}
