import 'dart:async';

import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/js_web.dart';
import 'package:ahzir/functions/user.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/campaign_model.dart';
import 'package:ahzir/models/model/lantern_model.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/model/matchday_model.dart';
import 'package:ahzir/models/model/tournament_matches_model.dart';
import 'package:ahzir/pages/match/match_prediction.dart';
import 'package:ahzir/pages/store/Inventory.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/championship_view_model.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/widgets/alert_dialogs/alert_dialog.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/cards/match_card_widget.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/dialogs/championship_packages_dialog.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/lantern/lantern_square_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class TournamentMatches extends StatefulWidget {
  final int tournamentId;

  const TournamentMatches({required this.tournamentId, super.key});

  @override
  State<TournamentMatches> createState() => _TournamentMatchesState();
}

class _TournamentMatchesState extends State<TournamentMatches> {
  String? error;
  TournamentMatchesModel matchesList = TournamentMatchesModel(
      matches: [], userPredictionCount: 0, total: 0, userPredictions: [], campaign: null);
  int page = 1;
  int limit = 10;
  bool isLoadingData = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  bool dataFinishedOnScroll = false;
  MatchViewModel? _matchProvider;
  DataLoadState matchState = DataLoadState.loading;
  int userPredictionsLength = 0;
  StoreViewModel? _storeProvider;
  //for matchday
  List<MatchDayModel> matchDays = [];
  List<StorePackageModel> lanterns = [];
  int matchdayIndex = 0;
  int matchdayTotal = 0;
  bool _isLoadingDataMatchDay = false;
  bool _dataFinishedOnScrollMatchDay = false;
  ChampionshipViewModel? _championshipProvider;
  int _pageMatchDay = 1;
  int limitMatchDay = 10;
  bool submittedAllPredictions = false;
  List<dynamic> championshipPackages = []; // Cache championship packages

  @override
  void initState() {
    _matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    _storeProvider = Provider.of<StoreViewModel>(context, listen: false);
    _championshipProvider =
        Provider.of<ChampionshipViewModel>(context, listen: false);
    // getMatchesPerTournament();
    findMatchDaysPerTournament(championshipId: widget.tournamentId);
    _scrollController.addListener(() {
      if (!isLoadingData &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (isMobile(context)) {
          getMatchesPerTournament(
              matchdaynumber: matchDays[matchdayIndex].dayNumber);
        }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        bottom: matchesList.matches.length > 0
            ? PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Center(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(color: whiteColor),
                        borderRadius: BorderRadius.circular(6.2)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                        child: Text(
                            "${'you must predict all the matches of this week to be calculated to win prizes'.tr()}. ${'You predicted'.tr()} ${matchesList.userPredictionCount} / ${matchesList.total}",
                            style: TextStyle(fontSize: fontSize14),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                )))
            : PreferredSize(
                preferredSize: Size.fromHeight(30),
                child: Container(),
              ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Stack(
          children: [
            Column(
              children: [
                lanterns.length > 0 ? LanternSquareWidget(lanterns: lanterns) : SizedBox(),
                matchDays.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: matchdayIndex > 0
                                      ? whiteColor
                                      : greyColor),
                              onPressed: () {
                                if (matchdayIndex > 0) {
                                  setState(() {
                                    matchdayIndex--;
                                    isLoadingData = false;
                                    dataFinishedOnScroll = false;
                                    page = 1;
                                    submittedAllPredictions = false;
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      matchState = DataLoadState.loading;
                                      matchesList.matches.clear();
                                      matchesList.total = 0;
                                      matchesList.userPredictionCount = 0;
                                      getMatchesPerTournament(
                                          matchdaynumber:
                                              matchDays[matchdayIndex]
                                                  .dayNumber);
                                    });
                                  });
                                }
                              },
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: FadeTransition(
                                      opacity: animation, child: child),
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "${'Round'.tr()} ${matchDays[matchdayIndex].dayNumber}", // matchday number
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${matchDays[matchdayIndex].startingDate}',
                                        style: TextStyle(
                                            fontSize: fontSize12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        '${matchDays[matchdayIndex].endingDate}',
                                        style: TextStyle(
                                            fontSize: fontSize12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios,
                                  color:
                                      (matchDays.length - 1 == matchdayIndex &&
                                              matchDays.length == matchdayTotal)
                                          ? greyColor
                                          : whiteColor),
                              onPressed: !isLoadingData
                                  ? () async {
                                      // if(!dataFinishedOnScroll[types.weekly.name]! && !isLoadingData[types.weekly.name]!) {
                                      if (matchDays.length - 1 ==
                                              matchdayIndex &&
                                          matchDays.length < matchdayTotal) {
                                        findMatchDaysPerTournament(
                                            championshipId:
                                                widget.tournamentId!);
                                        // getMatchesPerTournament(matchdaynumber: matchDays[matchdayIndex].dayNumber);
                                        if (matchDays.length - 1 >
                                            matchdayIndex) {
                                          setState(() {
                                            matchdayIndex++;
                                          });
                                        }
                                      } else if (matchDays.length - 1 >
                                          matchdayIndex) {
                                        setState(() {
                                          matchdayIndex++;
                                          isLoadingData = false;
                                          dataFinishedOnScroll = false;
                                          page = 1;
                                          submittedAllPredictions = false;
                                          Future.delayed(
                                              Duration(milliseconds: 300), () {
                                            matchState = DataLoadState.loading;
                                            matchesList.matches.clear();
                                            matchesList.total = 0;
                                            matchesList.userPredictionCount = 0;
                                            getMatchesPerTournament(
                                                matchdaynumber:
                                                    matchDays[matchdayIndex]
                                                        .dayNumber);
                                          });
                                        });
                                      }
                                      // }
                                    }
                                  : () {},
                            ),
                          ],
                        ),
                      )
                    : Container(),
                buildContent(
                  dataLoadState: matchState,
                  loadingWidget: Expanded(
                      child: matchSkeleton(context: context, listLength: 10)),
                  errorWidget: Expanded(
                    child: ErrorPage(
                        errorText: error,
                        onPressed: () {
                          setState(() {
                            error = null;
                            matchState = DataLoadState.loading;
                            matchesList.matches.clear();
                            matchesList.total = 0;
                            matchesList.userPredictionCount = 0;
                            isLoadingData = false;
                            dataFinishedOnScroll = false;
                            page = 1;
                            getMatchesPerTournament(
                                matchdaynumber:
                                    matchDays[matchdayIndex].dayNumber);
                          });
                        }),
                  ),
                  loadedWidget: matchesList.matches.isNotEmpty
                      ? Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 5, bottom: 20),
                            child: Column(
                              children: [
                                ...List.generate(matchesList.matches.length,
                                    (int i) {
                                  MatchModel match = matchesList.matches[i];
                                  if (i < matchesList.matches.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5),
                                      child: MatchCardWidget(
                                        onTap: () => nextScreenReturnValue(
                                            context,
                                            MatchPrediction(
                                                matchInfo: match,
                                                matchId: match.id),
                                            onValue: (val) {
                                          if (val == true) {
                                            setState(() {
                                              matchesList.userPredictionCount++;
                                            });
                                          }
                                        }),

                                        //     navigateToMatchPrediction(
                                        //     matchInfo: match,
                                        //     matchId: match.id,
                                        //     context: context,
                                        //     onComplete: (val){}
                                        // ),
                                        homeTeamName: "${match.homeTeam?.name}",
                                        awayTeamName: "${match.awayTeam?.name}",
                                        homeTeamImage:
                                            "${match.homeTeam?.imgUrl}",
                                        awayTeamImage:
                                            "${match.awayTeam?.imgUrl}",
                                        date: convertToDateTime(
                                            match.matchDate, match.startingAt),
                                        matchStatus: match.status,
                                        homeTeamScore: match.homeTeamScore,
                                        awayTeamScore: match.awayTeamScore,
                                        tournamentName:
                                            match.championship!.name,
                                        // predictionStatusTeamOne:
                                        //     PredictionStatus.win,
                                        // predictionStatusTeamTwo:
                                        //     PredictionStatus.lose
                                      ),
                                    );
                                  } else {
                                    if (isMobile(context)) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: CircularProgressWidget(),
                                      );
                                    }
                                    return Container();
                                  }
                                }),
                                !isMobile(context) &&
                                        dataFinishedOnScroll == false
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Center(
                                          child: AppButton(
                                              width: 150,
                                              height: 42,
                                              color: secondaryColor,
                                              isLoading: isLoadingData,
                                              onPressed: () =>
                                                  getMatchesPerTournament(),
                                              text: 'load more'),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child:
                              const ErrorTextPage(errorText: 'No data found!')),
                ),
              ],
            ),
            matchesList.userPredictionCount == matchesList.total &&
                    matchesList.userPredictionCount != 0 &&
                    (submittedAllPredictions == false &&
                        (matchesList.userPredictions.length > 0
                            ? matchesList.userPredictions
                                .any((pred) => pred.predictionscounted == false)
                            : true))
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                        onPressed: () => submitAllPredictions(),
                        text: "Submit predictions",
                        borderRadius: BorderRadius.zero))
                : Container()
          ],
        ),
      ),
    );
  }

  findMatchDaysPerTournament({required int championshipId}) async {
    if (!_isLoadingDataMatchDay && !_dataFinishedOnScrollMatchDay) {
      setState(() {
        _isLoadingDataMatchDay = true;
      });
      Response response =
          await _championshipProvider?.getMatchDaysByTournamentId(
        page: _pageMatchDay,
        limit: limitMatchDay,
        championshipId: championshipId,
      );

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> dataValue = response.data['data'];
        List<dynamic> lanternData = response.data['lanterns'];
        matchDays.addAll(
            dataValue.map((val) => MatchDayModel.fromJson(val)).toList());
        matchdayTotal = response.data['total'];
        lanterns.addAll(
            lanternData.map((val) => StorePackageModel.fromJson(val)).toList());
        // final lanCopy = List<StorePackageModel>.from(lanterns);
        // lanterns.addAll(lanCopy);

        if (dataValue.length < limitMatchDay) {
          _dataFinishedOnScrollMatchDay = true;
        }
        _pageMatchDay++;
        if (matchdayIndex == 0) {
          matchdayIndex = matchDays.indexWhere((matchDay) {
            late DateTime nowDate;

            if (kIsWeb) {
              // ✅ Correct way to get user's local time from JS
              final now = getLocalDateFromJS();
              final formattedNow = DateFormat('yyyy-MM-dd', 'en').format(now);
              nowDate = DateTime.parse(formattedNow);
            } else {
              final now = DateTime.now().toLocal();
              final formattedNow = DateFormat('yyyy-MM-dd', 'en').format(now);
              nowDate = DateTime.parse(formattedNow);
            }

            final startDate = DateTime.parse(matchDay.startingDate);
            final endDate = DateTime.parse(matchDay.endingDate);

            return nowDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                nowDate.isBefore(endDate.add(Duration(days: 1)));
          });
          if (matchdayIndex == -1) matchdayIndex = 0;
        }
        print("matchdaysssssss: $matchDays");
        print(
            "matchdays length: ${matchDays.length} -- daynumberindex: ${matchdayIndex} --- matchDays[matchdayIndex].dayNumber: ");
        if (matchDays.length > 0) {
          getMatchesPerTournament(
              matchdaynumber: matchDays[matchdayIndex].dayNumber);
        }
      } else {
        if (mounted) {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        }
      }
      print("matchdaysssssss: $matchDays");
      setState(() {
        matchdayTotal;
        matchDays;
        _pageMatchDay;
        _isLoadingDataMatchDay = false;
        lanterns;
      });
    }
  }

  getMatchesPerTournament({int? matchdaynumber}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    // print("matchdaynumberrrrrrrrr: $matchdaynumber");
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!isLoadingData && !dataFinishedOnScroll) {
        setState(() {
          isLoadingData = true;
        });
        Response response =
            await _matchProvider?.getMatchesPerTournamentPerMatchWeek(
          dateNow: matchDays[matchdayIndex].startingDate,
          tournamentId: widget.tournamentId!,
          matchdaynumber: matchdaynumber,
          page: page,
          limit: limit,
        );

        if (response.statusCode != null &&
            (response.statusCode! >= 200 && response.statusCode! <= 399)) {
          Map<String, dynamic> res = response.data;
          TournamentMatchesModel tempMatchesList =
              TournamentMatchesModel.fromJson(res);
          matchesList.matches.addAll(tempMatchesList.matches);
          matchesList.userPredictionCount = tempMatchesList.userPredictionCount;
          matchesList.userPredictions = tempMatchesList.userPredictions;
          matchesList.total = tempMatchesList.total;
          matchesList.campaign = tempMatchesList.campaign;
          final now = DateTime.now();
          if (tempMatchesList.campaign?.endingDate != null) {
            final endingDate = DateTime.parse(tempMatchesList.campaign!.endingDate);
            final localDateString = getLocalDate(now.toString());
            final localDate = DateTime.parse(localDateString);
            if (endingDate.isAfter(localDate) || endingDate.isAtSameMomentAs(localDate)) {
              _preloadChampionshipPackages(tempMatchesList.campaign);
            }
          }

          if (matchesList.matches.length == matchesList.total) {
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
          if (page == 1) {
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


  _preloadChampionshipPackages(CampaignModel? campaign) async {
    // print("matcheslistttttttt: ${matches.campaign} -- ${matches.campaign?.weekNumber}");
      final results = await Future.wait<dynamic>([
        _storeProvider!.getChampionshipPackages(championshipId: widget.tournamentId, type: types.weekly.name),
        _storeProvider!.getUserActivePackage(type: types.weekly.name, championshipId: widget.tournamentId, weekNumber: campaign?.weekNumber, campaignId: campaign?.id),
      ]);

      final Response packagesResponse = results[0];
      final Response userActivePackage = results[1];

      if (packagesResponse.statusCode != null &&
          packagesResponse.statusCode! >= 200 &&
          packagesResponse.statusCode! <= 399) {
        championshipPackages = packagesResponse.data['data'];
      }

      if (userActivePackage.statusCode != null &&
          userActivePackage.statusCode! >= 200 &&
          userActivePackage.statusCode! <= 399) {
        var userActivePckg = userActivePackage.data;
        if(userActivePckg == null || userActivePckg == ''){
          // ✅ show dialog only after both finish
          _showChampionshipPackagesDialog(packages: championshipPackages);
        }
      }
  }

  _showChampionshipPackagesDialog({ required List packages }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ChampionshipPackagesDialog(
          packages: packages,
          onPressed: (){
            Navigator.of(context).pop();
          },
          onPackageSelected: (packageId) {
            saveSelectedPackage(packageId);
            //save the selected one to database.
          },
          onNavigateToStore: () => nextScreen(context, Inventory()),
        );
      },
    );
  }

  saveSelectedPackage(packageId) async {
    var data = {
      'packageId': packageId,
      'weekNumber': matchesList.campaign?.weekNumber,
      'startingDate': matchesList.campaign?.startingDate,
      'endingDate': matchesList.campaign?.endingDate,
      'campaignId': matchesList.campaign?.id,
    };
    Response response =
        await _storeProvider?.chosenLantern(context: context, data: data);
    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      appSnackBar(context: context, msg: 'Voucher chosen successfully'.tr());
      Navigator.pop(context);
    }else{
      appSnackBar(context: context, msg: response.data['message']);
    }
  }

  submitAllPredictions() async {
    AlertDialogWidget(
      context: context,
      title: 'Confirm Submission'.tr(),
      content: 'Are you sure you want to submit all your predictions?'.tr(),
      onPressed: () async {
        Navigator.pop(context); // Close the dialog first

        var data = {
          'championshipId': widget.tournamentId,
          'dateNow': matchDays[matchdayIndex].startingDate,
          "matchdaynumber": matchDays[matchdayIndex].dayNumber,
        };

        Response response =
            await _storeProvider?.useLantern(context: context, data: data);
        if (response.statusCode != null &&
            (response.statusCode! >= 200 && response.statusCode! <= 399)) {
          appSnackBar(context: context, msg: 'Submitted Successfully'.tr());
          setState(() {
            submittedAllPredictions = true;
          });
        }
      },
    );
  }
}
