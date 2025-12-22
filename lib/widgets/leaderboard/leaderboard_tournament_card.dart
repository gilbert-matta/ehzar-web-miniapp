

import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class LeaderboardTournamentCard extends StatelessWidget {
  final void Function()? onTap;
  final String image;
  final String name;
  final bool isSelected;

  const LeaderboardTournamentCard({
    required this.onTap,
    required this.image,
    required this.name,
    this.isSelected = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: whiteColor),
          gradient: isSelected ? blueMauveLinearGrad : null
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: CachedImageNetwork(
                  image: image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                width: 70,
                height: 38,
                child: Text("$name",
                  style: TextStyle(
                    fontSize: fontSize12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
      ),
    );
  }
}
