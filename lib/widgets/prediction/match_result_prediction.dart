import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/globals.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:easy_localization/easy_localization.dart';

class MatchResultPrediction extends StatelessWidget {
  var predictionStatus;
  final String? winnerTeamImage;

  MatchResultPrediction(
      {required this.predictionStatus,
      required this.winnerTeamImage,
      super.key});

  @override
  Widget build(BuildContext context) {
    return (predictionStatus is String &&
            predictionStatus.toLowerCase() == PredictionStatus.draw.name)
        ? Text(capitalizeFirstWord(predictionStatus.toLowerCase()),
                style: TextStyle(fontSize: fontSize11))
            .tr() //if its a draw
        : Row(
            //if its for team winner
            children: [
              Text("winner", style: TextStyle(fontSize: fontSize11)).tr(),
              const SizedBox(width: 5),
              CachedImageNetwork(image: winnerTeamImage, width: 20, height: 20)
            ],
          );
  }
}
