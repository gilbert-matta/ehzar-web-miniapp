
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorPage extends StatelessWidget {
  Widget? page;
  String? errorText;
  bool showAppBar;
  void Function()? onPressed;

  ErrorPage({
    super.key,
    this.page,
    this.errorText,
    this.showAppBar = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: showAppBar ? AppBar(
            elevation: 0,
            leading: Container(),
            backgroundColor: Colors.transparent,
          ) : null,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Image.asset("$staticImgUrl/error_load.png"),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(errorText ?? 'Something went wrong', style: TextStyle(
                              fontSize: fontSize20,
                              color: whiteColor,
                          ),).tr(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        onPressed: onPressed ?? () => nextScreenReplace(context, page!),
                        text: "Refresh",
                        textColor: primaryColor,
                        textFontStyle: FontStyle.normal,
                        textFontSize: fontSize16,
                        textFontWeight: FontWeight.w400,
                        width: 180,
                        borderRadius: BorderRadius.circular(6),
                        color: secondaryColor,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(1, 1),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class ErrorPageLayout extends StatelessWidget {
  final String? errorText;
  final VoidCallback onPressed;

  const ErrorPageLayout({
    Key? key,
    this.errorText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Image.asset("$staticImgUrl/error_load.png"),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(errorText ?? 'Something went wrong', style: TextStyle(
                      fontSize: fontSize20,
                      color: whiteColor,
                    ),).tr(),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onPressed: onPressed,
                  text: "Refresh",
                  textColor: primaryColor,
                  textFontStyle: FontStyle.normal,
                  textFontSize: fontSize16,
                  textFontWeight: FontWeight.w400,
                  width: 180,
                  borderRadius: BorderRadius.circular(6),
                  color: secondaryColor,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(1, 1),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}