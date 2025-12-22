import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/tournament_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class TournamentWidget extends StatelessWidget {
  final TournamentModel tournament;
  final void Function()? onTap;
  final Color? containerColor;

  const TournamentWidget({required this.tournament, this.onTap, this.containerColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.2), color: containerColor ?? whiteOpacity5),
      child: ListTile(
        minTileHeight: 80,
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 30,
          child: CachedImageNetwork(
            image: tournament.icon,
          ),
        ),
        title: Text(
          tournament.name,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
