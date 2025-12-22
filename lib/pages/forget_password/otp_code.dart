

import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/pages/forget_password/new_password.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:ahzir/index.dart';

class OtpCode extends StatefulWidget {
  final String? phone;

  const OtpCode({
    required this.phone,
    super.key
  });

  @override
  State<OtpCode> createState() => _OtpCodeState();
}

class _OtpCodeState extends State<OtpCode> {
  String codeValue = "";
  AuthViewModel? authProvider;

  @override
  void initState() {
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       appBar: AppBarWidget(
         titleWidget: SvgPicture.asset("$staticImgUrl/logo/ihzar.svg"),
         centerTitle: true,
       ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                PinFieldAutoFill(
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(
                      color: whiteColor,
                    ),
                      colorBuilder: FixedColorBuilder(
                          whiteColor)
                  ),
                  cursor: Cursor(
                      width: 2,
                      color: secondaryColor,
                      enabled: true
                  ),
                  currentCode: codeValue,
                  codeLength: 6,
                  onCodeChanged: (code) async{
                    setState(() {
                      codeValue = code.toString();
                    });
                    if(codeValue.length == 6){
                      checkCode();
                    }
                  },
                  onCodeSubmitted: (val) {},
                ),
                const SizedBox(height: 50),

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
                      onTap: () => reSendCode(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  reSendCode() async{
    await authProvider?.requestOtp(context, widget.phone);
  }

  checkCode() async{
    Response response = await authProvider?.verifyCode(context, widget.phone, codeValue);
    if(response.statusCode != null && (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      nextScreen(context, NewPassword(phone: widget.phone, code: codeValue));
    }
  }
}
