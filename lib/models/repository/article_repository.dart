


import 'package:ahzir/models/model/article_model.dart';
import 'package:ahzir/models/services/service.dart';
import 'package:ahzir/index.dart';
import 'package:dio/dio.dart';

class ArticleRepository {
  Service _service = Service();

  articlesPerPage({required BuildContext context, required String uri, required data}) async{
    Response response =  await _service.get(uri: uri, data: data);
    return response;
  }

}