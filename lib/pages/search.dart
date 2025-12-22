import 'dart:async';
import 'dart:convert';

import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/user.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/tournament_response_model.dart';
import 'package:ahzir/pages/tournaments/tournament_matches.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/championship_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/cards/match_card_widget.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/text_inputs/text_input_widget.dart';
import 'package:ahzir/widgets/tournaments/tournament_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool isLoadingData = false;
  int _page = 1;
  int limit = 10;
  String? search;
  Timer? _debounce;
  DataLoadState searchState = DataLoadState.loaded;
  bool dataFinishedOnScroll = false;
  String? searchError;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List searchHistory = [];
  List<TournamentResponseModel> searchList = [];
  ChampionshipViewModel? championshipProvider;
  bool isSearchLoading = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    championshipProvider =
        Provider.of<ChampionshipViewModel>(context, listen: false);
    getSearchHistory();
    
    // Initialize scroll controller listener
    _scrollController.addListener(() {
      if (!isLoadingData &&
          _scrollController.hasClients &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (isMobile(context)) {
          paginationSearch();
        }
      }
    });
    
    // Request focus after the widget is built
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted && _searchFocusNode.canRequestFocus) {
    //     _searchFocusNode.requestFocus();
    //   }
    // });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            // Fixed Header
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                hintText: "Search".tr(),
                hintStyle: TextStyle(color: whiteColor.withOpacity(0.7)),
                filled: true,
                fillColor: whiteOpacity5,
                prefixIcon: Icon(Icons.search, color: whiteColor),
                suffixIcon: search != null && search!.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, color: whiteColor),
                        onPressed: () {
                          setState(() {
                            search = null;
                            searchError = null;
                            searchState = DataLoadState.loaded;
                            _searchController.clear();
                            _searchFocusNode.requestFocus();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onChanged: (val) {
                // Update the search text immediately for better UX
                setState(() {
                  search = val;
                });
                
                // Only trigger search if the user has stopped typing for 500ms
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  if (val.isNotEmpty && val.length > 1) {
                    searchData(val);
                  } else {
                    // Clear results if search is empty or too short
                    setState(() {
                      searchList.clear();
                      searchState = DataLoadState.loaded;
                    });
                  }
                });
                // if (search != null && search!.length > 1) {
                //   print("Searchhhhhhhhhhh: $search");
                //   saveSearch(val);
                // }
              },
            ),
            const SizedBox(height: 10),
            // Scrollable Content
            Expanded(
              child: buildContent(
                  dataLoadState: searchState,
                  errorWidget: ErrorPage(
                    errorText: searchError,
                    onPressed: () {
                      setState(() {
                        searchError = null;
                        searchState = DataLoadState.loading;
                        searchData(search);
                      });
                    },
                  ),
                  loadingWidget: searchSkeleton(context: context),
                  loadedWidget: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      search != null && search != '' && search!.length > 1
                          ? searchList.isNotEmpty
                              ? Column(
                                  children: [
                                    ...List.generate(
                                        searchList.length +
                                            (isLoadingData ? 1 : 0), (i) {
                                      if (i < searchList.length) {
                                        if (searchList[i].tournamentModel !=
                                            null) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: TournamentWidget(
                                              tournament: searchList[i]
                                                  .tournamentModel!,
                                              onTap: () => nextScreen(
                                                  context,
                                                  TournamentMatches(
                                                      tournamentId:
                                                          searchList[i]
                                                              .tournamentModel!
                                                              .id)),
                                            ),
                                          );
                                        } else if (searchList[i].matchModel !=
                                            null) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: MatchCardWidget(
                                              onTap: () =>
                                                  navigateToMatchPrediction(
                                                      matchInfo: searchList[i]
                                                          .matchModel!,
                                                      matchId: searchList[i]
                                                          .matchModel!
                                                          .id,
                                                      context: context),
                                              homeTeamName:
                                                  "${searchList[i].matchModel?.homeTeam?.name}",
                                              awayTeamName:
                                                  "${searchList[i].matchModel?.awayTeam?.name}",
                                              homeTeamImage:
                                                  "${searchList[i].matchModel?.homeTeam?.imgUrl}",
                                              awayTeamImage:
                                                  "${searchList[i].matchModel?.awayTeam?.imgUrl}",
                                              date: convertToDateTime(
                                                  searchList[i]
                                                      .matchModel!
                                                      .matchDate,
                                                  searchList[i]
                                                      .matchModel!
                                                      .startingAt),
                                              matchStatus: searchList[i]
                                                  .matchModel
                                                  ?.status,
                                              homeTeamScore: searchList[i]
                                                  .matchModel
                                                  ?.homeTeamScore,
                                              awayTeamScore: searchList[i]
                                                  .matchModel
                                                  ?.awayTeamScore,
                                              tournamentName: "${searchList[i].matchModel?.championship!.name}",
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        if (isMobile(context)) {
                                          return const CircularProgressWidget();
                                        }
                                        return Container();
                                      }
                                    }),
                                    !isMobile(context) &&
                                            dataFinishedOnScroll == false
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Center(
                                              child: AppButton(
                                                  width: 150,
                                                  height: 42,
                                                  color: secondaryColor,
                                                  isLoading: isLoadingData,
                                                  onPressed: () =>
                                                      paginationSearch(),
                                                  text: 'load more'),
                                            ),
                                          )
                                        : Container()
                                  ],
                                )
                              : !isSearchLoading
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              210,
                                      child: const ErrorTextPage(
                                          errorText: "No data found!"),
                                    )
                                  : Container()
                          : searchHistory.isNotEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    spacing:
                                        8.0, // Horizontal spacing between items
                                    runSpacing:
                                        8.0, // Vertical spacing between rows
                                    children: List.generate(
                                        searchHistory.length, (i) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8),
                                        child: GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              search = searchHistory[i];
                                              _searchController.text = search!;
                                            });
                                            await searchData(search);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              color: whiteOpacity5,
                                            ),
                                            child: Text("${searchHistory[i]}"),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 210,
                                  child: ErrorTextPage(
                                      errorText: "Search",
                                      widget: Icon(Icons.library_books_sharp,
                                          color: whiteColor, size: 120)),
                                )
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  searchData(String? search) async {
    _page = 1;
    if (search != null && search.length > 1) {
      setState(() {
        searchList = [];
        isSearchLoading = true;
      });
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        setState(() {
          searchState = DataLoadState.loading;
        });
        Response response = await championshipProvider?.search(
            limit: limit, page: _page, q: search);
        if (response.statusCode != null &&
            (response.statusCode! >= 200 && response.statusCode! <= 399)) {
          List<dynamic> res = response.data;
          List<TournamentResponseModel> tempFilterList = res
              .map((e) =>
                  TournamentResponseModel.fromJson(e as Map<String, dynamic>))
              .toList();
          searchList.addAll(tempFilterList);

          setState(() {
            _page++;
            searchState = DataLoadState.loaded;
            searchList;
            isLoadingData = false;
            isSearchLoading = false;
          });
          saveSearch(search); //save the search value in preferences
        } else {
          setState(() {
            //eza b3dna awl ma 3m njib ldata w tabash, mnbayen page error, else , mnbayen snackbar error
            searchState = DataLoadState.error;
            searchError = response.data['message'];
            isSearchLoading = false;
          });
        }
      });
    }
  }

  paginationSearch() async {
    if (!isLoadingData && !dataFinishedOnScroll) {
      setState(() {
        isLoadingData = true;
      });
      Response response = await championshipProvider?.search(
          page: _page, limit: limit, q: search);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 399) {
        List<dynamic> res = response.data;
        List<TournamentResponseModel> tempFilterList = res
            .map((e) =>
                TournamentResponseModel.fromJson(e as Map<String, dynamic>))
            .toList();
        searchList.addAll(tempFilterList);

        if (tempFilterList.length < limit) {
          dataFinishedOnScroll = true;
        }
        setState(() {
          searchList;
          isLoadingData = false;
          _page++;
        });
      } else {
        appSnackBar(
            context: context, msg: response.data['message'], isError: true);
      }
      setState(() {
        dataFinishedOnScroll;
        isLoadingData = false;
        searchList;
      });
    }
  }

  getSearchHistory() async {
    searchState = DataLoadState.loading;
    var res = await storage.read(key: "userSearch");
    searchState = DataLoadState.loaded;
    if (res != null && res != '') {
      List<dynamic> decodedList =
          json.decode(res); // Decode JSON string to list
      searchHistory = List<String>.from(decodedList); // Ensure type safety
    }
    setState(() {
      searchHistory;
    });
  }

  saveSearch(value) async {
    if (value != null && value != '') {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 2), () async {
        var res = await storage.read(key: "userSearch");
        List<String> searchList = []; // Initialize an empty list

        if (res != null && res != '') {
          searchList =
              List<String>.from(json.decode(res)); // Decode existing list
        }
        // Check if the value already exists and remove it to prevent duplicates
        searchList.remove(value);
        // Add the new search at the end
        searchList.add(value);
        // Keep only the last 10 searches
        if (searchList.length > 10) {
          searchList.removeAt(0); // Remove the oldest search
        }
        // Save the updated list to storage
        String encodedList = json.encode(searchList);
        await storage.write(key: "userSearch", value: encodedList);
      });
    }
  }
}
