import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:ahzir/index.dart';

class TextInputWidget extends StatefulWidget {
  TextEditingController? controller;
  String? Function(String?)? validator;
  String? hintText;
  Color? hintTextColor;
  final TextInputAction? textInputAction;
  final TextInputType? keybType;
  final bool spaceAllowed;
  final bool obscure;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputformatters;
  double? width;
  void Function(String)? onChanged;
  String? errorText;
  bool readOnly;
  Color? backgroundColor;
  BorderSide? enabledBorderSide;
  AutovalidateMode? autoValidateMode;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Widget? suffix;
  Widget? prefix;
  String? prefixSvgImage;
  String? suffixSvgImage;
  String? counterText;
  BoxConstraints? prefixIconConstraints;
  BoxConstraints? suffixIconConstraints;
  void Function()? onTap;
  Color? textColor;

  TextInputWidget({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.hintText,
    this.hintTextColor,
    this.textInputAction,
    this.keybType,
    this.spaceAllowed = false,
    this.obscure = false,
    this.maxLength,
    this.maxLines,
    this.counterText,
    this.inputformatters,
    this.width,
    this.errorText,
    this.readOnly = false,
    this.backgroundColor,
    this.enabledBorderSide,
    this.autoValidateMode,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.prefix,
    this.prefixSvgImage,
    this.suffixSvgImage,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.onTap,
    this.textColor,
  });

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Update the state to reflect the focus change
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose the focus node when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8.0),
      //   color: widget.backgroundColor ?? whiteLight,
      // ),
      child: TextFormField(
        focusNode: _focusNode, // Attach the focus node to the TextFormField
        onTap: widget.onTap,
        controller: widget.controller,
        onChanged: widget.onChanged,
        validator: widget.validator,
        autovalidateMode: widget.autoValidateMode,
        readOnly: widget.readOnly,
        style: TextStyle(
          fontSize: fontSize16,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          color: widget.textColor ?? whiteColor,
        ),
        cursorColor: whiteColor,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon ?? (widget.prefixSvgImage != null ?  SvgPicture.asset(
              "${widget.prefixSvgImage}",
              width: 20,
              height: 20,
              colorFilter: _focusNode.hasFocus ? ColorFilter.mode(whiteColor, BlendMode.srcIn) : ColorFilter.mode(grey, BlendMode.srcIn), // Change color based on focus
          ) : null),
          prefix: widget.prefix,
          prefixIconConstraints: widget.prefixIconConstraints,
          prefixIconColor: _focusNode.hasFocus ? whiteColor : grey, // Change color based on focus
          suffixIcon: widget.suffixIcon ?? (widget.suffixSvgImage != null ?  SvgPicture.asset(
            "${widget.suffixSvgImage}",
            width: 20,
            height: 20,
            colorFilter: _focusNode.hasFocus ? ColorFilter.mode(whiteColor, BlendMode.srcIn) : ColorFilter.mode(grey, BlendMode.srcIn), // Change color based on focus
          ) : null),
          suffix: widget.suffix,
          suffixIconConstraints: widget.suffixIconConstraints,
          suffixIconColor: _focusNode.hasFocus ? whiteColor : grey,
          enabledBorder: UnderlineInputBorder(
            borderSide: widget.enabledBorderSide ?? BorderSide(
              // width: 1,
              color: whiteColor,
            ),
            // borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              // width: 3,
              color: whiteColor,
            ),
            // borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              // width: 3,
              color: redColor,
            ),
            // borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              // width: 1,
              color: redColor,
            ),
            // borderRadius: BorderRadius.circular(8.0),
          ),
          errorMaxLines: 2,
          hintText: (widget.hintText)?.tr(),
          hintStyle: TextStyle(
            fontSize: fontSize16,
            fontStyle: FontStyle.normal,
            color: widget.hintTextColor ?? grey79,
          ),
          errorStyle: TextStyle(
            height: 0.7,
            fontSize: fontSize14
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
          counterText: widget.counterText //this can be used to show/hide the count for the maxLength
        ),
        textInputAction: widget.textInputAction,
        keyboardType: widget.keybType,
        obscureText: widget.obscure,
        obscuringCharacter: '*',
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        inputFormatters: widget.inputformatters,
      ),
    );
  }
}
