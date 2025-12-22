import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/functions.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/article_model.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/article_view_model.dart';
import 'package:ahzir/widgets/alert_dialogs/alert_dialog.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/commun/shared/item_content.dart';
import 'package:ahzir/widgets/error/errorDialog.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/news/news_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class Articles extends StatefulWidget {
  const Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  final ScrollController _articleController = ScrollController();
  List<ArticleModel> articles = [];
  DataLoadState articlesState = DataLoadState.loading;
  String? errorArticles;
  int _page = 1;
  int limit = 10;
  bool _isLoadingData = false;
  ArticleViewModel? _articleProvider;
  bool dataFinishedOnScroll = false;

  @override
  void initState() {
    _articleProvider = Provider.of<ArticleViewModel>(context, listen: false);
    getArticles();
    _articleController.addListener(() {
      if (!_isLoadingData &&
          _articleController.position.pixels ==
              _articleController.position.maxScrollExtent) {
        if (isMobile(context)) {
          getArticles();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Top News',
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildContent(
              dataLoadState: articlesState,
              errorWidget: ErrorTextPage(errorText: errorArticles),
              loadingWidget: matchSkeleton(context: context, listLength: 10),
              loadedWidget: articles.isNotEmpty ? SingleChildScrollView(
                controller: _articleController,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    ...List.generate(
                        articles.length + (_isLoadingData ? 1 : 0), (int i) {
                      if (i < articles.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: NewsWidget(
                            title: articles[i].title,
                            image: articles[i].mediaCover,
                            date: articles[i].articleDate,
                            onTap: () => nextScreen(context, ItemContent(notificationId: null, article: articles[i])),
                          ),
                        );
                      } else {
                        if (isMobile(context)) {
                          return const CircularProgressWidget();
                        }
                        return Container();
                      }
                    }),
                    !isMobile(context) && dataFinishedOnScroll == false
                        ? Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: AppButton(
                            width: 150,
                            height: 42,
                            color: secondaryColor,
                            isLoading: _isLoadingData,
                            onPressed: () => getArticles(),
                            text: 'load more'),
                      ),
                    )
                        : Container()
                  ],
                ),
              ) : Center(
                child: Text("No data found!", style: TextStyle(
                  fontSize: fontSize14,
                  color: whiteColor,
                ),).tr(),
              ),
            ),
          )
        ],
      ),
    );
  }

  getArticles() async {
    if (!_isLoadingData && !dataFinishedOnScroll) {
      setState(() {
        _isLoadingData = true;
      });
      Response response = await _articleProvider?.getArticles(
          context: context, page: _page, limit: limit);
      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> tempArticles = response.data['articles'];
        List<ArticleModel> articleItems =
            tempArticles.map((e) => ArticleModel.fromJson(e)).toList();
        articles.addAll(articleItems);

        if (tempArticles.length < limit) {
          dataFinishedOnScroll = true;
        }

        articlesState = DataLoadState.loaded;
        _page++;
      } else {
        if (_page == 1) {
          articlesState = DataLoadState.error;
          errorArticles = response.data['message'];
        } else {
          ErrorDialog(
            context: context,
            error: response.data['message'],
          );
        }
      }
      setState(() {
        articles;
        _isLoadingData = false;
        _page;
        articlesState;
        errorArticles;
      });
    }
  }
}
