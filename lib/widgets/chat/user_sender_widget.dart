


import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'dart:ui' as ui;

class UserSenderWidget extends StatelessWidget {
  final String message;
  final String date;

  const UserSenderWidget({
    required this.message,
    required this.date,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  0.7,
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft:
                    Radius.circular(10)),
                color: whiteOpacity20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$message", textAlign: TextAlign.end),
                const SizedBox(height: 5),
                Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Text(
                    "${localTime(date)}",
                    style: TextStyle(
                        fontSize: fontSize8),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
