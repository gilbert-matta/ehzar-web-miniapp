
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

groupNameLogo({
  required BuildContext context,
  required String? groupName,
  required String? groupLogo,
  required void Function()? onTap,
}){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: whiteColor)),
            padding: groupLogo != null && groupLogo != '' ? EdgeInsets.zero : EdgeInsets.all(4),
            child: groupLogo != null && groupLogo != '' ? ClipOval(
              child: CachedImageNetwork(
                image: groupLogo,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ) : Icon(Icons.group, size: 40, color: whiteOpacity30),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "$groupName",
                  style: TextStyle(color: whiteColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}