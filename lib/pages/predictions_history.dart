import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/user.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/history_model.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/model/team_model.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/cards/match_card_widget.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/prediction/match_result_prediction.dart';
import 'package:ahzir/widgets/prediction/prediction_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class PredictionsHistory extends StatefulWidget {
  const PredictionsHistory({super.key});

  @override
  State<PredictionsHistory> createState() => _PredictionsHistoryState();
}

class _PredictionsHistoryState extends State<PredictionsHistory> {
  final ScrollController _scrollController = ScrollController();
  DataLoadState predictionsState = DataLoadState.loading;
  String? error;
  List<HistoryModel> predictionsList = [];
  int page = 1;
  int limit = 10;
  MatchViewModel? _matchProvider;
  bool dataFinishedOnScroll = false;
  bool isLoadingData = false;

  @override
  void initState() {
    _matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    getAllPredictions();
    _scrollController.addListener(() {
      if (!isLoadingData &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (isMobile(context)) {
          getAllPredictions();
        }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: defaultSkeleton(
        context: context,
        loadState: predictionsState,
        loadingWidget: matchSkeleton(context: context, listLength: 15),
        errorWidget: ErrorTextPage(errorText: error),
        dataWidget: predictionsList.isNotEmpty
            ? SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    ...List.generate(
                        predictionsList.length + (isLoadingData ? 1 : 0),
                        (int i) {
                      if (i < predictionsList.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Container(
                            color: whiteOpacity5,
                            child: Column(
                              children: [
                                Container(
                                  height: 35,
                                  color: secondaryColor,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const SizedBox(width: 5),
                                      Text(
                                        "your prediction:",
                                        style: TextStyle(fontSize: fontSize11),
                                      ).tr(),
                                      const SizedBox(width: 5),
                                      (() {
                                        print(
                                            'Prediction result for index $i: ${predictionsList[i].result}');
                                        return const SizedBox.shrink();
                                      })(),
                                      predictionsList[i].fields.any((field) =>
                                              field ==
                                              PredictionType.result.name
                                                  .toLowerCase())
                                          ? MatchResultPrediction(
                                              predictionStatus:
                                                  predictionsList[i].result!,
                                              winnerTeamImage:
                                                  predictionsList[i].result ==
                                                          predictionsList[i]
                                                              .match
                                                              .homeTeam
                                                              ?.id
                                                      ? predictionsList[i]
                                                          .match
                                                          .homeTeam
                                                          ?.imgUrl
                                                      : predictionsList[i]
                                                          .match
                                                          .awayTeam
                                                          ?.imgUrl)
                                          : (predictionsList[i].fields.any((field) => field == PredictionType.home.name.toLowerCase()) &&
                                                  predictionsList[i].fields.any(
                                                      (field) =>
                                                          field ==
                                                          PredictionType.away.name
                                                              .toLowerCase()))
                                              ? PredictionWidget(
                                                  homeTeamImage:
                                                      "${predictionsList[i].match.homeTeam?.imgUrl}",
                                                  awayTeamImage:
                                                      "${predictionsList[i].match.awayTeam?.imgUrl}",
                                                  homeTeamScore: "${predictionsList[i].homeScore}",
                                                  awayTeamScore: "${predictionsList[i].awayScore}")
                                              : Text(
                                                  "${predictionsList[i].matchType}: ${predictionsList[i].typesResult.values.first}",
                                                  style: TextStyle(
                                                      fontSize: fontSize11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                    ],
                                  ),
                                ),
                                MatchCardWidget(
                                  containerColor: Colors.transparent,
                                  onTap: () {},
                                  homeTeamName:
                                      "${predictionsList[i].match.homeTeam?.name}",
                                  awayTeamName:
                                      "${predictionsList[i].match.awayTeam?.name}",
                                  homeTeamImage:
                                      "${predictionsList[i].match.homeTeam?.imgUrl}",
                                  awayTeamImage:
                                      "${predictionsList[i].match.awayTeam?.imgUrl}",
                                  homeTeamScore:
                                      "${predictionsList[i].match.homeTeamScore}",
                                  awayTeamScore:
                                      "${predictionsList[i].match.awayTeamScore}",
                                  date: convertToDateTime(
                                      predictionsList[i].match.matchDate,
                                      predictionsList[i].match.startingAt),
                                  matchStatus: predictionsList[i].match.status,
                                  showNotCountedMessage: true,
                                  tournamentName: predictionsList[i]
                                      .match
                                      .championship!
                                      .name,
                                  // predictionStatusTeamOne:
                                  //     PredictionStatus.win,
                                  // predictionStatusTeamTwo:
                                  //     PredictionStatus.lose
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        if (isMobile(context)) {
                          return const CircularProgressWidget();
                        }
                        return Container();
                      }
                    }),
                    !isMobile(context) && dataFinishedOnScroll == false
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(
                              child: AppButton(
                                  width: 150,
                                  height: 42,
                                  color: secondaryColor,
                                  isLoading: isLoadingData,
                                  onPressed: () => getAllPredictions(),
                                  text: 'load more'),
                            ),
                          )
                        : Container()
                  ],
                ),
              )
            : const ErrorTextPage(errorText: 'No data found!'),
      ),
    );
  }

  getAllPredictions() async {
    if (!isLoadingData && !dataFinishedOnScroll) {
      setState(() {
        isLoadingData = true;
      });
      Response response =
          await _matchProvider?.getUserPredictions(page: page, limit: limit);

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> res = response.data['userPrediction'];
        List<HistoryModel> tempMatchesList =
            res.map((e) => HistoryModel.fromJson(e)).toList();
        predictionsList.addAll(tempMatchesList);

        for (HistoryModel prediction in predictionsList) {
          prediction.match.homeTeam = TeamModel(
              id: prediction.match.homeTeamId,
              name: prediction.match.homeTeam?.name,
              shortName: '',
              imgUrl: prediction.match.homeTeam?.imgUrl);
          prediction.match.awayTeam = TeamModel(
              id: prediction.match.awayTeamId,
              name: prediction.match.awayTeam?.name,
              shortName: '',
              imgUrl: prediction.match.awayTeam?.imgUrl);
        }

        if (tempMatchesList.length < limit) {
          dataFinishedOnScroll = true;
        }

        predictionsState = DataLoadState.loaded;
        setState(() {
          page++;
          predictionsList;
          predictionsState;
          error;
          isLoadingData = false;
        });
      } else {
        if (page == 1) {
          error = response.data['message'];
          predictionsState = DataLoadState.error;
        } else {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        }
        setState(() {
          predictionsList;
          predictionsState;
          error;
          isLoadingData = false;
        });
      }
    }
  }
}
