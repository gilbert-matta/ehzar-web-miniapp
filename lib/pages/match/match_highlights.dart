import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/vod_model.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/cards/horizontal_info_card.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MatchHighlights extends StatefulWidget {
  final int matchId;

  const MatchHighlights({required this.matchId, super.key});

  @override
  State<MatchHighlights> createState() => _MatchHighlightsState();
}

class _MatchHighlightsState extends State<MatchHighlights> {
  YoutubePlayerController? youtubeController;
  List<VodModel> vodList = [];
  MatchViewModel? matchProvider;
  int getVideoChosen = 0;
  bool _isLoadingData = false;
  final ScrollController _scrollController = ScrollController();
  DataLoadState highlightState = DataLoadState.loading;
  String? highlightError;
  int _pageHighlights = 1;
  bool _isFinishedLoadMore = false;

  @override
  void initState() {
    super.initState();
    matchProvider = Provider.of<MatchViewModel>(context, listen: false);
    getMatchHighlights();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMatchHighlights();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (youtubeController != null) {
      youtubeController?.dispose(); // Dispose the controller properly
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Match Highlights",
      ),
      body: defaultSkeleton(
        context: context,
        loadState: highlightState,
        errorWidget: ErrorPage(
            errorText: highlightError,
            onPressed: () {
              setState(() {
                highlightError = null;
                highlightState = DataLoadState.loading;
                getMatchHighlights();
              });
            }),
        loadingWidget: matchHighlightsSkeleton(),
        dataWidget: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Only display the YouTube player when it's initialized
                if (youtubeController != null)
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: youtubeController!,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: primaryColor,
                      progressColors: ProgressBarColors(
                        playedColor: primaryColor,
                        handleColor: primaryColor,
                      ),
                      onEnded: (metaData) {
                        // Unlock orientation after the video ends
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                      },
                    ),
                    builder: (context, player) {
                      return player;
                    },
                  ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "More Highlights",
                        style: TextStyle(fontSize: fontSize18),
                      ).tr(),
                      const SizedBox(height: 10),
                      ...List.generate(
                          vodList.length + (_isLoadingData ? 1 : 0), (i) {
                        if (i < vodList.length) {
                          return Column(
                            children: [
                              Divider(
                                height: 30,
                                thickness: 0.2,
                                indent: 0,
                                endIndent: 0,
                                color: whiteColor,
                              ),
                              HorizontalInfoCard(
                                  text: vodList[i].title,
                                  image: vodList[i].image,
                                  containerColor: getVideoChosen == i
                                      ? whiteOpacity20
                                      : null,
                                  onTap: () {
                                    _animateToIndex(0.0);
                                    setState(() {
                                      getVideoChosen = i;
                                      clickedVideo(vodList[i].link);
                                    });
                                  }),
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(color: whiteColor),
                          );
                        }
                      })
                    ],
                  ),
                ),

                // Column(
                //   children: List.generate(
                //       episodes!.episodes!.length + (_isLoadingData ? 1 : 0), (i) {
                //     if (i < episodes!.episodes!.length) {
                //       return ArticleItems(
                //         id: episodes!.episodes![i].id,
                //         image: episodes!.episodes![i].image,
                //         text: episodes!.episodes![i].title,
                //         textColor: greyColor,
                //         description: episodes!.episodes![i].subTitle,
                //         date: 'المدة: ${durationCheck(episodes!.episodes![i].duration.toString())}',
                //         showDate: true,
                //         isGridView: false,
                //         padding: EdgeInsets.symmetric(vertical: 5),
                //         containerColor: getEpisodeChosen == i
                //             ? Colors.grey.shade300
                //             : null,
                //         descriptionMaxLines: 2,
                //         textDescOverflow: TextOverflow.ellipsis,
                //         spaceBetweenTexts: 3,
                //         textFontSize: fontSize14,
                //         onTap: () {
                //           _animateToIndex(0.0);
                //           setState(() {
                //             getEpisodeChosen = i;
                //             clickedVideo(episodes!.episodes?[i].streamUrl);
                //           });
                //         },
                //       );
                //     } else {
                //       return Center(
                //         child: CircularProgressIndicator(color: primaryColor),
                //       );
                //     }
                //   }),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getMatchHighlights() async {
    if (!_isLoadingData && !_isFinishedLoadMore) {
      setState(() {
        _isLoadingData = true;
      });
      Response response = await matchProvider?.getVideosPerMatchId(
          matchId: widget.matchId, page: _pageHighlights, limit: 10);

      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> vodTemp = response.data['data'];
        List<VodModel> videos = vodTemp.map((vodJson) {
          // Create the VodModel instance
          VodModel vod = VodModel.fromJson(vodJson);
          // Get video ID from URL
          String? videoId = YoutubePlayer.convertUrlToId(vod.link);
          if (videoId != null) {
            // Add thumbnail URL to the model
            // Using high quality thumbnail: https://img.youtube.com/vi/$videoId/hqdefault.jpg
            vod.image = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
          }
          return vod;
        }).toList();

        if (videos.length < 10) {
          _isFinishedLoadMore = true;
        }
        vodList.addAll(videos);
        if (vodList.isNotEmpty && youtubeController == null) {
          String? videoId = YoutubePlayer.convertUrlToId(vodList[0].link);
          if (videoId != null) {
            youtubeController = YoutubePlayerController(
              initialVideoId: videoId,
              flags: YoutubePlayerFlags(
                autoPlay: false,
                isLive: false,
                loop: false,
              ),
            );
          }
        }
        highlightState = DataLoadState.loaded;
        _isLoadingData = false;
        _pageHighlights++;
      } else {
        _isLoadingData = false;
        if (_pageHighlights == 1) {
          highlightError = response.data['message'];
          highlightState = DataLoadState.error;
        } else {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        }
      }

      setState(() {
        vodList;
        highlightState;
        _isLoadingData;
        _pageHighlights;
        _isFinishedLoadMore;
      });
    }
  }

  void clickedVideo(String streamUrl) {
    if (youtubeController != null) {
      // Extract video ID from the URL
      String? videoId = YoutubePlayer.convertUrlToId(streamUrl);
      if (videoId != null) {
        // Pause the current video before switching
        youtubeController!.pause();
        // Load the new video (instead of creating a new controller)
        youtubeController!.load(videoId);
        // Ensure the UI updates
        setState(() {});
      }
    }
  }

  _animateToIndex(double index) {
    _scrollController.animateTo(index,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }
}
