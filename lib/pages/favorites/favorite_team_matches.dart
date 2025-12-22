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
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/expansion_tile/expansion_tile_widget.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class FavoriteTeamMatches extends StatefulWidget {
  const FavoriteTeamMatches({super.key});

  @override
  State<FavoriteTeamMatches> createState() => _FavoriteTeamMatchesState();
}

class _FavoriteTeamMatchesState extends State<FavoriteTeamMatches> {
  final ScrollController _historyScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  DataLoadState matchState = DataLoadState.loading;
  DataLoadState matchHistoryState = DataLoadState.loading;
  String? error;
  String? errorHistory;
  List<MatchModel> favoriteMatchesList = [];
  List<MatchModel> favoriteMatchesListHistory = [];
  int page = 1;
  int limit = 10;
  int pageHistory = 1;
  int limitHistory = 10;
  MatchViewModel? _matchProvider;
  bool dataFinishedOnScroll = false;
  bool isLoadingData = false;
  bool dataHistoryFinishedOnScroll = false;
  bool isLoadingDataHistory = false;

  @override
  void initState() {
    _matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    _scrollController.addListener(() {
      if (!isLoadingData &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
          getAllMatches();
      }
    });
    _historyScrollController.addListener(() {
      if (!isLoadingDataHistory &&
          _historyScrollController.position.pixels ==
              _historyScrollController.position.maxScrollExtent) {
          getAllHistoryMatches();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Favorite Matches",
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTileWidget(
              title: "Favorite teams result history",
              onOpenExpansion: errorHistory != null ? (){} : favoriteMatchesListHistory.isNotEmpty ? (){} : getAllHistoryMatches,
              children: [
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6
                    ),
                    width: double.infinity,
                    child: defaultSkeleton(
                      context: context,
                      loadState: matchHistoryState,
                      loadingWidget: matchSkeleton(context: context, listLength: 15),
                      errorWidget: ErrorPage(errorText: errorHistory, onPressed: (){
                        setState(() {
                          errorHistory = null;
                          matchHistoryState = DataLoadState.loading;
                        });
                        getAllHistoryMatches();
                      }),
                      dataWidget: favoriteMatchesListHistory.isNotEmpty
                          ? SingleChildScrollView(
                        controller: _historyScrollController,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            ...List.generate(
                                favoriteMatchesListHistory.length + (isLoadingDataHistory ? 1 : 0),
                                    (int i) {
                                  if (i < favoriteMatchesListHistory.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5),
                                      child: MatchCardWidget(
                                        onTap: () => navigateToMatchPrediction(
                                            matchInfo: favoriteMatchesListHistory[i],
                                            matchId: favoriteMatchesListHistory[i].id,
                                            context: context),
                                        homeTeamName:
                                        "${favoriteMatchesListHistory[i].homeTeam?.name}",
                                        awayTeamName:
                                        "${favoriteMatchesListHistory[i].awayTeam?.name}",
                                        homeTeamImage:
                                        "${favoriteMatchesListHistory[i].homeTeam?.imgUrl}",
                                        awayTeamImage:
                                        "${favoriteMatchesListHistory[i].awayTeam?.imgUrl}",
                                        homeTeamScore:
                                        favoriteMatchesListHistory[i].homeTeamScore,
                                        awayTeamScore:
                                        favoriteMatchesListHistory[i].awayTeamScore,
                                        date: convertToDateTime(
                                            favoriteMatchesListHistory[i].matchDate,
                                            favoriteMatchesListHistory[i].startingAt),
                                        matchStatus: favoriteMatchesListHistory[i].status,
                                        tournamentName: favoriteMatchesListHistory[i].championship!.name,
                                      ),
                                    );
                                  } else {
                                    return const CircularProgressWidget();
                                  }
                                }),
                          ],
                        ),
                      )
                          : const ErrorTextPage(errorText: 'No data found!'),
                    ),
                  )
                ]
            ),
            const SizedBox(height: 20),
            ExpansionTileWidget(
                title: "Upcoming Matches",
                onOpenExpansion: error != null ? (){} : favoriteMatchesList.isNotEmpty ? (){} : getAllMatches,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6
                    ),
                    child: defaultSkeleton(
                      context: context,
                      loadState: matchState,
                      loadingWidget: matchSkeleton(context: context, listLength: 15),
                      errorWidget: ErrorPage(errorText: error, onPressed: (){
                        setState(() {
                          error = null;
                          matchState = DataLoadState.loading;
                        });
                        getAllMatches();
                      }),
                      dataWidget: favoriteMatchesList.isNotEmpty
                          ? SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            ...List.generate(
                                favoriteMatchesList.length + (isLoadingData ? 1 : 0),
                                    (int i) {
                                  if (i < favoriteMatchesList.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5),
                                      child: MatchCardWidget(
                                        onTap: () => navigateToMatchPrediction(
                                            matchInfo: favoriteMatchesList[i],
                                            matchId: favoriteMatchesList[i].id,
                                            context: context),
                                        homeTeamName:
                                        "${favoriteMatchesList[i].homeTeam?.name}",
                                        awayTeamName:
                                        "${favoriteMatchesList[i].awayTeam?.name}",
                                        homeTeamImage:
                                        "${favoriteMatchesList[i].homeTeam?.imgUrl}",
                                        awayTeamImage:
                                        "${favoriteMatchesList[i].awayTeam?.imgUrl}",
                                        homeTeamScore:
                                        favoriteMatchesList[i].homeTeamScore,
                                        awayTeamScore:
                                        favoriteMatchesList[i].awayTeamScore,
                                        date: convertToDateTime(
                                            favoriteMatchesList[i].matchDate,
                                            favoriteMatchesList[i].startingAt),
                                        matchStatus: favoriteMatchesList[i].status,
                                        tournamentName: favoriteMatchesList[i].championship!.name,
                                      ),
                                    );
                                  } else {
                                    return const CircularProgressWidget();
                                  }
                                }),
                          ],
                        ),
                      )
                          : const ErrorTextPage(errorText: 'No data found!'),
                    ),
                  )
                ]
            )
          ],
        ),
      ),
    );
  }

  getAllMatches() async {
      if (!isLoadingData && !dataFinishedOnScroll) {
        setState(() {
          isLoadingData = true;
        });
        Response response = await _matchProvider?.getFavoriteMatches(
            page: page,
            limit: limit,
            dateFrom: DateTime.now().toString(),
            dateTo: DateTime.now().add(const Duration(days: 7)).toString());

        if (response.statusCode != null &&
            (response.statusCode! >= 200 && response.statusCode! <= 399)) {
          List<dynamic> res = response.data['data'];
          List<MatchModel> tempMatchesList =
              res.map((e) => MatchModel.fromJson(e)).toList();
          favoriteMatchesList.addAll(tempMatchesList);

          if (tempMatchesList.length < limit) {
            dataFinishedOnScroll = true;
          }

          matchState = DataLoadState.loaded;
          setState(() {
            page++;
            favoriteMatchesList;
            matchState;
            error;
            isLoadingData = false;
          });
        } else {
          if (page == 1) {
            error = response.data['message'];
            matchState = DataLoadState.error;
          } else {
            appSnackBar(
                context: context, msg: response.data['message'], isError: true);
          }
          setState(() {
            favoriteMatchesList;
            matchState;
            error;
            isLoadingData = false;
          });
        }
      }
  }
  getAllHistoryMatches() async {
      if (!isLoadingDataHistory && !dataHistoryFinishedOnScroll) {
        setState(() {
          isLoadingDataHistory = true;
        });
        Response response = await _matchProvider?.getFavoriteMatches(
            page: pageHistory,
            limit: limitHistory,
            dateTo: DateTime.now().subtract(Duration(days: 1)).toString());

        if (response.statusCode != null &&
            (response.statusCode! >= 200 && response.statusCode! <= 399)) {
          List<dynamic> res = response.data['data'];
          List<MatchModel> tempMatchesList =
              res.map((e) => MatchModel.fromJson(e)).toList();
          favoriteMatchesListHistory.addAll(tempMatchesList);

          if (tempMatchesList.length < limitHistory) {
            dataHistoryFinishedOnScroll = true;
          }

          matchHistoryState = DataLoadState.loaded;
          setState(() {
            pageHistory++;
            favoriteMatchesListHistory;
            matchHistoryState;
            errorHistory;
            isLoadingDataHistory = false;
          });
        } else {
          if (pageHistory == 1) {
            errorHistory = response.data['message'];
            matchHistoryState = DataLoadState.error;
          } else {
            appSnackBar(
                context: context, msg: response.data['message'], isError: true);
          }
          setState(() {
            favoriteMatchesListHistory;
            matchHistoryState;
            errorHistory;
            isLoadingDataHistory = false;
          });
        }
      }
  }
}
