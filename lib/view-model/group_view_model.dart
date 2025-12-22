
import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/models/repository/group_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GroupViewModel extends ChangeNotifier{

  getGroup() async{
    Response res = await GroupRepository().getUserGroup(uri: "${BaseUrls.version}${BaseUrls.group}/${BaseUrls.user}", data: null);
    return res;
  }
}