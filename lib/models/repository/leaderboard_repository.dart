

import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/models/services/auth_service.dart';
import 'package:ahzir/models/services/dio_service.dart';
import 'package:ahzir/models/services/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LeaderboardRepository{
  final DioService dioService = DioService();

  leaderBoardPerTournament({required BuildContext context, required String uri, required data}) async{
    Response response =  await dioService.get(uri: uri, data: data);
    return response;
  }
}