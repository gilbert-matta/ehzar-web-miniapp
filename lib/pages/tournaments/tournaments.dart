import 'dart:async';

import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/tournament_model.dart';
import 'package:ahzir/pages/tournaments/tournament_matches.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/championship_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/tournaments/tournament_widget.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class Tournaments extends StatefulWidget {
  const Tournaments({super.key});

  @override
  State<Tournaments> createState() => _TournamentsState();
}

class _TournamentsState extends State<Tournaments> {
  final ScrollController _scrollController = ScrollController();
  DataLoadState tournamentState = DataLoadState.loading;
  String? error;
  List<TournamentModel> tournamentsList = [];
  int page = 1;
  int limit = 15;
  ChampionshipViewModel? _tournamentProvider;
  Timer? _debounce;
  bool dataFinishedOnScroll = false;
  bool isLoadingData = false;

  @override
  void initState() {
    _tournamentProvider =
        Provider.of<ChampionshipViewModel>(context, listen: false);
    getAllTournaments();
    _scrollController.addListener(() {
      if (!isLoadingData &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        getAllTournaments();
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
        loadState: tournamentState,
        loadingWidget: matchSkeleton(context: context, listLength: 15),
        errorWidget: ErrorTextPage(errorText: error),
        dataWidget: tournamentsList.isNotEmpty
            ? SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: List.generate(
                      tournamentsList.length + (isLoadingData ? 1 : 0),
                      (int i) {
                    if (i < tournamentsList.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: TournamentWidget(
                          tournament: tournamentsList[i],
                          containerColor: whiteOpacity30,
                          onTap: () => nextScreen(
                              context,
                              TournamentMatches(
                                  tournamentId: tournamentsList[i].id)),
                        ),
                      );
                    } else {
                      return const CircularProgressWidget();
                    }
                  }),
                ),
              )
            : const ErrorTextPage(errorText: 'No data found!'),
      ),
    );
  }

  getAllTournaments() async {
    if (!isLoadingData && !dataFinishedOnScroll) {
      setState(() {
        isLoadingData = true;
      });
      Response response =
          await _tournamentProvider?.getTournaments(page: page, limit: limit);

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> res = response.data['data'];
        List<TournamentModel> tempMatchesList =
            res.map((e) => TournamentModel.fromJson(e)).toList();
        tournamentsList.addAll(tempMatchesList);

        if (tempMatchesList.length < limit) {
          dataFinishedOnScroll = true;
        }

        tournamentState = DataLoadState.loaded;
        setState(() {
          page++;
          tournamentsList;
          tournamentState;
          error;
          isLoadingData = false;
        });
      } else {
        if (page == 0) {
          error = response.data['message'];
          tournamentState = DataLoadState.error;
        } else {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        }
        setState(() {
          tournamentsList;
          tournamentState;
          error;
          isLoadingData = false;
        });
      }
    }
  }
}
