import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/level_model.dart';
import 'package:ahzir/models/model/user_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'dart:ui' as ui;

class UserLevel extends StatelessWidget {
  final LevelModel level;
  final UserModel? user;
  final Function()? onTap;

  const UserLevel({
    required this.level,
    required this.user,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            Container(
              width: 80,
              child: user != null ? Directionality(
                textDirection: isArabic(user?.firstName) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                child: Text("${user?.firstName}", style: TextStyle(
                  color: whiteColor,
                  fontSize: fontSize16
                ), overflow: TextOverflow.ellipsis, textAlign: isArabic(user?.firstName) ? TextAlign.end : TextAlign.start),
              ) : Container(),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                  child: CachedImageNetwork(
                image: level.logo,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
