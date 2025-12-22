

import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/article_model.dart';
import 'package:ahzir/models/repository/article_repository.dart';
import 'package:dio/dio.dart';

class ArticleViewModel extends ChangeNotifier{


  getArticles({required BuildContext context, required int page, required int limit, String? q, int? categoryId }) async{
      var data = {
        'page': page,
        'limit': limit,
        'q': q,
        'categoryId': categoryId
      };
      Response res = await
      ArticleRepository().articlesPerPage(context: context, uri: "v1/${BaseUrls.articles}", data: data);
      return res;
    // notifyListeners();
  }


  Map<String, dynamic> getArticlesFromResponse(var response) {
    Map<String, dynamic> result = {'data': null, 'error': null};

    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      List<dynamic> dataValue = response.data['articles'];
      List<ArticleModel> articles =
      dataValue.map((val) => ArticleModel.fromJson(val)).toList();
      // debugPrint("upcMatches: $upcomingMatches");
      result['data'] = articles;
    } else {
      // debugPrint("Error: ${response.data}");
      result['error'] = response.data['message'];
    }

    return result;
  }

}