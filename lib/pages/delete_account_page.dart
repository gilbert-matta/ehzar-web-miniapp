import 'package:ahzir/functions/user.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/alert_dialogs/alert_dialog.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/loader/loader.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 92),
              const SizedBox(height: 24),
              Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: redColor,
                ),
                textAlign: TextAlign.center,
              ).tr(),
              const SizedBox(height: 16),
              Text(
                "This action will permanently delete your account and all associated data.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ).tr(),
              const SizedBox(height: 32),
              AppButton(
                onPressed: () {
                  AlertDialogWidget(
                    context: context,
                    title: 'Delete Account',
                    content: "Are you sure you want to delete your account?",
                    onPressed: () => deleteAccount(),
                    yesBackgroundColor: redColor,
                  );
                },
                text: "Delete Account",
                color: redColor,
                textFontSize: fontSize18,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white60, fontSize: 16),
                ).tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteAccount() async {
    Response response = await Provider.of<AuthViewModel>(context, listen: false)
        .deleteAccount(context: context);
    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      logout();
      appSnackBar(context: context, msg: "User Deleted Successfully");
    } else {
      Navigator.pop(context);
      appSnackBar(
          context: context, msg: response.data['message'], isError: true);
    }

    LoaderWidget().remove();
  }

  logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    // storage.delete(key: 'fcmtoken');  //if user logged out, will not receive notification to his account.
    prefs.remove('userInfo');
    prefs.remove('userLevel'); //remove user level from storage.
    Navigator.pop(context);
    Navigator.pop(context, true);
  }
}
