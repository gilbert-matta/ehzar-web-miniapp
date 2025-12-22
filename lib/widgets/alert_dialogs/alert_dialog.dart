
import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future AlertDialogWidget({required BuildContext context, title, content, void Function()? onPressed, Color? yesBackgroundColor}) async {
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
        content: Text(
          content,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: grey700,
            fontFamily: sfArabicRegular,
          ),
        ).tr(),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: greyColor
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('no', style: TextStyle(
                fontFamily: sfArabicRegular,
              ),).tr()
          ),
          const SizedBox(width: 10,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: yesBackgroundColor ?? secondaryColor
              ),
              onPressed: onPressed,
              child: Text('yes', style: TextStyle(
                fontFamily: sfArabicRegular,
              ),).tr()
          ),
        ],
      );
    },
  );
}