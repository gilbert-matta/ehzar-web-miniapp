import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/models/model/prediction_model.dart';
import 'package:ahzir/models/model/type_model.dart';
import 'package:ahzir/pages/store/Inventory.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/dialogs/championship_packages_dialog.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/match/match_details_widget.dart';
import 'package:ahzir/widgets/match/prediction_button_widget.dart';
import 'package:ahzir/widgets/prediction/team_score_prediction.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/teams/team_info_vertical.dart';
import 'package:ahzir/widgets/text_inputs/TextWithInput.dart';
import 'package:ahzir/widgets/text_inputs/text_input_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class DailyMatchPrediction extends StatefulWidget {
  final MatchModel matchInfo;
  final List<TypeModel> types;

  const DailyMatchPrediction({
    super.key,
    required this.matchInfo,
    required this.types,
  });

  @override
  State<DailyMatchPrediction> createState() => _DailyMatchPredictionState();
}

class _DailyMatchPredictionState extends State<DailyMatchPrediction> {
  MatchViewModel? matchProvider;
  StoreViewModel? storeProvider;
  MatchModel? _match;
  DataLoadState matchState = DataLoadState.loading;
  bool isLoading = false;
  bool isPredicted =
      false; //if the user have predicted once, he can not retry predicting the same one
  Map<int, TextEditingController> _controllers = {};
  var predictionTeam;
  var homeTeamScore;
  var awayTeamScore;
  int? packageId;
  List<dynamic> championshipPackages = []; // Cache championship packages

  @override
  void initState() {
    matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    storeProvider = Provider.of<StoreViewModel>(context, listen: false);
    getMatchInfo();
    _preloadChampionshipPackages();
    for (var type in widget.types) {
      _controllers[type.id] = TextEditingController();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: whiteOpacity5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TeamInfoVertical(
                          teamName: "${widget.matchInfo.homeTeam?.name}",
                          teamImage: "${widget.matchInfo.homeTeam?.imgUrl}"),
                      matchState == DataLoadState.loaded
                          ? widgetPerMatchStatus(
                              matchStatus: _match!.status,
                              homeTeamScore: _match!.homeTeamScore,
                              awayTeamScore: _match!.awayTeamScore,
                              date: convertToDateTime(_match!.matchDate,
                                  widget.matchInfo.startingAt),
                              dateFontSize: fontSize18)
                          : matchDetailsSkeleton(context: context),
                      TeamInfoVertical(
                          teamName: "${widget.matchInfo.awayTeam?.name}",
                          teamImage: "${widget.matchInfo.awayTeam?.imgUrl}"),
                    ],
                  ),
                  if (isMatchNotCounted(_match))
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "${notCountedMessage.tr()} ${capitalizeFirstWord(_match!.status.toLowerCase()).tr()}",
                        style: TextStyle(fontSize: fontSize11, color: redColor),
                      ).tr(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            defaultSkeleton(
              context: context,
              loadState: matchState,
              errorWidget: predictionSkeleton(context: context),
              loadingWidget: predictionSkeleton(context: context),
              dataWidget: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: whiteOpacity5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Predict Match Result").tr(),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(widget.types.length, (i) {
                        TypeModel type = widget.types[i];
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: type.inputType?.toLowerCase() ==
                                    inputType.text.name
                                ? TextWithInput(
                                    text: type.name,
                                    textColor: whiteColor,
                                    heightSpacing: 0,
                                    crossAxisAlignment: isArabic(type.name)
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    widget: TextInputWidget(
                                      hintText: '${type.name}',
                                      controller: _controllers[type.id]!,
                                      maxLines: 1,
                                      readOnly: isPredicted,
                                    ),
                                  )
                                : type.inputType?.toLowerCase() ==
                                        inputType.number.name
                                    ? TextWithInput(
                                        text: type.name,
                                        textColor: whiteColor,
                                        heightSpacing: 0,
                                        crossAxisAlignment: isArabic(type.name)
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        widget: TextInputWidget(
                                          hintText: '${type.name}',
                                          controller: _controllers[type.id]!,
                                          keybType: TextInputType.number,
                                          maxLines: 1,
                                          readOnly: isPredicted,
                                        ))
                                    : type.fields[0].toString().toLowerCase() ==
                                            fields.result.name
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                PredictionButtonWidget(
                                                  backgroundColor:
                                                      predictionTeam ==
                                                              _match
                                                                  ?.homeTeam?.id
                                                          ? secondaryColor
                                                          : null,
                                                  onPressed:
                                                      predictionTeam != null
                                                          ? null
                                                          : () {
                                                              setState(() {
                                                                predictionTeam =
                                                                    _match
                                                                        ?.homeTeam
                                                                        ?.id;
                                                              });
                                                            },
                                                  child: CachedImageNetwork(
                                                    image:
                                                        "${widget.matchInfo.homeTeam?.imgUrl}",
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                PredictionButtonWidget(
                                                  backgroundColor:
                                                      predictionTeam == "draw"
                                                          ? secondaryColor
                                                          : null,
                                                  onPressed:
                                                      predictionTeam != null
                                                          ? null
                                                          : () {
                                                              setState(() {
                                                                predictionTeam =
                                                                    'draw';
                                                              });
                                                            },
                                                  child: Text("Draw",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  fontSize12,
                                                              color:
                                                                  whiteColor))
                                                      .tr(),
                                                ),
                                                PredictionButtonWidget(
                                                  backgroundColor:
                                                      predictionTeam ==
                                                              _match
                                                                  ?.awayTeam?.id
                                                          ? secondaryColor
                                                          : null,
                                                  onPressed:
                                                      predictionTeam != null
                                                          ? null
                                                          : () {
                                                              setState(() {
                                                                predictionTeam =
                                                                    _match
                                                                        ?.awayTeam
                                                                        ?.id;
                                                              });
                                                            },
                                                  child: CachedImageNetwork(
                                                    image:
                                                        "${widget.matchInfo.awayTeam?.imgUrl}",
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : type.fields.toString().contains(
                                                    fields.home.name) &&
                                                type.fields
                                                    .toString()
                                                    .contains(fields.away.name)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    Text("Match Score").tr(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          isMobile(context)
                                                              ? MainAxisAlignment
                                                                  .spaceBetween
                                                              : MainAxisAlignment
                                                                  .spaceAround,
                                                      children: [
                                                        TeamScorePrediction(
                                                            image:
                                                                "${widget.matchInfo.homeTeam?.imgUrl}",
                                                            teamScore:
                                                                homeTeamScore ??
                                                                    0,
                                                            onPlusPressed:
                                                                isPredicted
                                                                    ? null
                                                                    : () {
                                                                        setState(
                                                                            () {
                                                                          if (homeTeamScore ==
                                                                              null) {
                                                                            homeTeamScore =
                                                                                1;
                                                                          } else {
                                                                            homeTeamScore++;
                                                                          }
                                                                        });
                                                                      },
                                                            onMinusPressed:
                                                                isPredicted
                                                                    ? null
                                                                    : () {
                                                                        setState(
                                                                            () {
                                                                          if (homeTeamScore != null &&
                                                                              homeTeamScore > 0) {
                                                                            homeTeamScore--;
                                                                          }
                                                                        });
                                                                      }),
                                                        const SizedBox(
                                                            width: 71),
                                                        TeamScorePrediction(
                                                            image:
                                                                "${widget.matchInfo.awayTeam?.imgUrl}",
                                                            teamScore:
                                                                awayTeamScore ??
                                                                    0,
                                                            onPlusPressed:
                                                                isPredicted
                                                                    ? null
                                                                    : () {
                                                                        setState(
                                                                            () {
                                                                          if (awayTeamScore ==
                                                                              null) {
                                                                            awayTeamScore =
                                                                                1;
                                                                          } else {
                                                                            awayTeamScore++;
                                                                          }
                                                                        });
                                                                      },
                                                            onMinusPressed:
                                                                isPredicted
                                                                    ? null
                                                                    : () {
                                                                        setState(
                                                                            () {
                                                                          if (awayTeamScore != null &&
                                                                              awayTeamScore > 0) {
                                                                            awayTeamScore--;
                                                                          }
                                                                        });
                                                                      })
                                                      ],
                                                    )
                                                  ])
                                            : Container());
                      }),
                    ),
                    const SizedBox(height: 20),
                    !isPredicted
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppButton(
                                  onPressed: () => _submitPredictionWithPackage(packageId),
                                  text: 'Submit',
                                  color: secondaryColor,
                                  width: 120,
                                  isLoading: isLoading),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            MatchDetailsWidget(
                title: "Match Details",
                matchDate: widget.matchInfo.matchDate,
                startingAt: widget.matchInfo.startingAt,
                championshipName: "${widget.matchInfo.championship?.name}",
                endTime: getMatchDateTime(
                    widget.matchInfo.matchDate, widget.matchInfo.startingAt)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  getMatchInfo() async {
    final response =
        await matchProvider?.getMatchPerId(id: widget.matchInfo.id);

    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      var dataValue = response.data;
      _match = MatchModel.fromJson(dataValue);
      matchState = DataLoadState.loaded;
      if (_match!.predictionValues.isNotEmpty) {
        isPredicted = true;
        // Loop through predictions and assign values to the controllers
        for (PredictionModel prediction in _match!.predictionValues) {
          int typeId = prediction.typeId;
          var predValue = prediction.predictionValue;

          if (prediction.predictionValue.containsKey(fields.result.name)) {
            predictionTeam = predValue[fields.result.name];
          } else if (prediction.predictionValue.containsKey(fields.home.name) &&
              prediction.predictionValue.containsKey(fields.away.name)) {
            homeTeamScore = predValue[fields.home.name];
            awayTeamScore = predValue[fields.away.name];
          } else if (_controllers.containsKey(typeId)) {
            // Find the type to get the dynamic key
            final type = widget.types.firstWhere((t) => t.id == typeId);
            if (predValue.containsKey(type.fields[0])) {
              _controllers[typeId]?.text = predValue[type.fields[0]].toString();
            }
          }
        }
      }
    } else {
      appSnackBar(
          context: context, msg: response.data['message'], isError: true);
      matchState = DataLoadState.error;
    }

    setState(() {
      matchState;
      _match;
      isPredicted;
      predictionTeam;
      homeTeamScore;
      awayTeamScore;
    });
  }


  _preloadChampionshipPackages() async {
    final now = DateTime.now();
    // print("matcheslistttttttt: ${matches.campaign} -- ${matches.campaign?.weekNumber}");
    final results = await Future.wait<dynamic>([
      storeProvider!.getChampionshipPackages(championshipId: widget.matchInfo.championshipId, type: types.daily.name),
      storeProvider!.getDailyUserActivePackage(championshipId: widget.matchInfo.championshipId, dateNow: getLocalDate(now.toString())),
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
        showDailyPackages(packages: championshipPackages);
      }else {
        setState(() {
          packageId = userActivePckg['storepackageId'];
        });
      }
    }
  }

  showDailyPackages({List packages = const []}) async {
    if (packages.isEmpty) {
      appSnackBar(
        context: context,
        msg: "No packages available for this championship.",
        isError: true,
      );
      return;
    }

    // Show the packages dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChampionshipPackagesDialog(
          packages: packages,
          onPackageSelected: (int packageId) async {
            // Call the actual prediction method with the selected package
            // await _submitPredictionWithPackage(packageId);
            setState(() {
              packageId = packageId;

              saveSelectedPackage(packageId);
            });
          },
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              isLoading = false;
            });
          },
          onNavigateToStore: () => nextScreen(context, Inventory()),
        );
      },
    );
  }

  Future<void> _submitPredictionWithPackage(int? packageId) async {
    if(packageId == null){
      appSnackBar(context: context, msg: 'You must use a coupon so you can predict', isWarning: true);
      return;
    }
    List<Map<String, dynamic>> predictions = widget.types.map((type) {
      Map<String, dynamic> predictionValue = {};

      for (var field in type.fields) {
        String fieldName = field.toString().toLowerCase();

        if (fieldName == fields.result.name.toLowerCase()) {
          predictionValue[fields.result.name] = predictionTeam;
        } else if (fieldName == fields.home.name.toLowerCase()) {
          predictionValue[fields.home.name] = homeTeamScore;
        } else if (fieldName == fields.away.name.toLowerCase()) {
          predictionValue[fields.away.name] = awayTeamScore;
        } else {
          // Handle other input fields (text, number)
          var text = _controllers[type.id]?.text.trim();
          if (text != null && text.isNotEmpty) {
            predictionValue[field] = text;
          }
        }
      }

      return {
        "matchId": _match?.id,
        "typeId": type.id,
        "championshipId": widget.matchInfo.championshipId,
        "packageId": packageId, // Use the selected package ID
        "predictionValue": predictionValue,
      };
    }).where((pred) {
      final predictionValue = pred["predictionValue"] as Map?;
      if (predictionValue == null) return false;

      return predictionValue.values.any(
        (val) => val != null && val.toString().trim().isNotEmpty,
      );
    }).toList();

    if (predictions.isEmpty) {
      appSnackBar(
        context: context,
        msg: "Please fill at least one prediction before submitting.",
        isError: true,
      );
      return;
    }

    Response response =
        await matchProvider?.submitDailyPrediction(data: predictions);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! <= 399) {
      appSnackBar(context: context, msg: "Voted Successfully!");
      setState(() {
        isPredicted = true;
      });
    } else {
      appSnackBar(
          context: context, msg: response.data['message'], isError: true);
    }
  }

  saveSelectedPackage(packageId) async {
    final now = DateTime.now();
    var data = {
      'packageId': packageId,
      "dateNow": getLocalDate(now.toString()),
    };
    Response response =
    await storeProvider?.chosenLanternDaily(context: context, data: data);
    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      appSnackBar(context: context, msg: 'Voucher chosen successfully'.tr());
      Navigator.pop(context);
    }else{
      appSnackBar(context: context, msg: response.data['message']);
    }
  }
}
