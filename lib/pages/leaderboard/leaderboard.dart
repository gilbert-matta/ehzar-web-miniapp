import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/functions.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/hexColor/hex_color.dart';
import 'package:ahzir/models/model/configuration_model.dart';
import 'package:ahzir/models/model/lantern_model.dart';
import 'package:ahzir/models/model/leaderboard_user_result_model.dart';
import 'package:ahzir/models/model/matchday_model.dart';
import 'package:ahzir/models/model/tournament_model.dart';
import 'package:ahzir/models/model/user_model.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/championship_view_model.dart';
import 'package:ahzir/view-model/leaderboard_view_model.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/cards/card_widget.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/date_switcher_widget.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/lantern/lantern_widget_selection.dart';
import 'package:ahzir/widgets/leaderboard/first_three_leaderboard.dart';
import 'package:ahzir/widgets/leaderboard/leaderboard_banner.dart';
import 'package:ahzir/widgets/leaderboard/leaderboard_ranking_details.dart';
import 'package:ahzir/widgets/leaderboard/leaderboard_ranks.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:provider/provider.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> with TickerProviderStateMixin {
  TabController? _tabController;

  // Maps to store data for each leaderboard type
  Map<String, DataLoadState> leaderboardStates = {};
  Map<String, String?> leaderboardErrors = {};
  Map<String, ScrollController> scrollControllers = {};
  Map<String, List<LeaderboardUserResultModel>> leaderboards = {};
  Map<String, bool> _isLoadingData = {};
  Map<String, bool> _dataFinishedOnScroll = {};
  Map<String, int> _pages = {};

  LeaderboardViewModel? _leaderboardProvider;
  ChampionshipViewModel? _championshipProvider;
  StoreViewModel? _storePackageProvider;
  int limit = 10;
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month - 1, 1); //by default show the previous month
  int tournamentIndex = 0;
  List<ConfigurationModel> configurationTypes = [];
  // Store active configuration types
  List<ConfigurationModel> activeConfigurationTypes = [];
  String? configurationTypesError;
  DataLoadState configurationState = DataLoadState.loading;
  bool _isLoadingDataTournament = false;
  bool _dataFinishedOnScrollTournament = false;
  bool _isLoadingDataMatchDay = false;
  bool _dataFinishedOnScrollMatchDay = false;
  int _pageTournament = 1;
  int limitTournament = 50;
  int _pageMatchDay = 1;
  int limitMatchDay = 10;
  List<TournamentModel> tournaments = [];
  List<MatchDayModel> matchDays = [];
  int matchdayIndex = 0;
  int matchdayTotal = 0;
  int lanternIndex = 0;
  ScrollController _scrollController = ScrollController();
  late InfiniteScrollController controller;
  String? tournamentsError;
  DataLoadState tournamentsState = DataLoadState.loading;

  bool _isLoadingDataOverAll = false;
  bool _dataFinishedOnScrollOverAll = false;
  int _pageOverAll = 1;
  int limitOverAll = 10;
  DataLoadState leaderboardOverAllState = DataLoadState.loading;
  List<UserModel> leaderboardOverAll = [];
  List<LeaderboardUserResultModel> firstThreeLeaderboard = [];
  String? leaderboardOverAllError;
  // Add this variable at the top with other state variables
  String? _currentMonthlyDate;
  Map<String, String> _currentDates = {};
  List<StorePackageModel> lanterns = [];

  void changeMonth(int page) {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + page);
      final formatted = DateFormat('yyyy-MM-dd', 'en').format(currentMonth);    //format like this: 2024-04-23
      // print("current month: $currentMonth");
      // Store the new date immediately
      _currentMonthlyDate = formatted;
      Future.delayed(Duration(milliseconds: 300), (){
        setState(() {
          _isLoadingData[types.monthly.name] = false;
          _dataFinishedOnScroll[types.monthly.name] = false;
          _pages[types.monthly.name] = 1; // Reset page
          leaderboardStates[types.monthly.name] = DataLoadState.loading;
          leaderboards[types.monthly.name]?.clear();
        });
        getLeaderboardByType(type: types.monthly.name, dateSent: formatted);
      });
    });
  }

  @override
  void initState() {

    _leaderboardProvider = Provider.of<LeaderboardViewModel>(context, listen: false);
    _championshipProvider = Provider.of<ChampionshipViewModel>(context, listen: false);
    _storePackageProvider = Provider.of<StoreViewModel>(context, listen: false);
    _currentMonthlyDate = DateFormat('yyyy-MM-dd', 'en').format(currentMonth);
    super.initState();
    controller = InfiniteScrollController();

    _scrollController.addListener(() {
      if (!_isLoadingDataOverAll &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
                if (isMobile(context)) {
                  getLeaderboard();
                }
      }
    });
    // Initialize maps for all possible types
    _initializeDataStructures();

    checkTypes();
    getLeaderboard();
  }

  void _initializeDataStructures() {
    // Initialize data structures for all possible types
    List<String> allTypes = [types.daily.name, types.weekly.name, types.monthly.name, types.yearly.name];

    for (String type in allTypes) {
      leaderboardStates[type] = DataLoadState.loading;
      leaderboardErrors[type] = null;
      scrollControllers[type] = ScrollController();
      leaderboards[type] = [];
      _isLoadingData[type] = false;
      _dataFinishedOnScroll[type] = false;
      _pages[type] = 1; // Start page at 1

      // Add scroll listener for each controller
      scrollControllers[type]!.addListener(() {
        if (!_isLoadingData[type]! &&
            scrollControllers[type]!.position.pixels ==
                scrollControllers[type]!.position.maxScrollExtent) {
                  if (isMobile(context)) {
                    type == types.weekly ? getLeaderboardByType(type: type, lanternId: lanterns[lanternIndex].id) : getLeaderboardByType(type: type);
                  }
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    // Dispose all scroll controllers
    scrollControllers.values.forEach((controller) => controller.dispose());
    _currentDates.clear();
    _currentMonthlyDate = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: whiteColor),
        title: SvgPicture.asset("$staticImgUrl/logo/ihzar.svg", height: 30),
        centerTitle: true,
        bottom: configurationState == DataLoadState.loaded ? PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: whiteColor,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: whiteColor),
              ),
              unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
              tabs: List.generate(activeConfigurationTypes.length, (i){
                return Tab(text: activeConfigurationTypes[i].title.tr());
              }),
            )
        ) : null,
      ),
      body: buildContent(
        dataLoadState: configurationState,
        loadingWidget: inventorySkeleton(context: context),
        errorWidget: ErrorPage(
          errorText: configurationTypesError,
          onPressed: () {
            setState(() {
              configurationTypesError = null;
              configurationState = DataLoadState.loading;
              checkTypes();
            });
          },
        ),
        loadedWidget: TabBarView(
          controller: _tabController,
          children: _buildTabViews(),
        ),
      ),
    );
  }

  // Build tab views based on active configuration types
  List<Widget> _buildTabViews() {
    List<Widget> tabViews = [];

    for (ConfigurationModel config in activeConfigurationTypes) {
      String type = config.title;

      // Add appropriate tab view based on type
      if (type == types.daily.name) {
        tabViews.add(_buildDailyTab());
      } else if (type == types.weekly.name) {
        tabViews.add(_buildWeeklyTab());
      } else if (type == types.monthly.name) {
        tabViews.add(_buildMonthlyTab());
      } else if (type == types.yearly.name) {
        tabViews.add(_buildYearlyTab());
      } else {
        tabViews.add(_buildOverAll());
      }
    }

    return tabViews;
  }

  Widget _buildOverAll() {
    return defaultSkeleton(
      context: context,
      loadState: leaderboardOverAllState,
      loadingWidget: inventorySkeleton(context: context),
      errorWidget: ErrorPage(
        errorText: leaderboardOverAllError,
        onPressed: (){
          setState(() {
            leaderboardOverAll.clear();
            leaderboardOverAllError = null;
            leaderboardOverAllState = DataLoadState.loading;
            getLeaderboard();
          });
        },
      ),
      dataWidget: leaderboardOverAll.isNotEmpty ? SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
              children: [
                Container(
                  height: 210,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: darkBlue09,
                  ),
                  child: FirstThreeLeaderboard(leaderboardUser: firstThreeLeaderboard),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.54,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: leaderboardOverAll.length > 3
                        ? leaderboardOverAll.length - 3 +
                            (_isLoadingDataOverAll && isMobile(context) ? 1 : 0)
                        : 0,
                    itemBuilder: (context, i) {
                      // Show loading spinner at the end (only for mobile)
                      if (_isLoadingDataOverAll &&
                          isMobile(context) &&
                          i == leaderboardOverAll.length - 3) {
                        return const CircularProgressWidget();
                      }

                      final leaderIndex = i + 3;
                      if (leaderIndex < leaderboardOverAll.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: LeaderboardRankingDetails(
                            userName: leaderboardOverAll[leaderIndex].firstName,
                            rank: i + 4,
                            score: leaderboardOverAll[leaderIndex].totalpoints,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // "Load More" Button for non-mobile, if there's more data to load
                if (!isMobile(context) && !_dataFinishedOnScrollOverAll)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: AppButton(
                        width: 150,
                        height: 42,
                        color: secondaryColor,
                        isLoading: _isLoadingDataOverAll,
                        onPressed: _isLoadingDataOverAll ? null : () async => getLeaderboard(),
                        text: 'load more',
                      ),
                    ),
                  ),
              ],
            )

          ],
        ),
      )
    ) : ErrorTextPage(
          errorText: "There is no leaderboard results right now!",
      ),
    );
  }

  Widget _buildDailyTab() {
    String type = types.daily.name;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 30,
          color: tertiaryColor,
          child: Center(child: Text("${getDateByType(type: type)}")),
        ),
        buildContent(
          dataLoadState: leaderboardStates[type]!,
          loadingWidget: Expanded(child: inventorySkeleton(context: context)),
          errorWidget: ErrorPage(
            errorText: leaderboardErrors[type],
            onPressed: () {
              setState(() {
                leaderboardErrors[type] = null;
                leaderboardStates[type] = DataLoadState.loading;
                _pages[types.weekly.name] = 1; // Reset page
                getLeaderboardByType(type: type);
              });
            },
          ),
          loadedWidget: leaderboards[type]!.isNotEmpty
              ? Column(
                children: [
                  LeaderboardRanks(
                          leaderboardFirstThree: leaderboards[type]!,
                          leaderboardBannerTitle: "Daily Leaderboard",
                          controller: scrollControllers[type],
                          itemCount: leaderboards[type]!.length > 3 ? leaderboards[type]!.length - 3 : 0,
                          leaderboards: leaderboards[type]!,
                          isLoadingData: _isLoadingData[type]!,
                  ),

                  // "Load More" Button for non-mobile, if there's more data to load
                  if (!isMobile(context) && !_dataFinishedOnScrollOverAll)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: AppButton(
                          width: 150,
                          height: 42,
                          color: secondaryColor,
                          isLoading: _isLoadingData[type]!,
                          onPressed: _isLoadingData[type]! ? null : () async => getLeaderboardByType(type: type),
                          text: 'load more',
                        ),
                      ),
                    ),

                ],
              ) : Expanded(
                child: showError()
              ),
        ),
      ],
    );
  }

  Widget _buildWeeklyTab() {
    String type = types.weekly.name;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
      child: SingleChildScrollView(
        child: buildContent(
            dataLoadState: tournamentsState,
            loadingWidget: inventorySkeleton(context: context),
            errorWidget: ErrorPage(
              errorText: tournamentsError,
              onPressed: () {
                setState(() {
                  tournamentsError = null;
                  tournamentsState = DataLoadState.loading;
                  getTournaments();
                });
              },
            ),
            loadedWidget: tournaments.isNotEmpty ? Column(
              children: [
                checkIfDataListEmpty(
                    data: tournaments,
                    widget: SizedBox(
                      height: 120,
                      child: InfiniteCarousel.builder(
                        itemCount: tournaments.length,
                        itemExtent: 160,
                        center: false,
                        anchor: 0.0,
                        loop: tournaments.length > 8 ? true : false,
                        // velocityFactor: 0.5,
                        onIndexChanged: (index) {
                          setState(() {
                            tournamentIndex = index;
                            matchDays.clear();
                            _pageMatchDay = 1;
                            _isLoadingDataMatchDay = false;
                            _dataFinishedOnScrollMatchDay = false;
                            _dataFinishedOnScroll[types.weekly.name] = false;
                            _isLoadingData[types.weekly.name] = false;
                            _pages[types.weekly.name] = 1; // Reset page
                            leaderboards[types.weekly.name]?.clear();
                            leaderboardStates[types.weekly.name] = DataLoadState.loading;
                            matchdayIndex = 0;
                          });
                          Future.delayed(Duration(milliseconds: 300), () {
                            findMatchDaysPerTournament(championshipId: tournaments[tournamentIndex].id, leaderboardType: types.weekly.name);
                          });
                        },
                        controller:
                        tournaments.length > 2
                            ? controller
                            : null,
                        axisDirection: Axis.horizontal,
                        itemBuilder: (context, itemIndex,
                            realIndex) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: itemIndex ==
                                    tournamentIndex
                                    ? 0.0
                                    : 10),
                            child: CardWidget(
                              tournament: tournaments[itemIndex],
                              onTap: () {},
                              index: itemIndex,
                              currentIndex: tournamentIndex,
                            ),
                          );
                        },
                      ),
                    )
                ),

                // LANTERNS CAROUSEL - Fixed with proper check
                if (lanterns.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    height: 120,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: lanterns.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final lantern = lanterns[index];
                          return LanternWidgetSelection(
                            lantern: lantern,
                            selectedId: lanterns[lanternIndex].id,
                            onTap: (){
                              setState(() {
                                lanternIndex = index;
                                _isLoadingData[types.weekly.name] = false;
                                _dataFinishedOnScroll[types.weekly.name] = false;
                                _pages[types.weekly.name] = 1; // Reset page
                                _currentDates[type] = matchDays[matchdayIndex].startingDate;
                                Future.delayed(Duration(milliseconds: 300), () {
                                  leaderboards[types.weekly.name]?.clear();
                                  leaderboardStates[types.weekly.name] = DataLoadState.loading;
                                  getLeaderboardByType(type: types.weekly.name, lanternId: lanterns[lanternIndex].id);
                                });
                              });
                            },
                          );
                        }),
                  ),

                const SizedBox(height: 10),
                matchDays.isNotEmpty ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: matchdayIndex > 0 ? whiteColor : greyColor),
                      onPressed:  (){
                        if(matchdayIndex > 0){
                          setState(() {
                            matchdayIndex --;
                            _isLoadingData[types.weekly.name] = false;
                            _dataFinishedOnScroll[types.weekly.name] = false;
                            _pages[types.weekly.name] = 1; // Reset page
                            leaderboardStates[types.weekly.name] = DataLoadState.loading;
                            Future.delayed(Duration(milliseconds: 300), () {
                              leaderboards[types.weekly.name]?.clear();
                              getLeaderboardByType(type: types.weekly.name, lanternId: lanterns[lanternIndex].id);
                            });
                          });
                        }
                      },
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            "${'Round'.tr()} ${matchDays[matchdayIndex].dayNumber}", // matchday number
                            key: ValueKey<String>(DateFormat.yMMMM().format(currentMonth)),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                '${matchDays[matchdayIndex].startingDate}',
                                style: TextStyle(fontSize: fontSize12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '${matchDays[matchdayIndex].endingDate}',
                                style: TextStyle(fontSize: fontSize12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: (matchDays.length - 1 == matchdayIndex && matchDays.length == matchdayTotal) ? greyColor : whiteColor),
                      onPressed: !_isLoadingData[types.weekly.name]! ? () async{
                        // if(!dataFinishedOnScroll[types.weekly.name]! && !isLoadingData[types.weekly.name]!) {
                        if (matchDays.length - 1 == matchdayIndex && matchDays.length < matchdayTotal) {
                          await findMatchDaysPerTournament(
                              championshipId: tournaments[tournamentIndex].id,
                              leaderboardType: types.weekly.name);
                          if(matchDays.length - 1 > matchdayIndex) {
                            setState(() {
                              matchdayIndex++;
                            });
                          }
                        } else if(matchDays.length - 1 > matchdayIndex) {
                          setState(() {
                            matchdayIndex ++;
                            _isLoadingData[types.weekly.name] = false;
                            _dataFinishedOnScroll[types.weekly.name] = false;
                            _pages[types.weekly.name] = 1; // Reset page
                            _currentDates[type] = matchDays[matchdayIndex].startingDate;
                            Future.delayed(Duration(milliseconds: 300), () {
                              leaderboards[types.weekly.name]?.clear();
                              leaderboardStates[types.weekly.name] = DataLoadState.loading;
                              getLeaderboardByType(type: types.weekly.name, lanternId: lanterns[lanternIndex].id);
                            });
                          });
                        }
                        // }
                      } : (){},
                    ),
                  ],
                ) : Container(),
                buildContent(
                  dataLoadState: leaderboardStates[type]!,
                  loadingWidget: inventorySkeleton(context: context),
                  errorWidget: ErrorPage(
                    errorText: leaderboardErrors[type],
                    onPressed: () {
                      setState(() {
                        leaderboardErrors[type] = null;
                        leaderboardStates[type] = DataLoadState.loading;
                        _pages[types.weekly.name] = 1; // Reset page
                        getLeaderboardByType(type: type, lanternId: lanterns[lanternIndex].id);
                      });
                    },
                  ),
                  loadedWidget: leaderboards[type]!.isNotEmpty ? Column(
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: HexColor("#092641"),
                              ),
                              child: FirstThreeLeaderboard(leaderboardUser: leaderboards[type]!),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: LeaderboardBanner(title: "Weekly Leaderboard"),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          SizedBox(
                            height: 350,
                            child: ListView.builder(
                              controller: scrollControllers[type],
                              itemCount: leaderboards[type]!.length > 3 ? leaderboards[type]!.length - 3 + (_isLoadingData[type]! && isMobile(context) ? 1 : 0) : 0,
                              itemBuilder: (context, i) {
                                // var leader = i + 3;
                                // return Padding(
                                //   padding: const EdgeInsets.only(bottom: 8.0),
                                //   child: LeaderboardRankingDetails(
                                //       userName: leaderboards[type]![leader].user!.firstName!,
                                //       rank: i + 4,
                                //       score: leaderboards[type]![leader].score!
                                //   ),
                                // );
                                if (_isLoadingData[type]! &&
                                    isMobile(context) &&
                                    i == leaderboards[type]!.length - 3) {
                                  return const CircularProgressWidget();
                                }

                                final leaderIndex = i + 3;
                                if (leaderIndex < leaderboards[type]!.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: LeaderboardRankingDetails(
                                      userName: leaderboards[type]![leaderIndex].user!.firstName!,
                                      rank: i + 4,
                                      score: leaderboards[type]![leaderIndex].score!,
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          if (!isMobile(context) && !_dataFinishedOnScroll[type]!)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Center(
                                child: AppButton(
                                  width: 150,
                                  height: 42,
                                  color: secondaryColor,
                                  isLoading: _isLoadingData[type]!,
                                  onPressed: _isLoadingData[type]! ? null : () async => getLeaderboardByType(type: type, lanternId: lanterns[lanternIndex].id),
                                  text: 'load more',
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ) : Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: showError(),
                  ),
                ),
              ],
            ) : Container(
              height: MediaQuery.of(context).size.height,
              child: ErrorPageLayout(
                errorText: tournamentsError,
                onPressed: (){
                  getTournamentsAndMatchdays();
                },
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildMonthlyTab() {
    String type = types.monthly.name;
    return Column(
      children: [
        DateSwitcherWidget(
            onPressedBack: () => changeMonth(-1),
            onPressedForward: () => changeMonth(1),
            currentMonth: currentMonth
        ),
        buildContent(
          dataLoadState: leaderboardStates[type]!,
          loadingWidget: Expanded(child: inventorySkeleton(context: context)),
          errorWidget: ErrorPage(
            errorText: leaderboardErrors[type],
            onPressed: () {
              setState(() {
                leaderboardErrors[type] = null;
                leaderboardStates[type] = DataLoadState.loading;
                _pages[types.weekly.name] = 1; // Reset page
                getLeaderboardByType(type: type);
              });
            },
          ),
          loadedWidget: leaderboards[type]!.isNotEmpty
              ? Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: HexColor("#092641"),
                          ),
                          child: FirstThreeLeaderboard(leaderboardUser: leaderboards[type]!),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: LeaderboardBanner(title: "Monthly Leaderboard"),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollControllers[type],
                        itemCount: leaderboards[type]!.length > 3 ? leaderboards[type]!.length - 3 + (_isLoadingData[type]! && isMobile(context) ? 1 : 0) : 0,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemBuilder: (context, i) {
                          // var leader = i + 3;
                          // return Padding(
                          //   padding: const EdgeInsets.only(bottom: 8.0),
                          //   child: LeaderboardRankingDetails(
                          //       userName: leaderboards[type]![leader].user!.firstName!,
                          //       rank: i + 4,
                          //       score: leaderboards[type]![leader].score!
                          //   ),
                          // );
                              if (_isLoadingData[type]! &&
                                    isMobile(context) &&
                                    i == leaderboards[type]!.length - 3) {
                                  return const CircularProgressWidget();
                                }

                                final leaderIndex = i + 3;
                                if (leaderIndex < leaderboards[type]!.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: LeaderboardRankingDetails(
                                      userName: leaderboards[type]![leaderIndex].user!.firstName!,
                                      rank: i + 4,
                                      score: leaderboards[type]![leaderIndex].score!,
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                        },
                      ),
                    ),
                  if (!isMobile(context) && !_dataFinishedOnScroll[type]!)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: AppButton(
                          width: 150,
                          height: 42,
                          color: secondaryColor,
                          isLoading: _isLoadingData[type]!,
                          onPressed: _isLoadingData[type]! ? null : () async => getLeaderboardByType(type: type),
                          text: 'load more',
                        ),
                      ),
                    ),
                  ],
                )
                  )
              ],
            ),
          )
              : Expanded(
            child: showError(),
          ),
        ),
      ],
    );
  }

  Widget _buildYearlyTab() {
    String type = types.yearly.name;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 30,
          color: tertiaryColor,
          child: Center(child: Text("${DateTime.parse(getDateByType(type: type)).year.toString()}", style: TextStyle(
              fontSize: fontSize18
          ),)),
        ),
        buildContent(
          dataLoadState: leaderboardStates[type]!,
          loadingWidget: Expanded(child: inventorySkeleton(context: context)),
          errorWidget: ErrorPage(
            errorText: leaderboardErrors[type],
            onPressed: () {
              setState(() {
                leaderboardErrors[type] = null;
                leaderboardStates[type] = DataLoadState.loading;
                _pages[types.weekly.name] = 1; // Reset page
                getLeaderboardByType(type: type);
              });
            },
          ),
          loadedWidget: leaderboards[type]!.isNotEmpty
              ? Column(
                children: [
                  Expanded(
                    child: LeaderboardRanks(
                        leaderboardFirstThree: leaderboards[type]!,
                        leaderboardBannerTitle: "Yearly Leaderboard",
                        controller: scrollControllers[type],
                        itemCount: leaderboards[type]!.length > 3 ? leaderboards[type]!.length - 3 + (_isLoadingData[type]! && isMobile(context) ? 1 : 0) : 0,
                        leaderboards: leaderboards[type]!,
                        isLoadingData: _isLoadingData[type]!,
                    ),
                  ),
                // "Load More" Button for non-mobile, if there's more data to load
                if (!isMobile(context) && !_dataFinishedOnScroll[type]!)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: AppButton(
                          width: 150,
                          height: 42,
                          color: secondaryColor,
                          isLoading: _isLoadingData[type]!,
                          onPressed: _isLoadingData[type]! ? null : () async => getLeaderboardByType(type: type),
                          text: 'load more',
                        ),
                      ),
                    )
                ],
              )
              : Expanded(
            child: showError(),
          ),
        ),
      ],
    );
  }

  checkTypes() async {
    Response response = await _leaderboardProvider?.getTypesLeaderboard();
    // print("Getting configuration types");

    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      List<dynamic> dataTypes = response.data;
      configurationTypes = dataTypes.map((e) => ConfigurationModel.fromJson(e)).toList();

      // Filter active configuration types
      activeConfigurationTypes = configurationTypes.where((type) => type.values == "true").toList();
      activeConfigurationTypes.add(ConfigurationModel(id: 0, title: 'OverAll', values: "true"));

      // Create a tab controller with the correct number of tabs based on active configurations
      _tabController = TabController(
          initialIndex: 0,
          length: activeConfigurationTypes.length,
          vsync: this
      );

      configurationState = DataLoadState.loaded;

      List<Future> futures = [];
      for (ConfigurationModel type in activeConfigurationTypes) {
        if (type.title == types.daily.name) {
          futures.add(getLeaderboardByType(type: types.daily.name));
        } else if (type.title == types.weekly.name) {
          futures.add(getTournamentsAndMatchdays());
        } else if (type.title == types.monthly.name) {
          futures.add(getLeaderboardByType(type: types.monthly.name));
        } else if (type.title == types.yearly.name) {
          futures.add(getLeaderboardByType(type: types.yearly.name));
        }
      }
      // Now wait for all of them to complete
      await Future.wait(futures);
    } else {
      configurationTypesError = response.data['message'];
      configurationState = DataLoadState.error;
    }
    setState(() {});
  }

  getLeaderboardByType({required String type, int? lanternId, String? dateSent}) async {
    // print("_isLoadingData[\${type}]: \\${!_isLoadingData[type]!} ---- _dataFinishedOnScroll[type]: \\${!_dataFinishedOnScroll[type]!}");
    if (!_isLoadingData[type]! && !_dataFinishedOnScroll[type]!) {
      setState(() {
        _isLoadingData[type] = true;
      });

      // Use the passed date or get the stored date
      String? date;
      if (dateSent != null) {
        date = dateSent;
        // Store the date for future pagination
        if (type == types.monthly.name) {
          _currentMonthlyDate = dateSent;
        } else if (type == types.weekly.name) {
          _currentDates[type] = dateSent;
        }
      } else {
        // Use stored dates
        date = type == types.monthly.name ? _currentMonthlyDate :
        type == types.weekly.name ? _currentDates[type] :
        getDateByType(type: type);
      }

      // Validate date
      if (date == null) {
        setState(() {
          _isLoadingData[type] = false;
          leaderboardErrors[type] = "Invalid date";
          leaderboardStates[type] = DataLoadState.error;
        });
        return;
      }
      var data = {
        "page": _pages[type]!,
        "limit": limit,
        "type": type,
        "dateNow": date,
      };
      // print("lead data: $data");
      if(type == types.weekly.name && matchDays.isEmpty){
        setState(() {
          leaderboardStates[type] = DataLoadState.loaded;
        });
        return;
      }
      // print("lanttttttttttttttt: ${lanternId}");
      if(type == types.weekly.name){
        data['championshipId'] = tournaments[tournamentIndex].id;
        data['daynumber'] = matchDays[matchdayIndex].dayNumber;
        data['lanternId'] = lanternId!;
      }
      Response response = await _leaderboardProvider?.getLeaderboardByType(data: data);

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> res = response.data['data'];
        List<LeaderboardUserResultModel> tempMatchesList =
        res.map((e) => LeaderboardUserResultModel.fromJson(e)).toList();
        leaderboards[type]!.addAll(tempMatchesList);

        if (tempMatchesList.length < limit) {
          _dataFinishedOnScroll[type] = true;
        }

        leaderboardStates[type] = DataLoadState.loaded;
        setState(() {
          _pages[type] = _pages[type]! + 1; // Increment page
          _isLoadingData[type] = false;
        });
      } else {
        if (_pages[type] == 1) {
          leaderboardErrors[type] = response.data['message'];
          leaderboardStates[type] = DataLoadState.error;
        } else {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        }
        setState(() {
          _isLoadingData[type] = false;
        });
      }
    }
  }


  //this is used to get the tournament and matchdays for leaderboard weekly only;
  getTournamentsAndMatchdays()async{
    // print("llllllllllllllllll1111111111111111111");
    await getTournaments();
    // print("llllllllllllllllll2222222222222222222");
    if(tournaments.length > 0) {
      await getLanterns(tournaments[0].id);
      // print("llllllllllllllllll33333333333333333");
      await findMatchDaysPerTournament(championshipId: tournaments[0].id,
          leaderboardType: types.weekly.name);//here we will send the type weekly to get the matchdays for the weekly
      // print("llllllllllllllllll44444444444444444");
    }
  }


  getLanterns(int championshipId) async {
    Response response = await _storePackageProvider?.getPackagesByChampionshipId(championshipId: championshipId);

    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      List<dynamic> dataValue = response.data;
      lanterns.addAll(dataValue.map((val) => StorePackageModel.fromJson(val)).toList());
    }
    setState(() {
      lanterns;
    });
  }

  getTournaments() async {
    if (!_isLoadingDataTournament && !_dataFinishedOnScrollTournament) {
      setState(() {
        _isLoadingDataTournament = true;
      });
      Response response = await _championshipProvider?.getTournaments(
        page: _pageTournament,
        limit: limitTournament,
      );

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> dataValue = response.data['data'];
        tournaments.addAll(dataValue.map((val) => TournamentModel.fromJson(val)).toList());

        if (dataValue.length < limitTournament) {
          _dataFinishedOnScrollTournament = true;
        }
        _pageTournament++;
        tournamentsState = DataLoadState.loaded;
      } else {
        tournamentsState = DataLoadState.error;
        tournamentsError = response.data['message'];
      }
      setState(() {
        tournaments;
        _pageTournament;
        tournamentsState;
        _isLoadingDataTournament = false;
      });
    }
  }

  findMatchDaysPerTournament({required int championshipId, required String leaderboardType }) async {
    // debugPrint("_pageMatchDay: $_pageMatchDay, limitMatchDay: $limitMatchDay, championshipId: $championshipId, leaderboardType: $leaderboardType");
    if (!_isLoadingDataMatchDay && !_dataFinishedOnScrollMatchDay) {
      setState(() {
        _isLoadingDataMatchDay = true;
      });
      Response response = await _championshipProvider?.getMatchDaysByTournamentId(
        page: _pageMatchDay,
        limit: limitMatchDay,
        championshipId: championshipId,
      );

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> dataValue = response.data['data'];
        matchDays.addAll(dataValue.map((val) => MatchDayModel.fromJson(val)).toList());
        matchdayTotal = response.data['total'];

        if (dataValue.length < limitMatchDay) {
          _dataFinishedOnScrollMatchDay = true;
        }
        _pageMatchDay++;
        // Store the date for the first matchday
        if (matchDays.isNotEmpty) {
          _currentDates[leaderboardType] = matchDays[0].startingDate;
        }
        if(leaderboardType == types.weekly.name){
          // print("laaaaaaaaaaaaa: ${lanterns.length} --- ${lanterns[lanternIndex].id}");
          getLeaderboardByType(type: leaderboardType, lanternId: lanterns[lanternIndex].id);
        }else {
          // print("laaaaaaaaaaaaa: ${leaderboardType}");
          getLeaderboardByType(type: leaderboardType);
        }
      } else {
        if(mounted) {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        }
      }
      setState(() {
        matchdayTotal;
        matchDays;
        _pageMatchDay;
        _isLoadingDataMatchDay = false;
      });
    }
  }

  getLeaderboard() async{
    if (!_isLoadingDataOverAll && !_dataFinishedOnScrollOverAll) {
      setState(() {
        _isLoadingDataOverAll = true;
      });
      var data = {
        "page": _pageOverAll,
        "limit": limit,
      };
      // print("lead data: $data");
      Response response = await _leaderboardProvider?.getLiveLeaderboard(data: data);

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> res = response.data['data'];
        List<UserModel> tempMatchesList =
        res.map((e) => UserModel.fromJson(e)).toList();
        leaderboardOverAll.addAll(tempMatchesList);
        for(UserModel user in leaderboardOverAll){
          firstThreeLeaderboard.add(
              LeaderboardUserResultModel(
                  score: user.totalpoints,
                  user: user
              )
          );
        }

        if (tempMatchesList.length < limitOverAll) {
          _dataFinishedOnScrollOverAll = true;
        }

        leaderboardOverAllState = DataLoadState.loaded;
        setState(() {
          _pageOverAll++;
          _isLoadingDataOverAll = false;
        });
      } else {
        if (_pageOverAll == 1) {
          leaderboardOverAllError = response.data['message'];
          leaderboardOverAllState = DataLoadState.error;
        } else {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        }
        setState(() {
          _isLoadingDataOverAll = false;
        });
      }
    }
  }

  Widget showError(){
    return ErrorTextPage(
      errorText: "There is no leaderboard results right now!",
    );
  }
}