import 'dart:convert';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/pages/auth/registration.dart';
import 'package:ahzir/pages/bottom_nav_pages.dart';
import 'package:ahzir/pages/forget_password/phone_forget_password.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/error/errorDialog.dart';
import 'package:ahzir/widgets/phone_field_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/text_inputs/text_input_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ahzir/index.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final bool isLoginSettings;

  const Login({
    this.isLoginSettings = false,
    super.key
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordCtrl = TextEditingController();
  RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
  AuthViewModel? authProvider;

  // UserProvider? userProvider;
  bool obscurePass = true;
  // final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  bool isEmpty = false;
  String? initialCountryCode;
  String? fullNumber;
  String? phoneNb;

  AutovalidateMode? messageValidationModeEmail =
      AutovalidateMode.onUserInteraction;
  AutovalidateMode? messageValidationModePassword =
      AutovalidateMode.onUserInteraction;

  @override
  void initState() {
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    // userProvider = Provider.of<UserProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset("$staticImgUrl/logo/ihzar.svg"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 42),
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
                        const Text("Password").tr(),
                        const SizedBox(height: 5),
                        TextInputWidget(
                            prefixSvgImage: '$staticImgUrl/icons/lock.svg',
                            prefixIconConstraints: const BoxConstraints(
                              minHeight: 20,
                              minWidth: 35,
                            ),
                            suffixIcon: InkWell(
                              child: obscurePass == true
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined),
                              onTap: () {
                                setState(() {
                                  obscurePass = !obscurePass;
                                });
                              },
                            ),
                            autoValidateMode: messageValidationModePassword,
                            controller: passwordCtrl,
                            hintText: "Enter password".tr(),
                            obscure: obscurePass,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'field is empty'.tr();
                              }
                              return null;
                            }),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () =>
                              nextScreen(context, const PhoneForgetPassword()),
                          child: Text(
                            "Forget password?",
                            style: TextStyle(
                                fontFamily: sfArabicRegular,
                                decoration: TextDecoration.underline,
                                color: secondaryColor),
                          ).tr(),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                      onPressed: () => login(),
                      text: "Log In",
                      textColor: whiteColor,
                      textFontStyle: FontStyle.normal,
                      color: secondaryColor,
                      // isLoading: _isLoading,
                      width: MediaQuery.of(context).size.width,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Text(
                          "Not a user yet?",
                          style: TextStyle(
                            fontSize: fontSize16,
                            fontStyle: FontStyle.normal,
                          ),
                        ).tr(),
                        const SizedBox(width: 4),
                        InkWell(
                            onTap: () =>
                                nextScreen(context, const Registration()),
                            child: Text(
                              "Click here",
                              style: TextStyle(
                                  fontSize: fontSize16,
                                  fontStyle: FontStyle.normal,
                                  decoration: TextDecoration.underline,
                                  color: secondaryColor),
                            ).tr())
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    prefs = await SharedPreferences.getInstance();
    if (formKey.currentState!.validate()) {
      if (phoneNb.toString().isEmpty || phoneNb == null) {
        setState(() {
          isEmpty = true;
        });
      } else {
        setState(() {
          isEmpty = false;
        });
        Response res =
        await authProvider?.login(context, fullNumber, passwordCtrl.text);
        if (res.statusCode == 200 || res.statusCode == 201) {
          //success
          var response = res.data;
          prefs.setString("token", response['token']);
          //save user info
          await prefs.setString(
              "userInfo", jsonEncode(res.data['user']));
          // UserModel? userInfo = UserModel.fromJson(user);
          // if (userInfo.userAssetsFavorites) {
          if (mounted) {
            if(widget.isLoginSettings){
              nextScreenCloseOthers(context, BottomNavPages());
            }else {
              Navigator.pop(context);
            }
          }
          // }else{  //if user favorites list is empty, navigate to assets to choose
          //   if(mounted){
          //     nextScreenCloseOthers(context, const IntroAssets());
          //   }
          // }
        } else {
          //if there was an error
          ErrorDialog(
              context: context, error: res.data['message'].toString().tr());
        }
      }
    }else if (phoneNb.toString().isEmpty || phoneNb == null) {
      setState(() {
        isEmpty = true;
      });
    }
  }
}
