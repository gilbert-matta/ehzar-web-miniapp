
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/radio/radio_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:easy_localization/easy_localization.dart';

void showPrivacyPolicyDialog({
  required policyTitle,
  required policyContent,
  required BuildContext context,
  required Object? groupValue,
  required void Function()? onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (stfContext, stfSetState) {
        return AlertDialog(
          title: Text(policyTitle ?? "Privacy Policy").tr(),
          backgroundColor: blackColor,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(policyContent),
                // Add more policy sections here.
                RadioWidget(groupValue: groupValue, value: true, text: "Accept Privacy Policy", onChanged: (value){
                  // debugPrint("accept vall: $value -- $groupValue");
                  stfSetState(() {
                    groupValue = value;
                  });
                }),
              ],
            ),
            ),
            actions: [
              AppButton(
                  width: 100,
                  color: Colors.transparent,
                  textColor: groupValue == null ? Colors.white.withOpacity(0.2) : secondaryColor,
                  onPressed: groupValue == null ? null : (){
                    Navigator.pop(context);
                    onPressed!();
                  },
                  text: "Agree"
              ),
            ],
        );
      });
    },
  );
}



void CMSDialog({
  required title,
  required content,
  required BuildContext context,
  required void Function()? onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (stfContext, stfSetState) {
        return AlertDialog(
          title: Text("${title ?? ''}").tr(),
          backgroundColor: blackColor,
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${content ?? ''}"),
              ],
            ),
          ),
          actions: [
            AppButton(
                width: 100,
                color: Colors.transparent,
                textColor: secondaryColor,
                onPressed: (){
                  Navigator.pop(context);
                  onPressed!();
                },
                text: "Agree"
            ),
          ],
        );
      });
    },
  );
}