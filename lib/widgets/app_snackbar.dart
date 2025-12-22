import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/pages/cart.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ahzir/index.dart';
import 'dart:ui' as ui;

void appSnackBar(
    {required BuildContext context,
    required String msg,
    bool isCart = false,
    bool isError = false,
    bool isWarning = false}) {
  // Check if the current context is still valid
  if (!context.mounted) return;

  final snackBar = SnackBar(
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    content: Directionality(
      textDirection: ui.TextDirection.rtl,
      // For the Arabic language, this prevents breaking the design
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: snackBarColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isError
                          ? snackBarRedWithOp
                          : isWarning
                              ? snackBarYellowWithOp
                              : snackBarGreenWithOp,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                          "$staticImgUrl/${isError ? 'fail.svg' : isWarning ? 'warning.svg' : 'success.svg'}"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            msg,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize12,
                                fontFamily: sfArabicRegular),
                          ).tr(),
                        ],
                      ),
                    ),
                  ),
                  !isCart
                      ? AppButton(
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          onPressed: () {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar();
                            }
                          },
                          text: 'Close',
                          textFontSize: fontSize16,
                          textColor: isError
                              ? redColor
                              : isWarning
                                  ? yellowColor
                                  : snackBarGreen,
                          suffix: Row(
                            children: [
                              const SizedBox(width: 5),
                              Icon(
                                Icons.close,
                                color: isError
                                    ? redColor
                                    : isWarning
                                        ? yellowColor
                                        : snackBarGreen,
                              ),
                            ],
                          ),
                        )
                      : AppButton(
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          onPressed: () {
                            if (context.mounted) {
                              nextScreen(context, Cart());
                            }
                          },
                          text: 'Cart',
                          textFontSize: fontSize16,
                          textColor: isError
                              ? redColor
                              : isWarning
                                  ? yellowColor
                                  : snackBarGreen,
                          suffix: Row(
                            children: [
                              const SizedBox(width: 5),
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: isError
                                    ? redColor
                                    : isWarning
                                        ? yellowColor
                                        : snackBarGreen,
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 4),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
