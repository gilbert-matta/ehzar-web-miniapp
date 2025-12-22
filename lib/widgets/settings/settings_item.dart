
import 'package:ahzir/globals/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  void Function()? onTap;
  String text;
  IconData? icon;
  Color? iconColor;
  Color? textColor;
  String? image;
  Color? imageColor;
  Widget? imageWidget;

  SettingsItem({
    Key? key,
    required this.onTap,
    required this.text,
    this.icon,
    this.iconColor,
    this.textColor,
    this.image,
    this.imageColor,
    this.imageWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon != null ? Icon(icon, size: 28, color: iconColor,) : Container(),
                image != null ? Image.asset("$image", width: 28, height: 28, color: imageColor,) : Container(),
                if(imageWidget != null) imageWidget!,
                const SizedBox(width: 10,),
                Text(text, style: TextStyle(
                  color: textColor ?? greyColor
                )).tr()
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: greyColor, size: 18)
          ],
        ),
      ),
    );
  }
}
