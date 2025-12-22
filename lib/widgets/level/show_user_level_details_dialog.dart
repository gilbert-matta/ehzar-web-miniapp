


import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/level_model.dart';
import 'package:ahzir/models/model/user_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:percent_indicator/linear_percent_indicator.dart';

showUserLevelDetailsDialog({
  required BuildContext context,
  required LevelModel level,
  required UserModel user,
}){
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: tertiaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 200,
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                                child: CachedImageNetwork(
                                  image: level.logo,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 140,
                                child: Directionality(
                                  textDirection: isArabic(user.firstName) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                  child: Text("${user.firstName} ${user.lastName}", style: TextStyle(
                                    color: whiteColor,
                                    fontSize: fontSize16
                                  ), overflow: TextOverflow.ellipsis, textAlign: isArabic(user.firstName) ? TextAlign.end : TextAlign.start),
                                ),
                              ),
                              const SizedBox(height: 20),
                              LinearPercentIndicator(
                                percent: (level.userTotalPoints - level.minPoints) / level.maxPoints,
                                width: 140,
                                animation: true,
                                barRadius: Radius.circular(12),
                                padding: const EdgeInsets.all(0),
                                backgroundColor: whiteColor,
                                progressColor: Colors.blue,
                              ),
                              const SizedBox(height: 5),
                              Directionality(
                                textDirection: ui.TextDirection.ltr,
                                child: Text("${numberWithComma(level.userTotalPoints)} / ${level.maxPoints} pts", style: TextStyle(
                                    fontSize: fontSize12,
                                    color: whiteColor
                                ),),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${level.name} ", style: TextStyle(
                              fontSize: fontSize18,
                              fontWeight: FontWeight.bold,
                            color: secondaryColor
                          )),
                          Text(":${'Level'.tr()}", style: TextStyle(
                            fontSize: fontSize18
                          ),),
                        ],
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.highlight_remove_outlined, color: whiteColor), splashRadius: 15),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}