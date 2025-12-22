import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/article_model.dart';
import 'package:ahzir/pages/home.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'dart:ui' as ui;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ItemContent extends StatefulWidget {
  final int? notificationId;
  final ArticleModel? article;

  const ItemContent({
    required this.notificationId,
    required this.article,
    super.key
  });

  @override
  State<ItemContent> createState() => _ItemContentState();
}

class _ItemContentState extends State<ItemContent> {
  ArticleModel? articleContent;
  DataLoadState articlesState = DataLoadState.loading;
  String? errorArticles;
  // ArticleViewModel? _articleProvider;
  double descriptionFontSize = 18.0;

  @override
  void initState() {
    getItemContent();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _close(); // Your custom logic to handle back press
        },
        child: buildContent(
            dataLoadState: articlesState,
            loadingWidget: matchSkeleton(context: context, listLength: 10),
            errorWidget: ErrorTextPage(errorText: errorArticles),
            loadedWidget: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  SelectableText("${articleContent?.title}"),
                  const SizedBox(height: 10),
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: (){
                                if(descriptionFontSize < 21.0){
                                  setState(() {
                                    descriptionFontSize ++;
                                  });
                                }
                              },
                              child: Container(
                                  width: 35,
                                  height: 35,
                                  color: Colors.blue.shade900,
                                  child: Center(
                                    child: Text("A+", style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 20
                                    ),),
                                  )
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: (){
                                if(descriptionFontSize > 15.0){
                                  setState(() {
                                    descriptionFontSize --;
                                  });
                                }
                              },
                              child: Container(
                                  width: 35,
                                  height: 35,
                                  color: Colors.blue.shade700,
                                  child: Center(
                                    child: Text("A-", style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 14
                                    ),),
                                  )
                              ),
                            ),
                          ],
                        ),
                        articleContent?.articleDate != null ?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SelectableText(convertDate("${articleContent?.articleDate}"), style: TextStyle(
                                fontSize: descriptionFontSize,
                                color: secondaryColor,
                            )),
                            Icon(Icons.watch_later_outlined, size: descriptionFontSize - 2.0, color: secondaryColor),
                          ],
                        ) : Container(),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // BannerAds(adUnitId: adUnitId[0], adSize: AdSize.banner),
                  const SizedBox(height: 10),
                  Center(child: CachedImageNetwork(image: articleContent?.mediaCover, loadingHeight: 200)),
                  const SizedBox(height: 40),
                  articleContent?.description != null ?
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: SelectionArea(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return DefaultTextStyle(
                              style: TextStyle(fontSize: descriptionFontSize, color: blackColor),
                              // textAlign: TextAlign.left, // Align text to the left
                              child: HtmlWidget(
                                "${articleContent?.description}",
                                textStyle: TextStyle(
                                  color: whiteColor
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ) : Container(),
                  const SizedBox(height: 20)
                ],
              ),
            ),
        ),
      ),
    );
  }

  getItemContent() async{
    if(widget.notificationId != null){
      // var res = await Provider.of<ArticleViewModel>(context, listen: false).getArticleById(id: widget.notificationId!, context: context);
      // if(res != 'error') {
      //   setState(() {
      //     articleContent = res;
      //   });
      //   getAllArticlesOther(widget.notificationId);
      //   videoInitialisation();
      //   description = await Provider.of<ArticleViewModel>(context, listen: false).getDescriptionPerId(context: context, id: widget.notificationId!);
      //   setState(() {
      //     description;
      //   });
      // }else{
      //   ErrorPage(page: ItemContent(notificationId: widget.notificationId, article: null));
      // }
    }else{
      setState(() {
        articleContent = widget.article;
        articlesState = DataLoadState.loaded;
        // videoInitialisation();
      });
      // description = await articleProvider?.getDescriptionPerId(context: context, id: widget.article!.id!);
      // setState(() {
      //   description;
      // });
    }
  }

  _close() {
    if(widget.notificationId != null){  // that means its from a notification
      nextScreenCloseOthers(context, Home());
    }else {
      Navigator.pop(context);
    }
  }

  // _onShare(BuildContext context) async{
  //   if(Platform.isAndroid){
  //     await Share.share(
  //       '${shareUrl}${BaseUrls.article}/${articleContent?.id}/${articleContent?.slug}',
  //     );
  //   }else{
  //     await Share.share(
  //         '${shareUrl}${BaseUrls.article}/${articleContent?.id}/${articleContent?.slug}',
  //         sharePositionOrigin: Rect.fromPoints(Offset(MediaQuery.of(context).size.width, 0.0), Offset(MediaQuery.of(context).size.width * 0.7, 100.0))
  //     );
  //   }
  // }

}
