
import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

Future ErrorDialog({required BuildContext context, String? title, required String error, void Function()? onPressed}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(title ?? "Something went wrong!", style: TextStyle(
          fontSize: fontSize22,
          color: Colors.grey.shade800
        )).tr(),
        content: Text(
          error,
          style: TextStyle(
            fontSize: fontSize16,
            // fontFamily: cairo600,
            // fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ).tr(),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                elevation: 5,
              ),
              onPressed: onPressed ?? () => Navigator.pop(context),
              child: Text('Ok', style: TextStyle(
                color: whiteColor,
                fontSize: fontSize16,
              )).tr()
          ),
        ],
      );
    },
  );
}