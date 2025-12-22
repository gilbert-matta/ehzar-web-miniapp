


import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'dart:ui' as ui;

class UserReceiveWidget extends StatelessWidget {
  final String userFirstName;
  final String userLastName;
  final String message;
  final String date;

  const UserReceiveWidget({
    required this.userFirstName,
    required this.userLastName,
    required this.message,
    required this.date,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context)
                  .size
                  .width *
                  0.7,
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomRight:
                    Radius.circular(10)),
                color: secondaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth:
                          MediaQuery.of(context)
                              .size
                              .width *
                              0.6),
                      child: Text(
                          "$userFirstName $userLastName",
                          style: TextStyle(
                              fontSize: fontSize12,
                          color: grey700),
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text("$message"),
                const SizedBox(height: 5),
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Text(
                    "${localTime(date)}",
                    style: TextStyle(
                        fontSize: fontSize8,
                    color: grey700),
                  ),
                ),
                // Text(
                //   formatDate(date),
                //   style: TextStyle(fontSize: fontSize8),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
