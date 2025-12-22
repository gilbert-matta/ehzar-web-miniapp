

import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class TextWithInput extends StatelessWidget {
  String? text;
  Widget widget;
  double? heightSpacing;
  CrossAxisAlignment? crossAxisAlignment;
  TextAlign? textAlign;
  Color? textColor;

  TextWithInput({
    required this.text,
    required this.widget,
    this.heightSpacing,
    this.crossAxisAlignment,
    this.textAlign,
    this.textColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,//the default is center
      children: [
        Text('$text', style: TextStyle(
          color: textColor ?? secondaryColor,
          fontSize: fontSize16,
          fontStyle: FontStyle.normal
        ), textAlign: textAlign).tr(),
        SizedBox(height: heightSpacing ?? 10,),
        widget,
      ],
    );
  }
}
