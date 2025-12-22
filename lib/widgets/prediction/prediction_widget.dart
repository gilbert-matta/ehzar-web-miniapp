

import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class PredictionWidget extends StatelessWidget {
  final String? homeTeamImage;
  final String? awayTeamImage;
  final String? homeTeamScore;
  final String? awayTeamScore;

  const PredictionWidget({
    required this.homeTeamImage,
    required this.awayTeamImage,
    required this.homeTeamScore,
    required this.awayTeamScore,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedImageNetwork(
            image: homeTeamImage,
            width: 25,
            height: 25),
        const SizedBox(width: 5),
        Text("$awayTeamScore - $homeTeamScore",
            style: TextStyle(
                fontSize: fontSize10,
                fontWeight: FontWeight.w400)),
        const SizedBox(width: 5),
        CachedImageNetwork(
            image: awayTeamImage,
            width: 25,
            height: 25),
      ],
    );
  }
}
