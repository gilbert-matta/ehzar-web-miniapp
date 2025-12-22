import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamWidget extends StatelessWidget {
  final String teamName;
  final String image;

  // final TextStyle? textStyle;
  final double? imgWidth;
  final double? imgHeight;
  final bool isRightTeam;
  final PredictionStatus? predictionStatus;

  const TeamWidget(
      {required this.teamName,
      required this.image,
      // this.textStyle,
      this.imgWidth,
      this.imgHeight,
      required this.isRightTeam,
      this.predictionStatus,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRightTeam
            ? SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            teamName,
                            style: TextStyle(
                              fontSize: fontSize13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          predictionStatus != null
                              ? SvgPicture.asset("$staticImgUrl/star.svg",
                                  color: predictionStatus == PredictionStatus.win
                                      ? winColor
                                      : predictionStatus == PredictionStatus.lose
                                          ? null
                                          : drawColor)
                              : Container()
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    CachedImageNetwork(
                        image: image,
                        width: imgWidth ?? 35,
                        height: imgHeight ?? 30),
                  ],
                ),
              )
            : SizedBox(
                child: Row(
                  children: [
                    CachedImageNetwork(
                        image: image,
                        width: imgWidth ?? 35,
                        height: imgHeight ?? 30),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            teamName,
                            style: TextStyle(
                              fontSize: fontSize13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 5),
                        predictionStatus != null
                            ? SvgPicture.asset("$staticImgUrl/star.svg",
                                color: predictionStatus == PredictionStatus.win
                                    ? winColor
                                    : predictionStatus == PredictionStatus.lose
                                        ? null
                                        : drawColor)
                            : Container()
                      ],
                    ),
                  ],
                ),
              )
      ],
    );
  }
}
