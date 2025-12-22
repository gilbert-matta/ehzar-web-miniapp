import 'dart:convert';

import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:ahzir/pages/auth/registration_type.dart';
import 'package:ahzir/pages/bottom_nav_pages.dart';
import 'package:ahzir/pages/favorites/favorite_teams.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerification extends StatefulWidget {
  final String? phone;

  const OtpVerification({
    Key? key,
    this.phone,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String codeValue = "";
  AuthViewModel? loginProvider;
  late SharedPreferences prefs;

  @override
  void initState() {
    loginProvider = Provider.of<AuthViewModel>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'enter code',
              style: TextStyle(
                fontSize: 15.0,
                color: whiteColor,
                fontWeight: FontWeight.w500,
              ),
            ).tr(),
            const SizedBox(height: 40.0),
            Center(
              child: PinFieldAutoFill(
                cursor: Cursor(width: 2, color: whiteColor, enabled: true),
                decoration: UnderlineDecoration(
                    colorBuilder: FixedColorBuilder(whiteColor),
                    textStyle: TextStyle(color: whiteColor)),
                currentCode: codeValue,
                codeLength: 6,
                onCodeChanged: (code) async {
                  prefs = await SharedPreferences.getInstance();
                  setState(() {
                    codeValue = code.toString();
                  });
                  if (codeValue.length == 6) {
                    Response response = await loginProvider?.verifyCode(
                        context, widget.phone, code);
                    if (response.statusCode != null &&
                        (response.statusCode! >= 200 &&
                            response.statusCode! <= 399)) {
                      await prefs.setString(
                          "userInfo", jsonEncode(response.data['user']));
                      nextScreenCloseOthers(
                          context,
                          FavoriteTeams(
                              navigateTo: BottomNavPages(index: 4),
                              isRegistering: true));
                      // nextScreenCloseOthers(context, RegistrationType());
                    }
                  }
                },
                onCodeSubmitted: (val) {},
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('didn\'t receive code?',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    )).tr(),
                const SizedBox(width: 10.0),
                InkWell(
                  onTap: () async {
                    await loginProvider?.requestOtp(context, widget.phone);
                  },
                  child: Text(
                    'resend',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: secondaryColor,
                      fontFamily: sfArabicRegular,
                      fontWeight: FontWeight.w500,
                    ),
                  ).tr(),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
