


import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class TeamInfoVertical extends StatelessWidget {
  final String teamImage;
  final String teamName;

  const TeamInfoVertical({
    required this.teamName,
    required this.teamImage,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedImageNetwork(
            image: teamImage,
            width: 60,
            height: 60),
        const SizedBox(height: 5),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.32,
          child: Text(teamName, textAlign: TextAlign.center)
        ),
      ],
    );
  }
}
