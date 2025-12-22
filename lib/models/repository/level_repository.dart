

import 'package:ahzir/models/services/service.dart';

class LevelRepository{
  final Service service = Service();

  getUserLevel({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

}