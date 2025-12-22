

import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/text_inputs/TextWithInput.dart';
import 'package:ahzir/widgets/text_inputs/text_input_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ahzir/index.dart';

class NewPassword extends StatefulWidget {
  final String? phone;
  final String code;

  const NewPassword({
    required this.phone,
    required this.code,
    super.key
  });

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode? messageValidationModePass = AutovalidateMode.onUserInteraction;
  AutovalidateMode? messageValidationModeReEnterPass = AutovalidateMode.onUserInteraction;
  final passwordCtrl = TextEditingController();
  final rePassCtrl = TextEditingController();
  bool obscurePass = true;
  bool obscureRePass = true;
  RegExp upperRegExp = RegExp(r'[A-Z]');
  RegExp lowerRegExp = RegExp(r'[a-z]');
  RegExp numberRegExp = RegExp(r'[0-9]');
  AuthViewModel? authProvider;

  @override
  void initState() {
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleWidget: SvgPicture.asset("$staticImgUrl/logo/ihzar.svg"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Text("Enter a New Password", style: TextStyle(
                    fontSize: fontSize24,
                    fontStyle: FontStyle.normal,
                    color: secondaryColor,
                  )).tr(),
                  const SizedBox(height: 42),
                  TextWithInput(
                    text: 'Password',
                    crossAxisAlignment: CrossAxisAlignment.start,
                    widget: TextInputWidget(
                        autoValidateMode: messageValidationModePass,
                        controller: passwordCtrl,
                        hintText: "Enter password",
                        prefixSvgImage: '$staticImgUrl/icons/lock.svg',
                        prefixIconConstraints: const BoxConstraints(
                          minHeight: 20,
                          minWidth: 35,
                        ),
                        obscure: obscurePass,
                        maxLines: 1,
                        suffixIcon: InkWell(
                          child: obscurePass == true ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                          onTap: (){
                            setState(() {
                              obscurePass = !obscurePass;
                            });
                          },
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'field is empty';
                          }else if(value.length < 5){
                            return 'should be minimum 6 characters';
                          }else if(!value.contains(upperRegExp)){
                            return 'should contain at least 1 uppercase character';
                          }else if(!value.contains(lowerRegExp)){
                            return 'should contain at least 1 lowercase character';
                          }else if(!value.contains(numberRegExp)){
                            return 'should contain at least 1 number';
                          }
                          return null;
                        }
                    ),
                  ),

                  const SizedBox(height: 16,),
                  TextWithInput(
                    text: 'Retype password',
                    crossAxisAlignment: CrossAxisAlignment.start,
                    widget: TextInputWidget(
                        autoValidateMode: messageValidationModeReEnterPass,
                        controller: rePassCtrl,
                        hintText: "Enter password",
                        prefixSvgImage: '$staticImgUrl/icons/lock.svg',
                        prefixIconConstraints: const BoxConstraints(
                          minHeight: 20,
                          minWidth: 35,
                        ),
                        obscure: obscureRePass,
                        maxLines: 1,
                        suffixIcon: InkWell(
                          child: obscureRePass == true ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                          onTap: (){
                            setState(() {
                              obscureRePass = !obscureRePass;
                            });
                          },
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'field is empty';
                          }else if(value != passwordCtrl.text){
                            return 'password does not match';
                          }
                          return null;
                        }
                    ),
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    onPressed: () => changePassword(),
                    text: "Verify",
                    textFontStyle: FontStyle.normal,
                    textFontSize: fontSize16,
                    color: secondaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  changePassword() async{
    var data = {
      "phone": widget.phone,
      "otp": widget.code,
      "newPassword": passwordCtrl.text,
      "confirmPassword": rePassCtrl.text
    };
    if(formKey.currentState!.validate()){
      Response response = await authProvider?.resetPassword(context, data);
      if(response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)){
        appSnackBar(context: context, msg: 'password changed successfully');
        Navigator.of(context)
          ..pop()..pop()..pop();
      }else{
        appSnackBar(context: context, msg: response.data['message'], isError: true);
      }
    }
  }
}
