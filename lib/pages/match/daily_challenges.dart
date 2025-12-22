
import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/model/type_model.dart';
import 'package:ahzir/pages/bottom_nav_pages.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/cards/match_card_widget.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'daily_match_prediction.dart';

class DailyChallenges extends StatefulWidget {
  final bool notificationSent;

  const DailyChallenges({
    this.notificationSent = false,
    super.key
  });

  @override
  State<DailyChallenges> createState() => _DailyChallengesState();
}

class _DailyChallengesState extends State<DailyChallenges> {
  String? error;
  List<MatchModel> matchesList = [];
  List<TypeModel> types = [];
  int page = 1;
  int limit = 10;
  bool isLoadingData = false;
  final ScrollController _scrollController = ScrollController();
  bool dataFinishedOnScroll = false;
  MatchViewModel? _matchProvider;
  DataLoadState matchState = DataLoadState.loading;

  @override
  void initState() {
    _matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    getDailyMatches();
    _scrollController.addListener(() {
      if (!isLoadingData &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (isMobile(context)) {
          getDailyMatches();
        }
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _close(); // Your custom logic to handle back press
      },
      child: Scaffold(
        appBar: AppBarWidget(
          titleWidget: SvgPicture.asset("$staticImgUrl/logo/ihzar.svg"),
          centerTitle: true,
        ),
        body: defaultSkeleton(
          context: context,
          loadState: matchState,
          loadingWidget: matchSkeleton(context: context, listLength: 10),
          errorWidget: ErrorPage(errorText: error),
          dataWidget: matchesList.isNotEmpty
              ? SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            child: Column(
              children: [
                ...List.generate(matchesList.length, (int i) {
                  if (i < matchesList.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5),
                      child: MatchCardWidget(
                        onTap: () => nextScreen(context, DailyMatchPrediction(
                          matchInfo: matchesList[i],
                          types: types,
                        )),
                        homeTeamName: "${matchesList[i].homeTeam?.name}",
                        awayTeamName: "${matchesList[i].awayTeam?.name}",
                        homeTeamImage: "${matchesList[i].homeTeam?.imgUrl}",
                        awayTeamImage: "${matchesList[i].awayTeam?.imgUrl}",
                        date: convertToDateTime(matchesList[i].matchDate,
                            matchesList[i].startingAt),
                        matchStatus: matchesList[i].status,
                        homeTeamScore: matchesList[i].homeTeamScore,
                        awayTeamScore: matchesList[i].awayTeamScore,
                        tournamentName: matchesList[i].championship!.name,
                      ),
                    );
                  } else {
                    if (isMobile(context)) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: CircularProgressWidget(),
                      );
                    }
                    return Container();
                  }
                }),
                !isMobile(context) && dataFinishedOnScroll == false
                    ? Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: AppButton(
                        width: 150,
                        height: 42,
                        color: secondaryColor,
                        isLoading: isLoadingData,
                        onPressed: () => getDailyMatches(),
                        text: 'load more'),
                  ),
                )
                    : Container()
              ],
            ),
          )
              : const ErrorTextPage(errorText: 'No daily matches found!'),
        ),
      ),
    );
  }

  getDailyMatches() async {
    if (!isLoadingData && !dataFinishedOnScroll) {
      setState(() {
        isLoadingData = true;
      });
      Response response = await _matchProvider?.dailyMatches(
          page: page,
          limit: limit,
      );

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> res = response.data['data'];
        types = (response.data['types'] as List<dynamic>)
            .map((e) => TypeModel.fromJson(e))
            .toList();
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
          types;
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
  }

  _close(){
    if(Navigator.canPop(context)) {
      Navigator.pop(context);
    }else{
      nextScreenCloseOthers(context, BottomNavPages(index: 0));
    }
  }
}
