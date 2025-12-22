

import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/status_widget.dart';

class ChatGroupWidget extends StatelessWidget {
  final void Function()? onTap;
  final String? groupLogo;
  final String? groupName;
  final String groupStatus;

  const ChatGroupWidget({
    required this.onTap,
    required this.groupName,
    required this.groupLogo,
    required this.groupStatus,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
            color: whiteOpacity5,
            borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 30, // Adjust the radius as needed
              backgroundColor: whiteOpacity5,
              child: groupLogo != null && groupLogo != '' ? ClipOval(
                child: CachedImageNetwork(
                  image: groupLogo,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ) : Icon(Icons.group, size: 40, color: whiteOpacity30),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text("${groupName}", style: TextStyle(
                  fontSize: fontSize14
              ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            StatusWidget(status: groupStatus)
          ],
        ),
      ),
    );
  }
}
