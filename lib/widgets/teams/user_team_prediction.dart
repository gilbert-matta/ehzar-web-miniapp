import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/profile_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserTeamPrediction extends StatelessWidget {
  final String teamName;
  final String image;
  final String? profileImg;

  // final TextStyle? textStyle;
  final double? imgWidth;
  final double? imgHeight;
  final bool isRightTeam;
  final PredictionStatus? predictionStatus;
  final String? userImage;

  const UserTeamPrediction(
      {required this.teamName,
      required this.image,
        required this.profileImg,
      // this.textStyle,
      this.imgWidth,
      this.imgHeight,
      required this.isRightTeam,
      required this.predictionStatus,
      this.userImage,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRightTeam
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        Text(
                          teamName,
                          style: TextStyle(
                            fontSize: fontSize12,
                          ),
                        ),
                        const SizedBox(width: 10),
                        CachedImageNetwork(
                            image: image,
                            width: imgWidth ?? 35,
                            height: imgHeight ?? 30),
                      ],
                    ),
                  ),
                  predictionStatus != null
                      ? Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                            children: [
                              SvgPicture.asset("$staticImgUrl/star.svg",
                                  color: predictionStatus == PredictionStatus.win
                                      ? winColor
                                      : predictionStatus == PredictionStatus.lose
                                          ? null
                                          : drawColor),
                              const SizedBox(width: 5),
                              predictionStatus == PredictionStatus.win || predictionStatus == PredictionStatus.draw ? ProfileWidget(profileImage: profileImg) : Container()
                            ],
                          ),
                      )
                      : Container()
                ],
              )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        CachedImageNetwork(
                            image: image,
                            width: imgWidth ?? 35,
                            height: imgHeight ?? 30),
                        const SizedBox(width: 10),
                        Text(
                          teamName,
                          style: TextStyle(
                            fontSize: fontSize12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  predictionStatus != null
                      ? Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                            children: [
                              SvgPicture.asset("$staticImgUrl/star.svg",
                                  color: predictionStatus == PredictionStatus.win
                                      ? winColor
                                      : predictionStatus == PredictionStatus.lose
                                          ? null
                                          : drawColor),
                              const SizedBox(width: 5),
                              predictionStatus == PredictionStatus.win || predictionStatus == PredictionStatus.draw ? ProfileWidget(profileImage: profileImg) : Container()
                            ],
                          ),
                      )
                      : Container()
                ],
              )
      ],
    );
  }
}
