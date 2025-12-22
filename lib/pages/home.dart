import 'dart:async';
import 'dart:convert';
import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/functions.dart';
import 'package:ahzir/functions/user.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/models/model/article_model.dart';
import 'package:ahzir/models/model/championship_model.dart';
import 'package:ahzir/models/model/content_management_model.dart';
import 'package:ahzir/models/model/leaderboard_model.dart';
import 'package:ahzir/models/model/level_model.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:ahzir/models/model/tournament_model.dart';
import 'package:ahzir/models/model/user_model.dart';
import 'package:ahzir/pages/articles/articles.dart';
import 'package:ahzir/pages/favorites/favorite_team_matches.dart';
import 'package:ahzir/pages/match/daily_challenges.dart';
import 'package:ahzir/pages/match/matches_page.dart';
import 'package:ahzir/pages/tournaments/tournament_matches.dart';
import 'package:ahzir/pages/tournaments/tournaments.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/article_view_model.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/view-model/championship_view_model.dart';
import 'package:ahzir/view-model/leaderboard_view_model.dart';
import 'package:ahzir/view-model/level_view_model.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/cards/card_widget.dart';
import 'package:ahzir/widgets/cards/match_card_widget.dart';
import 'package:ahzir/widgets/carousel/carousel_widget.dart';
import 'package:ahzir/widgets/commun/shared/item_content.dart';
import 'package:ahzir/widgets/daily_challenge/daily_challenge_dialog.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/inventory/lantern_info_dialog.dart';
import 'package:ahzir/widgets/leaderboard/leaderboard_widget.dart';
import 'package:ahzir/widgets/level/level_up.dart';
import 'package:ahzir/widgets/level/show_user_level_details_dialog.dart';
import 'package:ahzir/widgets/level/user_level.dart';
import 'package:ahzir/widgets/news/news_widget.dart';
import 'package:ahzir/widgets/profile/profile_dialog.dart';
import 'package:ahzir/widgets/scroll_view/scrolls.dart';
import 'package:ahzir/widgets/teams/teams_match_widget.dart';
import 'package:ahzir/widgets/text_with_icon.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _favoriteController = ScrollController();
  MatchViewModel? matchProvider;
  ChampionshipViewModel? _championshipProvider;
  LeaderboardViewModel? _leaderboardViewModel;
  ArticleViewModel? _articleProvider;
  LevelViewModel? _levelProvider;
  AuthViewModel? _authProvider;
  StoreViewModel? _storeProvider;
  int _currentIndex = 0;
  final int itemCount = 8; // Total number of items
  int _page = 1;
  int limit = 3;
  int _pageTournament = 1;
  int limitTournament = 50;
  List<MatchModel> upcomingMatches = [];
  MatchModel? liveMatch;
  List<TournamentModel> tournamentsList = [];
  List<MatchModel> favoriteMatches = [];
  DataLoadState favoriteState = DataLoadState.loading;
  String? errorFavoriteMsg;
  List<bool> isFavorite = [false, false, false];
  DataLoadState upcomingMatchesState = DataLoadState.loading;
  String? errorUpcomingMsg;
  DataLoadState tournamentState = DataLoadState.loading;
  String? errorTournamentMsg;
  DataLoadState liveMatchesState = DataLoadState.loading;
  String? errorLiveMatchMsg;
  DataLoadState leaderboardState = DataLoadState.loading;
  String? errorLeaderboard;
  bool isAllError = false;
  Timer? _debounce;
  int? currentLeaderBoardIndex;
  late InfiniteScrollController controller;
  List<List<LeaderBoardModel>> leaderboard = [];
  List<ArticleModel> articles = [];
  DataLoadState articlesState = DataLoadState.loading;
  String? errorArticles;
  LevelModel? userLevel;
  // FlutterSecureStorage storage = FlutterSecureStorage();
  late SharedPreferences prefs;
  late LevelModel userLvlDetails;
  bool isNewLevel = false;
  UserModel? user;
  List<LevelModel> allLevels = [];
  ContentManagementModel? lanternContent;
  List<StoreModel> lanternList = [];


  @override
  void initState() {
    controller = InfiniteScrollController();
    matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    _levelProvider = Provider.of<LevelViewModel>(context, listen: false);
    _articleProvider = Provider.of<ArticleViewModel>(context, listen: false);
    _championshipProvider =
        Provider.of<ChampionshipViewModel>(context, listen: false);
    _leaderboardViewModel =
        Provider.of<LeaderboardViewModel>(context, listen: false);
    _authProvider =
        Provider.of<AuthViewModel>(context, listen: false);
    _storeProvider = Provider.of<StoreViewModel>(context, listen: false);
    getAllData();
    checkDailyChallenges();
    checkUserDetailsFromPrefs();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: whiteColor,
      onRefresh: getAllData,
      child: Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset("$staticImgUrl/logo/ihzar.svg"),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          // actions: [
          //   userLevel != null ? UserLevel(
          //     level: userLevel!,
          //     user: user,
          //     onTap: () => showUserLevelDetailsDialog(context: context, level: userLevel!, user: user!),
          //   ) : Container()
          // ],
        ),
        body: !isAllError
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('$staticImgUrl/stadium.png'),
                    // Replace with your image path
                    fit: BoxFit
                        .cover, // This ensures the image covers the entire container
                  ),
                ),
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defaultSkeleton(
                          context: context,
                          loadState: liveMatchesState,
                          loadingWidget: liveMatchSkeleton(context: context),
                          errorWidget:
                              ErrorTextPage(errorText: errorLiveMatchMsg),
                          dataWidget: liveMatch != null
                              ? Column(
                                  children: [
                                    liveMatch?.campaign != null
                                        ? CarouselWidget(
                                            imgList: [liveMatch?.campaign?.prize],
                                            autoPlay: true,
                                            onTap: (index) =>
                                                debugPrint("index: $index"),
                                          )
                                        : Container(),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: GestureDetector(
                                        onTap: () => navigateToMatchPrediction(
                                            matchInfo: liveMatch!,
                                            matchId: liveMatch!.id,
                                            context: context,
                                            onComplete: () => checkLevelIfUserLoggedIn(),
                                        ),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 130,
                                          decoration: BoxDecoration(
                                              border: GradientBoxBorder(
                                                  gradient: blueMauveLinearGrad,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "$staticImgUrl/football_live.jpg"),
                                                  fit: BoxFit.cover,
                                                  opacity: 0.1)),
                                          child: liveMatch != null
                                              ? TeamsMatchLive(
                                                  homeTeamName:
                                                      liveMatch!.homeTeam!.name!,
                                                  awayTeamName:
                                                      liveMatch!.awayTeam!.name!,
                                                  homeTeamImage: liveMatch!
                                                      .homeTeam!.imgUrl!,
                                                  awayTeamImage: liveMatch!
                                                      .awayTeam!.imgUrl!,
                                                  homeTeamScore:
                                                      liveMatch!.homeTeamScore,
                                                  awayTeamScore:
                                                      liveMatch!.awayTeamScore,
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: leaderboard.isNotEmpty &&
                                          leaderboard[
                                                  currentLeaderBoardIndex ?? 0][0]
                                              .leaderboardResults!
                                              .isNotEmpty
                                      ? [
                                          Center(
                                            child: LeaderboardWidget(
                                                leaderboard:
                                                    currentLeaderBoardIndex !=
                                                            null
                                                        ? leaderboard[
                                                            currentLeaderBoardIndex!]
                                                        : leaderboard[0]),
                                          ),
                                        ]
                                      : [
                                          Container(
                                              height: 260,
                                              child: errorLeaderboard != null
                                                  ? ErrorTextPage(
                                                      errorText: errorLeaderboard,
                                                      widget: SvgPicture.asset('$staticImgUrl/leader.svg', width: 300, height: 180))
                                                  : leaderboardState ==
                                                          DataLoadState.loaded
                                                      ? ErrorTextPage(
                                                          errorText:
                                                              'No results yet!',
                                                          widget: SvgPicture.asset('$staticImgUrl/leader.svg', width: 300, height: 180))
                                                      : Container())
                                        ],
                                ),
                        ),
                        const SizedBox(height: 20),
                        TextWithIcon(
                            text: 'Ongoing Tournaments',
                            icon: Icon(Icons.arrow_forward_ios,
                                color: whiteColor, size: 20),
                            onPressed: () =>
                                nextScreen(context, const Tournaments())),
                        const SizedBox(height: 20),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            padding: const EdgeInsets.only(right: 10),
                            child: defaultSkeleton(
                                context: context,
                                loadState: tournamentState,
                                dataWidget: checkIfDataListEmpty(
                                    data: tournamentsList,
                                    widget: SizedBox(
                                      height: 120,
                                      child: tournamentsList.length > 0
                                          ? InfiniteCarousel.builder(
                                              itemCount: tournamentsList.length,
                                              itemExtent: 160,
                                              center: false,
                                              anchor: 0.0,
                                              loop: tournamentsList.length > 8 ? true : false,
                                              // velocityFactor: 0.5,
                                              onIndexChanged: (index) {
                                                if (findTournamentIndex(
                                                        tournamentsList[index].id,
                                                        leaderboard) !=
                                                    null) {
                                                  currentLeaderBoardIndex =
                                                      findTournamentIndex(
                                                          tournamentsList[index]
                                                              .id,
                                                          leaderboard);
                                                } else {
                                                  getLeaderboardPerTournament(
                                                      tournamentsList[index]);
                                                }
                                                setState(() {
                                                  currentLeaderBoardIndex;
                                                  _currentIndex = index;
                                                });
                                              },
                                              controller:
                                                  tournamentsList.length > 2
                                                      ? controller
                                                      : null,
                                              axisDirection: Axis.horizontal,
                                              itemBuilder: (context, itemIndex,
                                                  realIndex) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: itemIndex ==
                                                              _currentIndex
                                                          ? 0.0
                                                          : 10),
                                                  child: CardWidget(
                                                    tournament: tournamentsList[itemIndex],
                                                    onTap: () => nextScreen(
                                                        context,
                                                        TournamentMatches(
                                                          tournamentId:
                                                              tournamentsList[
                                                                      itemIndex]
                                                                  .id,
                                                        )),
                                                    index: itemIndex,
                                                    currentIndex: _currentIndex,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(),
                                    )),
                                errorWidget: ErrorTextPage(
                                    errorText: errorTournamentMsg, staticImgWidth: 200),
                                loadingWidget:
                                    tournamentCardSkeleton(context: context))),
                        favoriteState == DataLoadState.loaded
                            ? Column(
                                children: [
                                  Padding(
                                    //favorites list
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: TextWithIcon(
                                        text: 'Favorite Matches',
                                        icon: Icon(Icons.arrow_forward_ios,
                                            color: whiteColor, size: 20),
                                        onPressed: () => nextScreen(context,
                                            const FavoriteTeamMatches())),
                                  ),
                                  const SizedBox(height: 20),
                                  verticalScroll(
                                      context: context,
                                      controller: _favoriteController,
                                      widget: [
                                        checkIfDataListEmpty(
                                            data: favoriteMatches,
                                            widget: Column(
                                              children: List.generate(
                                                  favoriteMatches.length,
                                                  (int i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 20.0,
                                                          vertical: 5),
                                                  child: MatchCardWidget(
                                                    onTap: () =>
                                                        navigateToMatchPrediction(
                                                            matchInfo:
                                                                favoriteMatches[
                                                                    i],
                                                            matchId:
                                                                favoriteMatches[i]
                                                                    .id,
                                                            context: context,
                                                            onComplete: () => checkLevelIfUserLoggedIn(),
                                                        ),
                                                    homeTeamName:
                                                        "${favoriteMatches[i].homeTeam?.name}",
                                                    awayTeamName:
                                                        "${favoriteMatches[i].awayTeam?.name}",
                                                    homeTeamImage:
                                                        "${favoriteMatches[i].homeTeam?.imgUrl}",
                                                    awayTeamImage:
                                                        "${favoriteMatches[i].awayTeam?.imgUrl}",
                                                    date: convertToDateTime(
                                                        favoriteMatches[i]
                                                            .matchDate,
                                                        favoriteMatches[i]
                                                            .startingAt),
                                                    matchStatus:
                                                        favoriteMatches[i].status,
                                                    homeTeamScore:
                                                        favoriteMatches[i]
                                                            .homeTeamScore,
                                                    awayTeamScore:
                                                        favoriteMatches[i]
                                                            .awayTeamScore,
                                                    tournamentName: favoriteMatches[i].championship!.name,
                                                  ),
                                                );
                                              }),
                                            ))
                                      ])
                                ],
                              )
                            : Container(),
                        const SizedBox(height: 30),
                        TextWithIcon(
                            text: 'Upcoming Matches',
                            icon: Icon(Icons.arrow_forward_ios,
                                color: whiteColor, size: 20),
                            onPressed: () =>
                                nextScreen(context, const MatchesPage())),
                        const SizedBox(height: 20),
                        verticalScroll(context: context, widget: [
                          defaultSkeleton(
                            context: context,
                            loadState: upcomingMatchesState,
                            loadingWidget:
                                matchSkeleton(context: context, listLength: 3),
                            errorWidget:
                                ErrorTextPage(errorText: errorUpcomingMsg),
                            dataWidget: checkIfDataListEmpty(
                                data: upcomingMatches,
                                widget: Column(
                                  children: List.generate(upcomingMatches.length,
                                      (int i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5),
                                      child: MatchCardWidget(
                                        onTap: () => navigateToMatchPrediction(
                                            matchInfo: upcomingMatches[i],
                                            matchId: upcomingMatches[i].id,
                                            onComplete: () => checkLevelIfUserLoggedIn(),
                                            context: context),
                                        homeTeamName:
                                            "${upcomingMatches[i].homeTeam?.name}",
                                        awayTeamName:
                                            "${upcomingMatches[i].awayTeam?.name}",
                                        homeTeamImage:
                                            "${upcomingMatches[i].homeTeam?.imgUrl}",
                                        awayTeamImage:
                                            "${upcomingMatches[i].awayTeam?.imgUrl}",
                                        date: convertToDateTime(
                                            upcomingMatches[i].matchDate,
                                            upcomingMatches[i].startingAt),
                                        matchStatus: upcomingMatches[i].status,
                                        homeTeamScore:
                                            upcomingMatches[i].homeTeamScore,
                                        awayTeamScore:
                                            upcomingMatches[i].awayTeamScore,
                                        tournamentName: upcomingMatches[i].championship!.name,
                                      ),
                                    );
                                  }),
                                )),
                          ),
                        ]),
                        const SizedBox(height: 30),
                        TextWithIcon(
                            text: 'Top News',
                            icon: Icon(Icons.arrow_forward_ios,
                                color: whiteColor, size: 20),
                            onPressed: () => nextScreen(context, Articles())),
                        const SizedBox(height: 20),
                        defaultSkeleton(
                          context: context,
                          loadState: articlesState,
                          loadingWidget: matchSkeleton(context: context, listLength: 3),
                          errorWidget:
                          ErrorTextPage(errorText: errorArticles),
                          dataWidget: checkIfDataListEmpty(
                              data: articles,
                              edgeInsets: const EdgeInsets.symmetric(horizontal: 20),
                              widget: Column(
                                children: List.generate(articles.length, (int i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5),
                                    child: NewsWidget(
                                      title: articles[i].title,
                                      image: articles[i].mediaCover,
                                      date: articles[i].articleDate,
                                      onTap: () => nextScreen(context, ItemContent(notificationId: null, article: articles[i])),
                                      // onFavoriteTap: () {
                                      //   addOrRemoveFavorite();
                                      //   setState(() {
                                      //     isFavorite[i] = !isFavorite[i];
                                      //   });
                                      // },
                                      // isFavorite: isFavorite[i],
                                    ),
                                  );
                                }),
                              )
                          ),
                        ),
                        // const SizedBox(height: 30),
                        // TextWithIcon(
                        //     text: 'Special Events',
                        //     icon: Icon(Icons.arrow_forward_ios,
                        //         color: whiteColor, size: 20),
                        //     onPressed: () {}),
                        // const SizedBox(height: 20),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 20),
                        //   child: horizontalScroll(
                        //       context: context,
                        //       widget: List.generate(3, (int i) {
                        //         return const Padding(
                        //           padding: EdgeInsets.only(left: 8.0),
                        //           child: EventWidget(),
                        //         );
                        //       })),
                        // ),
                      ],
                    )),
              )
            : ErrorPage(onPressed: () {
                setState(() {
                  isAllError = false;
                  tournamentState = DataLoadState.loading;
                  upcomingMatchesState = DataLoadState.loading;
                  liveMatchesState = DataLoadState.loading;
                  articlesState = DataLoadState.loading;
                  errorUpcomingMsg = null;
                  errorTournamentMsg = null;
                  errorLiveMatchMsg = null;
                  errorArticles = null;
                  getAllData();
                });
              }),
      ),
    );
  }

  Future<void> getAllData() async {
    var responses = await Future.wait<dynamic>([
      matchProvider?.getMatches(
          page: _page,
          limit: limit,
          dateFrom: DateTime.now().toString(),
          dateTo: DateTime.now().add(const Duration(days: 7)).toString()),
      _championshipProvider?.getTournaments(
          limit: limitTournament, page: _pageTournament),
      matchProvider?.getLiveMatch(),
      matchProvider?.getFavoriteMatches(
          page: 1,
          limit: 3,
          dateFrom: DateTime.now().toString(),
          dateTo: DateTime.now().add(const Duration(days: 7)).toString()),
      _articleProvider?.getArticles(context: context, page: 1, limit: 3),
      // _levelProvider?.getUserLevel(),
      _authProvider?.getContentManagement(),
      _storeProvider?.getStore(page: 1, limit: 10, campaignName: null),
      // _leaderboardViewModel?.getLeaderboardPerTournament(id: id)
    ]);
    var matchesRes = matchProvider
        ?.getMatchesFromResponse(responses[0]); //get the matches response
    var tournamentsRes = _championshipProvider
        ?.getTournamentsFromResponse(responses[1]); //get the matches response
    var liveMatchRes = matchProvider
        ?.getLiveMatchFromResponse(responses[2]); //get the matches response
    var favTeamMatches = matchProvider?.getMatchesFromResponse(
        responses[3]); //get the favorite team matches response
    var articleNews = _articleProvider?.getArticlesFromResponse(responses[4]);
    // var lanternCms = getContent(responses[6]);
    var lanternsList = getDataLanterns(responses[6]);
    handleResponse<List<MatchModel>>(
      response: matchesRes,
      updateState: (state) => upcomingMatchesState = state,
      updateError: (error) => errorUpcomingMsg = error,
      updateData: (data) => upcomingMatches = data ?? [],
    );
    handleResponse<List<TournamentModel>>(
      response: tournamentsRes,
      updateState: (state) => tournamentState = state,
      updateError: (error) => errorTournamentMsg = error,
      updateData: (data) => tournamentsList = data ?? [],
    );
    handleResponse<MatchModel>(
      response: liveMatchRes,
      updateState: (state) => liveMatchesState = state,
      updateError: (error) => errorLiveMatchMsg = error,
      updateData: (data) => liveMatch = data,
    );
    handleResponse<List<MatchModel>>(
      response: favTeamMatches,
      updateState: (state) => favoriteState = state,
      updateError: (error) => errorFavoriteMsg = error,
      updateData: (data) => favoriteMatches = data ?? [],
    );

    handleResponse<List<ArticleModel>>(
      response: articleNews,
      updateState: (state) => articlesState = state,
      updateError: (error) => errorArticles = error,
      updateData: (data) => articles = data ?? [],
    );

    // cmsHandle<List<ContentManagementModel>>(
    //   response: lanternCms,
    //   updateData: (data) {
    //     if(data != null || data != []) {
    //       lanternContent = data!.any((item) => item.code == 'lanternDescription')
    //           ? data.firstWhere((item) => item.code == 'lanternDescription')
    //           : null;
    //     }
    //   },
    // );
    cmsHandle<List<StoreModel>>(
      response: lanternsList,
      updateData: (data) => lanternList = data ?? [],
    );

    // if(responses[5].statusCode != null && responses[5].statusCode >= 200 && responses[5].statusCode <= 399){
    //   userLevel = LevelModel.fromJson(responses[5].data);
    //   // allLevels = (responses[5].data as List).map((allLevels) => LevelModel.fromJson(allLevels)).toList();
    //   checkAndSaveUserLevel(userLvl: userLevel);
    // }

    if (tournamentsList.isNotEmpty) {
      getLeaderboardPerTournament(tournamentsList[0]);
    }

    if (errorUpcomingMsg != null &&
        errorTournamentMsg != null &&
        errorLiveMatchMsg != null &&
        errorFavoriteMsg != null &&
        errorArticles != null) {
      //check if all the endpoints returns error so we display the error page;
      isAllError = true;
    }

    checkAndShowLanternDialog(context, lanternList, lanternContent);

    setState(() {
      tournamentsList;
      upcomingMatches;
      liveMatch;
      favoriteMatches;
      articles;
      upcomingMatchesState;
      tournamentState;
      liveMatchesState;
      favoriteState;
      errorUpcomingMsg;
      errorTournamentMsg;
      errorLiveMatchMsg;
      errorFavoriteMsg;
      errorArticles;
      isAllError;
      // userLevel;
    });
  }

  getLeaderboardPerTournament(TournamentModel tournament) async {
    if (!leaderboard
        .expand((innerList) => innerList)
        .any((model) => model.championship?.id == tournament.id)) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 50), () {
        setState(() {
          leaderboardState = DataLoadState.loading;
          errorLeaderboard = null;
        });
      });
      Response response = await _leaderboardViewModel
          ?.getLeaderboardPerTournament(id: tournament.id);
      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> res = response.data['data'];
        List<LeaderBoardModel> tempLeaderboard =
            res.map((e) => LeaderBoardModel.fromJson(e)).toList();
        if (tempLeaderboard.isNotEmpty) {
          leaderboard.add(tempLeaderboard);
        } else {
          leaderboard.add([
            LeaderBoardModel(
                campaign: null,
                championship: ChampionshipModel(
                    id: tournament.id,
                    name: tournament.name,
                    code: null,
                    icon: null,
                    tier: null),
                leaderboardResults: [])
          ]);
        }
        leaderboardState = DataLoadState.loaded;
        errorLeaderboard = null;
        currentLeaderBoardIndex =
            findTournamentIndex(tournament.id, leaderboard);
      } else {
        leaderboardState = DataLoadState.error;
        errorLeaderboard = response.data['message'];
      }
      setState(() {
        leaderboardState;
        leaderboard;
        errorLeaderboard;
        currentLeaderBoardIndex;
      });
    } else {
      if (leaderboardState != DataLoadState.loaded) {
        setState(() {
          leaderboardState = DataLoadState.loaded;
          errorLeaderboard = null;
        });
      }
    }
  }

  int? findTournamentIndex(
      int tournamentId, List<List<LeaderBoardModel>> leaderboard) {
    for (int outerIndex = 0; outerIndex < leaderboard.length; outerIndex++) {
      // Check the inner list for the matching tournamentId
      int innerIndex = leaderboard[outerIndex].indexWhere((model) {
        return model.championship?.id ==
            tournamentId; // Assuming campaign.id is the tournamentId
      });

      if (innerIndex != -1) {
        // If found, you can return a combined index or a tuple
        // debugPrint('Found at outerIndex: $outerIndex, innerIndex: $innerIndex');
        return outerIndex; // Return the outerIndex, or both indices if needed
      }
    }
    return null; // If not found
  }

  addOrRemoveFavorite() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {});
  }

  // getUserLvl() async{
  //   Response response = await _levelProvider?.getUserLevel();
  //   if(response.statusCode != null && response.statusCode! >= 200 && response.statusCode! <= 399){
  //     setState(() {
  //       userLevel = LevelModel.fromJson(response.data);
  //       checkAndSaveUserLevel(userLvl: userLevel);
  //     });
  //   }
  // }

  checkAndSaveUserLevel({LevelModel? userLvl}) async{
    prefs = await SharedPreferences.getInstance();
    var lvlUser = await prefs.getString('userLevel');
    user = await getUserDetails();
    if(lvlUser != null) {
      // debugPrint("leveluserrrrrrrrr: ${userLvl?.id}");
      Map<String, dynamic> decodedLvlUser = jsonDecode(lvlUser);
      userLvlDetails = LevelModel.fromJson(decodedLvlUser);
      if(userLvlDetails.minPoints != userLvl?.minPoints){
        isNewLevel = true;
        showLevelUpDialog(context: context, level: userLvl!);
      }
    }
    String? level = jsonEncode(userLvl?.toJson());
    await prefs.setString('userLevel', level);
  }

  checkDailyChallenges() async{
    prefs = await SharedPreferences.getInstance();
    // await storage.delete(key: 'daily_challenge_date');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final savedDate = await prefs.getString('daily_challenge_date');
    if (savedDate != today) {

      Response response = await matchProvider?.dailyMatches(limit: 1, page: 1);
      if (response.statusCode != null && response.statusCode! >= 200 &&
          response.statusCode! <= 399) {
        List matchesDaily = response.data['data'];
        List<MatchModel> dailyMatches = matchesDaily.map((match) =>
            MatchModel.fromJson(match)).toList();
        if(dailyMatches.isNotEmpty){
          // New day: save the new date so it will be displayed once a day
          await prefs.setString('daily_challenge_date', today);
        }
        if (dailyMatches.isNotEmpty) {
          dailyChallengeDialog(
            context: context,
            title: 'Daily Challenge!',
            body: '${'Ready for a win?'
                .tr()} \n${"Enter today's challenge for points and prizes!"
                .tr()}',
            onTapSkip: () => Navigator.pop(context),
            onTapNext: () {
              Navigator.pop(context);
              nextScreen(context, DailyChallenges());
            },
          );
        }
      }
    }
  }

  checkLevelIfUserLoggedIn() async{
    // bool isLoggedIn = await checkUserIfLoggedIn();
    // if(userLevel == null && isLoggedIn){
    //   getUserLvl();
    // }
    return await checkUserIfLoggedIn();
  }

  void checkAndShowLanternDialog(BuildContext context, List<StoreModel> lanternList, ContentManagementModel? lanternContent) async {
    if (lanternContent != null && lanternList.isNotEmpty) {
      bool show = await shouldShowDialog();
      if (show) {
        lanternInfoDialog(context, lanternList, lanternContent);
        await saveDialogOpenedDate();
      }
    }
  }

  Future<void> saveDialogOpenedDate() async {
    prefs = await SharedPreferences.getInstance();
    String todayString = DateTime.now().toIso8601String();
    await prefs.setString('lantern_dialog_last_shown', todayString);
  }

  Future<bool> shouldShowDialog() async {
    String? lastShown = await prefs.getString('lantern_dialog_last_shown');
    if (lastShown == null) return true; // never shown before

    DateTime lastShownDate = DateTime.parse(lastShown);
    final difference = DateTime.now().difference(lastShownDate);

    // Show only if more than 24h passed
    return difference.inHours >= 24;
  }

  checkUserDetailsFromPrefs() async{
    prefs = await SharedPreferences.getInstance();
    user = await getUserDetails();
    if(user?.phone == null || user?.phone == ''){
      showProfileDialog(
        context: context,
        user: user,
        onSave: (updatedUser) async {
          var data = {
            "phone": updatedUser.phone,
            "firstName": updatedUser.firstName,
            "lastName": updatedUser.lastName,
          };
          Response response = await _authProvider?.updateUserDetails(context: context, data: data);
          if(response.statusCode != null && response.statusCode! >= 200 && response.statusCode! <= 399){
            if (mounted) {
              await prefs.setString('userInfo', jsonEncode(updatedUser.toJson()));
              // Reload user from prefs to ensure it's updated in memory
              Navigator.of(context).pop();
              appSnackBar(context: context, msg: 'Profile updated successfully!');
            }
          }
        },
      );
    }
  }

}
