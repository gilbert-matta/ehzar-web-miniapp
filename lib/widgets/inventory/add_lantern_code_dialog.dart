import 'dart:async';
import 'package:ahzir/hexColor/hex_color.dart';
import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

addLanternCodeDialog({
  required BuildContext context,
  required String title,
  required void Function()? onPressed,
  required String actionBtnText,
  required Widget? content,
  FutureOr<dynamic> Function(dynamic)? onValue,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize22,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ).tr(),

              const SizedBox(height: 20),

              /// Custom Content (TextField, Message, etc.)
              if (content != null) content,

              const SizedBox(height: 25),

              /// Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onPressed ?? () => Navigator.pop(context),
                  child: Text(
                    actionBtnText,
                    style: TextStyle(
                      fontSize: fontSize16,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ).tr(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).then(onValue ?? (val) {});
}
