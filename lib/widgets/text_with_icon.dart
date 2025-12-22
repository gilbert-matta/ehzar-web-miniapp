import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class TextWithIcon extends StatelessWidget {
  final String text;
  final Widget icon;
  final void Function()? onPressed;

  const TextWithIcon(
      {required this.text,
      required this.icon,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text).tr(),
          SizedBox(
              height: 28,
              child: IconButton(
                icon: icon,
                onPressed: onPressed,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ))
        ],
      ),
    );
  }
}
