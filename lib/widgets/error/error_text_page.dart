


import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorTextPage extends StatelessWidget {
  final String? errorText;
  final Widget? widget;
  final double? staticImgWidth;
  final String? localImgUrl;

  const ErrorTextPage({
    required this.errorText,
    this.widget,
    this.staticImgWidth,
    this.localImgUrl,
    super.key
  });

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
                widget ?? Image.asset("$staticImgUrl/${localImgUrl ?? 'error_load.png'}", width: staticImgWidth),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(errorText ?? 'Something went wrong', style: TextStyle(
                      fontSize: fontSize20,
                      color: whiteColor,
                    ), textAlign: TextAlign.center).tr(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
