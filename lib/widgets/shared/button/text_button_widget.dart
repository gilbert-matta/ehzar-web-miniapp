
import 'package:ahzir/index.dart';

class TextButtonWidget extends StatelessWidget {
  Color? btnColor;
  String text;
  Color? textColor;
  double? btnHeight;
  double? textFontSize;
  void Function()? onTap;

  TextButtonWidget({
    required this.text,
    required this.onTap,
    this.textColor,
    this.textFontSize,
    this.btnColor,
    this.btnHeight,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: btnHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            color: btnColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text, style: TextStyle(
              fontSize: textFontSize ?? fontSize14,
              color: textColor
          )),
        ),
      ),
    );
  }
}
