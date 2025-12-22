


import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:easy_localization/easy_localization.dart';

class StatusWidget extends StatelessWidget {
  final String status;
  const StatusWidget({
    required this.status,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: status == Statuses.accepted.name ? Colors.green.withValues(alpha: 0.5) : status == Statuses.rejected.name ? Colors.red.withValues(alpha: 0.5) : whiteOpacity5
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: status == Statuses.accepted.name ? Colors.green : status == Statuses.rejected.name ? redColor : greyColor),
          const SizedBox(width: 5),
          Text("${status == Statuses.accepted.name ? 'active' : status}", style: TextStyle(
              fontSize: fontSize12
          ),).tr()
        ],
      ),
    );
  }
}
