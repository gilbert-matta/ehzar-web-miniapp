
import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/models/repository/level_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LevelViewModel extends ChangeNotifier{
  final LevelRepository levelRepository;

  LevelViewModel({
    required this.levelRepository, //this is how we use the DI we inject its dependencies
  });

  getUserLevel() async{
    Response res = await levelRepository.getUserLevel(uri: "${BaseUrls.version}${BaseUrls.level}", data: null);
    return res;
  }
}