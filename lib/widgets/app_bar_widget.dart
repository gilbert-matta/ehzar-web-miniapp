

import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final double? titleSpacing;
  final Widget? leading;
  final bool? centerTitle;
  final double? toolbarHeight;
  final PreferredSizeWidget? bottom;
  IconThemeData? iconTheme;
  Color? backgroundColor;

  AppBarWidget({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.titleSpacing,
    this.leading,
    this.centerTitle,
    this.toolbarHeight,
    this.bottom,
    this.iconTheme,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      iconTheme: iconTheme ?? IconThemeData(color: whiteColor),
      elevation: 0,
      leading: leading,
      titleSpacing: titleSpacing ?? 0,
      centerTitle: centerTitle,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      title: title != null ? Text("$title", style: TextStyle(
        fontSize: fontSize20,
        letterSpacing: 0.4,
        color: whiteColor,
        fontStyle: FontStyle.normal,
        // fontFamily: sfArabicRegular
      ),).tr() : titleWidget,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
