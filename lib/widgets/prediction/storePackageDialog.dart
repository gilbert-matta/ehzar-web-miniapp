

import 'dart:async';

import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

lanternDialog({required BuildContext context, title, content, void Function()? onPressed, FutureOr<dynamic> Function(dynamic)? onValue}){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(title, style: TextStyle(
            fontFamily: sfArabicRegular,
            color: grey700
        ),).tr(),
        content: content,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor
              ),
              onPressed: onPressed,
              child: Text('skip', style: TextStyle(
                fontFamily: sfArabicRegular,
              ),).tr()
          ),
        ],
      );
    },
  ).then(onValue ?? (val){});
}