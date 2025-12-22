import 'dart:convert';

import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/pages/auth/otp_verification.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/phone_field_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/text_inputs/TextWithInput.dart';
import 'package:ahzir/widgets/text_inputs/text_input_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:ahzir/index.dart';

class Registration extends StatefulWidget {
  const Registration({
    super.key,
  });

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegExp upperRegExp = RegExp(r'[A-Z]');
  RegExp lowerRegExp = RegExp(r'[a-z]');
  RegExp numberRegExp = RegExp(r'[0-9]');
  bool isEmpty = false;
  String? initialCountryCode;
  String? fullNumber;
  AuthViewModel? authProvider;
  bool obscurePass = true;
  bool obscureRePass = true;

  AutovalidateMode? messageValidationModeFName =
      AutovalidateMode.onUserInteraction;
  AutovalidateMode? messageValidationModeLName =
      AutovalidateMode.onUserInteraction;
  final fNameCtrl = TextEditingController();
  final lNameCtrl = TextEditingController();
  AutovalidateMode? messageValidationModePass =
      AutovalidateMode.onUserInteraction;
  AutovalidateMode? messageValidationModeReEnterPass =
      AutovalidateMode.onUserInteraction;
  final passwordCtrl = TextEditingController();
  final rePassCtrl = TextEditingController();
  String? phoneNb;
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text("Create account",
                style: TextStyle(fontSize: fontSize22, color: whiteColor))
            .tr(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    PhoneFieldWidget(onChanged: (phone) {
                      setState(() {
                        // debugPrint(phone.completeNumber);
                        isEmpty = false;
                        initialCountryCode = phone.countryCode;
                        phoneNb = phone.number;
                        fullNumber = initialCountryCode! + phoneNb!;
                      });
                    }, onCountryChanged: (country) {
                      // debugPrint('Country changed to: ${country.name}');
                      setState(() {
                        initialCountryCode = country.dialCode;
                        fullNumber = "+$initialCountryCode$phoneNb";
                      });
                    }),
                    isEmpty == true
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Invalid Mobile Number",
                              style: TextStyle(
                                  color: Colors.red.shade800, fontSize: 12),
                            ).tr(),
                          )
                        : Container(),
                    const SizedBox(
                      height: 16,
                    ),
                    TextWithInput(
                      text: 'First Name',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      widget: TextInputWidget(
                          autoValidateMode: messageValidationModeFName,
                          controller: fNameCtrl,
                          hintText: "Enter first name".tr(),
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field is empty'.tr();
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextWithInput(
                      text: 'Last Name',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      widget: TextInputWidget(
                          autoValidateMode: messageValidationModeLName,
                          controller: lNameCtrl,
                          hintText: "Enter last name".tr(),
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field is empty'.tr();
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextWithInput(
                      text: 'Password',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      widget: TextInputWidget(
                          autoValidateMode: messageValidationModePass,
                          controller: passwordCtrl,
                          hintText: "Enter password".tr(),
                          prefixSvgImage: '$staticImgUrl/icons/lock.svg',
                          prefixIconConstraints: const BoxConstraints(
                            minHeight: 20,
                            minWidth: 35,
                          ),
                          obscure: obscurePass,
                          maxLines: 1,
                          suffixIcon: InkWell(
                            child: obscurePass == true
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onTap: () {
                              setState(() {
                                obscurePass = !obscurePass;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field is empty'.tr();
                            } else if (value.length < 5) {
                              return 'should be minimum 6 characters'.tr();
                            } else if (!value.contains(upperRegExp)) {
                              return 'should contain at least 1 uppercase character'
                                  .tr();
                            } else if (!value.contains(lowerRegExp)) {
                              return 'should contain at least 1 lowercase character'
                                  .tr();
                            } else if (!value.contains(numberRegExp)) {
                              return 'should contain at least 1 number'.tr();
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextWithInput(
                      text: 'Retype password',
                      crossAxisAlignment: CrossAxisAlignment.start,
                      widget: TextInputWidget(
                          autoValidateMode: messageValidationModeReEnterPass,
                          controller: rePassCtrl,
                          hintText: "Enter password".tr(),
                          prefixSvgImage: '$staticImgUrl/icons/lock.svg',
                          prefixIconConstraints: const BoxConstraints(
                            minHeight: 20,
                            minWidth: 35,
                          ),
                          obscure: obscureRePass,
                          maxLines: 1,
                          suffixIcon: InkWell(
                            child: obscureRePass == true
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onTap: () {
                              setState(() {
                                obscureRePass = !obscureRePass;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'field is empty'.tr();
                            } else if (value != passwordCtrl.text) {
                              return 'password does not match'.tr();
                            }
                            return null;
                          }),
                    ),
                    const Divider(height: 30),
                    AppButton(
                      onPressed: () => register(),
                      text: "Confirm",
                      textFontStyle: FontStyle.normal,
                      textFontSize: fontSize16,
                      textColor: whiteColor,
                      color: secondaryColor,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      if (phoneNb.toString().isEmpty || phoneNb == null) {
        setState(() {
          isEmpty = true;
        });
      } else {
        setState(() {
          isEmpty = false;
        });
        var data = {
          "firstName": fNameCtrl.text,
          "lastName": lNameCtrl.text,
          "phone": fullNumber,
          "password": passwordCtrl.text,
          "confirmPassword": rePassCtrl.text,
          // 'fcmToken': await storage.read(key: 'fcmtoken')
        };
        Response response = await authProvider?.registration(context, data);
        if (response.statusCode != null &&
            (response.statusCode! >= 200 && response.statusCode! <= 399)) {
          // appSnackBar(context: context,
          //     msg: "we'll send you an email to confirm your account, after this your account will be created"
          //         .tr(),
          //     isError: true);
          nextScreen(context, OtpVerification(phone: fullNumber));
        }
      }
    } else if (phoneNb.toString().isEmpty || phoneNb == null) {
      setState(() {
        isEmpty = true;
      });
    }
  }
}
