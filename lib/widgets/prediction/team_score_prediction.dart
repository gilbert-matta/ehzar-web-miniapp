


import 'package:ahzir/index.dart';

class TeamScorePrediction extends StatelessWidget {
  final String image;
  final int teamScore;
  final void Function()? onPlusPressed;
  final void Function()? onMinusPressed;

  const TeamScorePrediction({
    required this.image,
    required this.teamScore,
    required this.onPlusPressed,
    required this.onMinusPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          IconButton(onPressed: onPlusPressed, icon: Icon(Icons.add, color: whiteColor)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              // padding: const EdgeInsets.symmetric(vertical: 20),
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: whiteOpacity5
              ),
              child: Center(child: Text("$teamScore")),
            ),
          ),
          IconButton(onPressed: onMinusPressed, icon: Icon(Icons.remove, color: whiteColor)),
        ],
      ),
    );
  }
}
