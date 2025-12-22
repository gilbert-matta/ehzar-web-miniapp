

import 'package:ahzir/models/services/service.dart';

class ChampionshipRepository{
  final Service service = Service();

  getTournaments({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

}