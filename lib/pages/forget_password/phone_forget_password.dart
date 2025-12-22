
import 'package:ahzir/pages/forget_password/otp_code.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/phone_field_widget.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:ahzir/index.dart';

class PhoneForgetPassword extends StatefulWidget {
  const PhoneForgetPassword({super.key});

  @override
  State<PhoneForgetPassword> createState() => _PhoneForgetPasswordState();
}

class _PhoneForgetPasswordState extends State<PhoneForgetPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthViewModel? authProvider;
  bool isEmpty = false;
  String? initialCountryCode;
  String? fullNumber;
  String? phoneNb;

  @override
  void initState() {
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Text("Forget password?", style: TextStyle(
                    fontSize: fontSize28,
                    fontStyle: FontStyle.normal,
                    color: secondaryColor
                  )).tr(),
                  const SizedBox(height: 42),
                  Text("Please enter the phone number you use to sign in.", style: TextStyle(
                    color: whiteColor,
                    fontStyle: FontStyle.normal,
                    fontSize: fontSize16,
                  )).tr(),
                  const SizedBox(height: 42),
                  PhoneFieldWidget(
                      onChanged: (phone) {
                        setState(() {
                          // debugPrint(phone.completeNumber);
                          isEmpty = false;
                          initialCountryCode = phone.countryCode;
                          phoneNb = phone.number;
                          fullNumber = initialCountryCode! + phoneNb!;
                        });
                      },
                      onCountryChanged: (country) {
                        // debugPrint('Country changed to: ${country.name}');
                        setState(() {
                          initialCountryCode = country.dialCode;
                          fullNumber = "+$initialCountryCode$phoneNb";
                        });
                      }
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    onPressed: () => sendCode(),
                    text: "Request password reset",
                    textFontStyle: FontStyle.normal,
                    textFontSize: fontSize16,
                    color: secondaryColor,
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text("Back to Sign in", style: TextStyle(
                        color: secondaryColor,
                        fontSize: fontSize16,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.underline
                      ),
                    ).tr(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendCode() async{
    if(formKey.currentState!.validate()){
      await authProvider?.requestOtp(context, fullNumber);
      nextScreenReplace(context, OtpCode(phone: fullNumber));
    }
  }
}
