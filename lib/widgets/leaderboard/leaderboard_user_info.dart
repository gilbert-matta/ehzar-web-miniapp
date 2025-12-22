

import 'package:ahzir/index.dart';

class LeaderboardUserInfo extends StatelessWidget {
  final String name;
  final int winningMatches;
  final int totalMatches;

  const LeaderboardUserInfo({
    required this.name,
    required this.winningMatches,
    required this.totalMatches,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            width: 80,
            child: Center(
              child: Text(name, style: TextStyle(
                  fontSize: fontSize12,
                  fontWeight: FontWeight.w400
              ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text("$winningMatches/$totalMatches", style: TextStyle(
              fontSize: fontSize13,
              fontWeight: FontWeight.w800
          )),
        ],
      ),
    );
  }
}
