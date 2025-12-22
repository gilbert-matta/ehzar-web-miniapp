import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  void Function()? onPressed;
  double? width;
  double? minWidth;
  double? height;
  Color? color;
  Color? textColor;
  FontWeight? textFontWeight;
  double? textFontSize;
  String? textFontFamily;
  FontStyle? textFontStyle;
  Color? borderColor;
  Color? shadowColor;
  IconData? icon;
  Color? iconColor;
  double? iconSize;
  String text;
  bool isLoading;
  BorderRadiusGeometry? borderRadius;
  Paint? textForeground;
  Gradient? gradient;
  List<BoxShadow>? boxShadow;
  Widget? suffix;

  AppButton({
    super.key,
    required this.onPressed,
    this.width,
    this.minWidth,
    this.height,
    this.color,
    this.borderColor,
    this.shadowColor,
    required this.text,
    this.textFontWeight,
    this.textFontSize,
    this.textFontFamily,
    this.textFontStyle,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.textColor,
    this.isLoading = false,
    this.borderRadius,
    this.textForeground,
    this.gradient,
    this.boxShadow,
    this.suffix,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? 0.0,
      ),
      child: Container(
        width: widget.width,
        height: widget.height ?? 40,
        decoration: BoxDecoration(
            gradient: widget.gradient ??
                (widget.color != null ? null : defaultLinearGradient),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
            border: widget.borderColor != null
                ? Border.fromBorderSide(
                    BorderSide(color: widget.borderColor!, width: 1))
                : null,
            boxShadow: widget.boxShadow),
        child: ElevatedButton(
            style: widget.color != null
                ? ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: widget.borderRadius ?? BorderRadius.circular(15.0), // Set the desired border radius
                    ),
                    shadowColor: widget.shadowColor,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0))
                : ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(secondaryColor),
                    // Set the background color as transparent
                    elevation: WidgetStateProperty.all<double>(0),
                    // Set the elevation to 0 to remove the default box-shadow
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: widget.borderRadius ?? BorderRadius.circular(15.0), // Set the desired border radius
                      ),
                    ),
                  ),
            onPressed: widget.isLoading ? () {} : widget.onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isLoading == false
                    ? Center(
                        child: Text(
                          widget.text,
                          style: TextStyle(
                            color: widget.textForeground == null
                                ? widget.textColor ?? whiteColor
                                : null,
                            fontWeight:
                                widget.textFontWeight ?? FontWeight.w400,
                            fontSize: widget.textFontSize ?? fontSize16,
                            fontFamily: sfArabicRegular,
                            fontStyle: widget.textFontStyle,
                            foreground: widget.textForeground,
                          ),
                        ).tr(),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CircularProgressIndicator(
                          color: whiteColor,
                        ),
                    ),
                widget.suffix != null ? widget.suffix! : Container()
              ],
            )),
      ),
    );
  }
}
