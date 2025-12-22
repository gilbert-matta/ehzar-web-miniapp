

import 'package:ahzir/index.dart';
import 'package:ahzir/models/services/service.dart';

class TeamRepository{
  final Service service = Service();

  teamPerLeagueId({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

  saveUserFavTeams({required String uri, required data}) async{
    return await service.put(uri: uri, data: data);
  }

  getUserFavTeams({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

}