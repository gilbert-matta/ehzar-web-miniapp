

import 'package:ahzir/models/services/service.dart';
import 'package:dio/dio.dart';

class MatchRepository{
  final Service service = Service();

  getMatches({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

  getLeaderboard({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

  getDailyMatches({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

  getFavMatches({required String uri, required data}) async{
    Response res = await service.get(uri: uri, data: data);
    return res;
  }

  matchPerId({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

  setMatchPredictions({required String uri, required data}) async{
    return await service.post(uri: uri, data: data);
  }

  getVideosPerMatchId({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

}