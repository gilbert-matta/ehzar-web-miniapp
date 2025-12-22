
import 'package:ahzir/index.dart';

class LeagueWidget extends StatelessWidget {
  final bool isSelected;
  final String leagueName;
  final void Function()? onTap;

  const LeagueWidget({
    required this.leagueName,
    required this.onTap,
    this.isSelected = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: isSelected ? secondaryColor : Colors.transparent, width: 2),
            ),
            color: isSelected ? primaryOpacity7 : Colors.transparent
        ),
        child: Center(child: Text(leagueName, style: TextStyle(color: isSelected ? secondaryColor : whiteColor, fontSize: fontSize12), textAlign: TextAlign.center)),
      ),
    );
  }
}
