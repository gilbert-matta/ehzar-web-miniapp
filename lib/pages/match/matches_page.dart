import 'dart:async';
import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/user.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/cards/match_card_widget.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final ScrollController _scrollController = ScrollController();
  DataLoadState matchState = DataLoadState.loading;
  String? error;
  List<MatchModel> matchesList = [];
  int page = 1;
  int limit = 10;
  MatchViewModel? _matchProvider;
  Timer? _debounce;
  bool dataFinishedOnScroll = false;
  bool isLoadingData = false;

  @override
  void initState() {
    _matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    getAllMatches();
    _scrollController.addListener(() {
      if (!isLoadingData &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
                if (isMobile(context)) {
                  getAllMatches();
                }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: defaultSkeleton(
        context: context,
        loadState: matchState,
        loadingWidget: matchSkeleton(context: context, listLength: 15),
        errorWidget: ErrorTextPage(errorText: error),
        dataWidget: matchesList.isNotEmpty
            ? SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    ...List.generate(
                      matchesList.length + (isLoadingData ? 1 : 0), (int i) {
                      if (i < matchesList.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: MatchCardWidget(
                            onTap: () => navigateToMatchPrediction(
                                matchInfo: matchesList[i],
                                matchId: matchesList[i].id,
                                context: context),
                            homeTeamName: "${matchesList[i].homeTeam?.name}",
                            awayTeamName: "${matchesList[i].awayTeam?.name}",
                            homeTeamImage: "${matchesList[i].homeTeam?.imgUrl}",
                            awayTeamImage: "${matchesList[i].awayTeam?.imgUrl}",
                            homeTeamScore: matchesList[i].homeTeamScore,
                            awayTeamScore: matchesList[i].awayTeamScore,
                            date: convertToDateTime(matchesList[i].matchDate, matchesList[i].startingAt),
                            matchStatus: matchesList[i].status,
                            tournamentName: matchesList[i].championship!.name,
                            // predictionStatusTeamOne:
                            //     PredictionStatus.win,
                            // predictionStatusTeamTwo:
                            //     PredictionStatus.lose
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
                            onPressed: () => getAllMatches(),
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

  getAllMatches() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!isLoadingData && !dataFinishedOnScroll) {
        setState(() {
          isLoadingData = true;
        });
        Response response = await _matchProvider?.getMatches(

            page: page,
            limit: limit,
            dateFrom: DateTime.now().toString(),
            dateTo: DateTime.now().add(const Duration(days: 7)).toString());

        if (response.statusCode != null &&
            (response.statusCode! >= 200 && response.statusCode! <= 399)) {
          List<dynamic> res = response.data['data'];
          List<MatchModel> tempMatchesList =
              res.map((e) => MatchModel.fromJson(e)).toList();
          matchesList.addAll(tempMatchesList);

          if (tempMatchesList.length < limit) {
            dataFinishedOnScroll = true;
          }

          matchState = DataLoadState.loaded;
          setState(() {
            page++;
            matchesList;
            matchState;
            error;
            isLoadingData = false;
          });
        } else {
          if (page == 0) {
            error = response.data['message'];
            matchState = DataLoadState.error;
          } else {
            appSnackBar(
                context: context, msg: response.data['message'], isError: true);
          }
          setState(() {
            matchesList;
            matchState;
            error;
            isLoadingData = false;
          });
        }
      }
    });
  }
}
