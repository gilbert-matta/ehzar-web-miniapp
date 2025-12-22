

import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';

class IconCardButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Gradient? gradient;
  final Color? color;
  final Color? shadowColor;
  final BorderRadiusGeometry? borderRadius;
  final Icon icon;

  const IconCardButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.gradient,
    this.color,
    this.shadowColor,
    this.borderRadius,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: blueMauveLinearGrad,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17), bottomRight: Radius.circular(17), topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      padding: EdgeInsets.only(left: 1, right: 1, top: 1),
      child: Container(
        width: 250,
        height: 202,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: primaryColor,
          // border: Border.all(color: secondaryColor),
        ),
        child: Column(
          children: [
            icon,
            AppButton(
                onPressed: onPressed,
                text: text,
                borderRadius: borderRadius,
                gradient: gradient,//blueMauveLinearGrad,
                color: color,//Colors.transparent,
                shadowColor: shadowColor,//Colors.transparent
            ),
          ],
        ),
      ),
    );
  }
}
