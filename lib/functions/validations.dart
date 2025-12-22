

import 'package:easy_localization/easy_localization.dart';

RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');

checkValidationIfEmpty(String? value){
  if (value == null || value.isEmpty) {
    return 'field is empty'.tr();
  }
  return null;
}

emailValidation(value){
  if (value == null || value.isEmpty) {
    return 'field is empty'.tr();
  } else if (!emailRegex.hasMatch(value)) {
    return 'This is not an email format'.tr();
  }
}