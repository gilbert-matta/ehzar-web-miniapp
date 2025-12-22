
import 'package:easy_localization/easy_localization.dart';
import 'package:ahzir/index.dart';

Future ErrorDialogWidget({
  required BuildContext context,
  required String error,
  required String firstBtn,
  required void Function()? onPressedFirst,
  required String secondBtn,
  required void Function()? onPressedSecond,
}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Something went wrong!".tr(),
                style: TextStyle(
                  fontSize: fontSize24,
                  color: Colors.black, // Make sure to set a color since TextSpan doesn't inherit it
                ),
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Icon(Icons.warning_amber_rounded, color: redColor, size: 33),
                ),
              ),
            ],
          ),
        ),
        content: Text(
          error,
          style: TextStyle(
            fontSize: fontSize18,
            // fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ).tr(),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: whiteColor,
                    elevation: 5,
                  ),
                  onPressed: onPressedFirst,
                  child: Text(firstBtn, style: TextStyle(
                      color: redColor
                  )).tr()
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: whiteColor,
                      elevation: 5,
                  ),
                  onPressed: onPressedSecond,
                  child: Text(secondBtn, style: TextStyle(
                      color: darkBlue00
                  )).tr()
              ),
            ],
          )
        ],
      );
    },
  );
}