

import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:ui' as ui;
import 'package:intl_phone_field/phone_number.dart';

class PhoneFieldWidget extends StatelessWidget {
  Function(PhoneNumber)? onChanged;
  Function(Country)? onCountryChanged;

  PhoneFieldWidget({
    required this.onChanged,
    required this.onCountryChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          titleMedium: TextStyle(color: blackColor), // Adjust the text color
        ),
      ),
      child: IntlPhoneField(
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.start,
        invalidNumberMessage: 'Invalid Mobile Number'.tr(),
        dropdownIcon:
        Icon(Icons.arrow_drop_down, color: secondaryColor),

        dropdownTextStyle: TextStyle(
          color: whiteColor,
        ),
        // dropdownDecoration: BoxDecoration(
        //   color: Colors.grey
        // ),
        style: TextStyle(color: whiteColor),
        decoration: InputDecoration(
          labelText: 'Phone Number'.tr(),
          labelStyle: TextStyle(color: whiteColor),
          counterStyle: TextStyle(color: whiteColor),
          hintTextDirection: ui.TextDirection.ltr,
          // helperStyle: TextStyle(color: whiteColor),
          // fillColor: blackColor,
          // hintStyle: TextStyle(color: redColor),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: whiteColor),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: whiteColor)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: whiteColor),
          ),
        ),
        initialCountryCode: "IQ",
        onChanged: onChanged,
        onCountryChanged: onCountryChanged,
      ),
    );
  }
}
