

import 'package:ahzir/models/services/service.dart';

class GroupRepository{
  final Service service = Service();

  getUserGroup({required String uri, required data}) async{
    return await service.get(uri: uri, data: data);
  }

}