


import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class NotificationWidget extends StatefulWidget {
  final String? title;
  final String? body;
  // final String? date;
  void Function()? onTap;

  NotificationWidget({
    Key? key,
    required this.title,
    required this.body,
    // required this.date,
    this.onTap,
  }) : super(key: key);

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {

  late String dateFormatted;

  @override
  void initState() {
    // changeFormat(widget.date);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic(widget.title ?? widget.body) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: whiteOpacity5,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("$staticImgUrl/logo/ihzar.png", width: 30, height: Theme.of(context).brightness == Brightness.dark ? 18 : 20),
                      // Text(dateFormatted)
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(widget.title ?? '', style: TextStyle(
                    fontSize: fontSize16,
                  )),
                  const SizedBox(height: 5),
                  Text(widget.body ?? '', style: TextStyle(
                    fontSize: fontSize12,
                  ))
                ],
              ),
            )
        ),
      ),
    );
  }

  // changeFormat(date){
  //   dateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  //   setState(() {
  //     dateFormatted;
  //   });
  // }

}
