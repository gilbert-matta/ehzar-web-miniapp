import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/tournament_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/profile_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class CardWidget extends StatelessWidget {
  final TournamentModel tournament;
  final int index;
  final int currentIndex;
  final String? userProfileImg;
  final void Function()? onTap;

  CardWidget(
      {required this.tournament,
      required this.index,
      required this.currentIndex,
      required this.onTap,
      this.userProfileImg,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: index == currentIndex ? 150 : 140,
        height: index == currentIndex ? 120 : 100,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: index == currentIndex ? null : whiteOpacity5,
          borderRadius: BorderRadius.circular(15),
          image: index == currentIndex
              ? const DecorationImage(
                  image: AssetImage('$staticImgUrl/background-mix-colors.png'),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedImageNetwork(
                    image: tournament.icon,
                    width: index == currentIndex ? 80 : 65,
                    height: index == currentIndex ? 80 : 65),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Starts",
                        style: TextStyle(
                          fontSize: fontSize7,
                          fontFamily: sfArabicRegular,
                          color: index == currentIndex ? whiteColor : hsl8A,
                        ),
                      ).tr(),
                      Text("Ends",
                          style: TextStyle(
                            fontSize: fontSize7,
                            fontFamily: sfArabicRegular,
                            color: index == currentIndex ? whiteColor : hsl8A,
                          )).tr(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${tournament.seasons[0].startingYear.toString()}",
                          style: TextStyle(
                            fontSize: fontSize9,
                            fontFamily: sfArabicRegular,
                            color: index == currentIndex ? whiteColor : hsl8A,
                          ),
                          textDirection: ui.TextDirection.ltr),
                      Text("${tournament.seasons[0].endingYear.toString()}",
                          style: TextStyle(
                            fontSize: fontSize9,
                            fontFamily: sfArabicRegular,
                            color: index == currentIndex ? whiteColor : hsl8A,
                          ),
                          textDirection: ui.TextDirection.ltr),
                    ],
                  ),
                ),
              ],
            ),
            userProfileImg != null
                ? Positioned(
                    top: 5,
                    right: 10,
                    child: ProfileWidget(profileImage: userProfileImg))
                : Container()
          ],
        ),
      ),
    );
  }
}
