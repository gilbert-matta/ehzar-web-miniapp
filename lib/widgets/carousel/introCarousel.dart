

import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:html/parser.dart';

introCarousel({required BuildContext context, required Widget ImageWidget, required String text, required String description, required DataLoadState loadState}){
  final screenWidth = MediaQuery.of(context).size.width;
  var document = parse(description);
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        width: 480,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 300
              ),
              child: loadState == DataLoadState.loaded ? ImageWidget : imageIntroSkeleton(context: context),
            ),
            const SizedBox(height: 40),
            loadState == DataLoadState.loaded ? SizedBox(
              // margin: const EdgeInsets.only(bottom: 60),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,   //for dark mode also
                        color: whiteColor,
                        fontSize: fontSize24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                    const SizedBox(height: 20),
                    Text(
                      "${document.body?.text}",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: Theme.of(context).brightness == Brightness.dark ? whiteColor : blackColor,   //for dark mode also
                        color: whiteColor,
                        fontSize: fontSize16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ) : carouselIntroSkeleton()
          ],
        ),
      ),
    ],
  );
}