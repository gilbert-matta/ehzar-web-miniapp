

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ahzir/index.dart';

class BottomNavIcon extends StatefulWidget {
  final void Function()? onPressed;
  final int pageIndex;
  final int index;
  final Color color;
  final Color? textColor;
  final IconData? icon;
  final double? iconSize;
  final String? image;
  final double? imageWidth;
  final double? imageHeight;
  final String? title;

  const BottomNavIcon({
    super.key,
    required this.onPressed,
    required this.pageIndex,
    required this.index,
    required this.color,
    this.textColor,
    this.title,
    this.icon,
    this.iconSize,
    this.image,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  State<BottomNavIcon> createState() => _BottomNavIconState();
}

class _BottomNavIconState extends State<BottomNavIcon> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: widget.pageIndex == widget.index ? tertiaryColor : null,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: widget.pageIndex == widget.index ? 12 : 1),
            child: Row(
              children: [
                SizedBox(
                  width: widget.pageIndex == widget.index ? 26 : null,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    enableFeedback: false,
                    onPressed: widget.onPressed,
                    icon: widget.icon != null ? Icon(
                      widget.icon,
                      color: widget.pageIndex == widget.index ? widget.color : greyChateau,
                      size: widget.iconSize ?? 25,
                    ) : SizedBox(
                      width: widget.imageWidth,
                      height: widget.imageHeight,
                      child: InkWell(
                        onTap: widget.onPressed,
                        child: SvgPicture.asset("${widget.image}", color: widget.pageIndex == widget.index ? widget.color : greyChateau,),
                      ),
                    ),
                  ),
                ),
                widget.pageIndex == widget.index ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text("${widget.title}", style: TextStyle(
                    fontSize: fontSize12,
                    fontStyle: FontStyle.normal,
                    color: widget.textColor,
                  ),).tr(),
                ) : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
