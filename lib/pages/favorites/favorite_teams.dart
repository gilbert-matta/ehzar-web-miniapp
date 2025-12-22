import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/team_model.dart';
import 'package:ahzir/models/model/tournament_model.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/championship_view_model.dart';
import 'package:ahzir/view-model/team_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/error/errorDialog.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/league/league_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/teams/teams_check.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class FavoriteTeams extends StatefulWidget {
  final Widget navigateTo;
  final bool isRegistering;

  const FavoriteTeams({
    required this.navigateTo,
    required this.isRegistering,
    super.key
  });

  @override
  State<FavoriteTeams> createState() => _FavoriteTeamsState();
}

class _FavoriteTeamsState extends State<FavoriteTeams> {
  DataLoadState teamState = DataLoadState.loading;
  String? error;
  DataLoadState matchState = DataLoadState.loading;
  String? errorMatches;
  bool isLoadingData = false;
  ChampionshipViewModel? championshipProvider;
  TeamViewModel? teamProvider;
  List<TournamentModel> leagues = [];
  List<TeamModel> teams = [];
  int leagueSelected = 0;
  List<int> selectedTeams = [];
  // Add cache map to store teams by league ID
  Map<int, List<TeamModel>> teamsCache = {};

  @override
  void initState() {
    championshipProvider = Provider.of<ChampionshipViewModel>(context, listen: false);
    teamProvider = Provider.of<TeamViewModel>(context, listen: false);
    getLeagues();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: "Choose your favorite team",
          centerTitle: true,
          actions: widget.isRegistering ? [
            TextButton(onPressed: () => nextScreenCloseOthers(context, widget.navigateTo), child: const Text("Skip").tr())
          ] : [],
        ),
        body: teamState != DataLoadState.error? Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  teamState == DataLoadState.loaded ?
                      // Sidebar
                      Container(
                        width: 100,
                        height: MediaQuery.of(context).size.height * 0.9,
                        color: whiteOpacity5,
                        child: leagues.isNotEmpty ? SingleChildScrollView(
                          child: Column(
                            children: List.generate(leagues.length, (int i) {
                              return LeagueWidget(
                                onTap: () => setState(() {
                                  leagueSelected = i;
                                  matchState = DataLoadState.loading;
                                  getTeamsPerLeague(league: leagues, leagueId: leagues[i].id);
                                }),
                                leagueName: leagues[i].name,
                                isSelected: leagueSelected == i ? true : false,
                              );
                            }),
                          ),
                        ) : const ErrorTextPage(errorText: "No data found!"),
                      ) : teamState == DataLoadState.loading ? favoriteTeamsSkeleton(context: context) : Container(),

                      // Main Content
                      matchState == DataLoadState.loaded ? Expanded(
                        child: teams.isNotEmpty ? Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 80),
                              child: Center(
                                child: Wrap(
                                  direction: Axis.horizontal, // Fill horizontally first
                                  spacing: 10.0, // Space between items horizontally
                                  runSpacing: 20.0, // Space between items vertically
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                    teams.length, // Number of items
                                        (int i) {
                                      return TeamsCheck(
                                        image: teams[i].imgUrl,
                                        isChecked: selectedTeams.any((teamId) => teamId == teams[i].id),
                                        onTap: (){
                                          setState(() {
                                            if(selectedTeams.any((teamId) => teamId == teams[i].id)){
                                              selectedTeams.remove(teams[i].id);
                                            }else{
                                              selectedTeams.add(teams[i].id);
                                            }
                                            // debugPrint("user selected teams: $selectedTeams");
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ) : const ErrorTextPage(errorText: "No data found!"),
                      ) : matchState == DataLoadState.loading ? teamsSkeleton(context: context) : Expanded(child: ErrorTextPage(errorText: errorMatches)),
                    ],
                  ),
                ],
              ),
            ),
            matchState == DataLoadState.loaded ? Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: AppButton(onPressed: () => submitFavorites(), text: "Submit", width: 150),
              ),
            ) : Container(),
          ],
        ) : ErrorPage(errorText: error, onPressed: () {
          setState(() {
            teamState = DataLoadState.loading;
            error = null;
            getLeagues();
          });
        })
      //
    );
  }

  getLeagues() async{
    //check if the provider contains data, no need to call the endpoint, only how the getted leagues ahsn ma ndal n3ayet lal endpoint kl ma toli3 w fet.

    var responses = await Future.wait<dynamic>([
      championshipProvider?.getTournaments(limit: 50, page: 1),
      teamProvider?.getUserFavoriteTeams(context: context, favTeamsList: selectedTeams),
    ]);
    var response = responses[0];
    getUserFavoriteTeams(response: responses[1]);
    if(response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)){
      List<dynamic> dataValue = response.data['data'];
      leagues = dataValue.map((val) => TournamentModel.fromJson(val)).toList();
      getTeamsPerLeague(league: leagues, leagueId: leagues[leagueSelected].id);
      teamState = DataLoadState.loaded;
    }else{
      error = response.data['message'];
      teamState = DataLoadState.error;
    }
  }

  getTeamsPerLeague({required List<TournamentModel> league, required int leagueId}) async {
    if(league.isEmpty) return;

    // Check if we have cached data for this league
    if(teamsCache.containsKey(leagueId)) {
      setState(() {
        teams = teamsCache[leagueId]!;
        matchState = DataLoadState.loaded;
      });
      return;
    }

    // If no cached data, fetch from API
    Response response = await teamProvider?.getTeamsPerLeagueId(id: leagueId);
    if(response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)){
      List<dynamic> dataValue = response.data;
      teams = dataValue.map((val) => TeamModel.fromJson(val)).toList();
      // Cache the fetched teams
      teamsCache[leagueId] = teams;
      matchState = DataLoadState.loaded;
    } else {
      errorMatches = response.data['message'];
      matchState = DataLoadState.error;
    }
    setState(() {
      errorMatches;
      teams;
      matchState;
      error;
      leagues;
      teamState;
    });
  }

  submitFavorites() async{
    Response response = await teamProvider?.setUserFavoriteTeams(context: context, favTeamsList: selectedTeams);
    if(response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)){
      nextScreenCloseOthers(context, widget.navigateTo);
    }else{
      ErrorDialog(context: context, error: response.data['message']);
    }
  }

  getUserFavoriteTeams({required Response response}) async{
    if(response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)){
      var res = response.data;
      for (var value in res) {
        selectedTeams.add(value['team']['id']);
      }
    }else{
      if(error != null && errorMatches != null){
        teamState = DataLoadState.error;
      }
    }
    setState(() {
      selectedTeams;
      teamState;
    });
  }
}