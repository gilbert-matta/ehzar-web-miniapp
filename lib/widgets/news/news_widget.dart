import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class NewsWidget extends StatelessWidget {
  Function()? onTap;
  // Function()? onFavoriteTap;
  // bool isFavorite;
  String? image;
  String title;
  String date;


  NewsWidget({
    required this.title,
    required this.image,
    required this.date,
    required this.onTap,
    // this.onFavoriteTap,
    // this.isFavorite = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: CachedImageNetwork(
                image: image,
                width: 100,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$title",
                      style: TextStyle(
                        fontSize: fontSize12,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Text("${convertDate(date!)}", style: TextStyle(
                        fontSize: fontSize10,
                        fontWeight: FontWeight.w500,
                        color: hsl8A
                      ),),
                    ),
                  ],
                ),
              ),
            ),
            // GestureDetector(
            //     onTap: onFavoriteTap,
            //     child: CircleAvatar(
            //       radius: 17,
            //       backgroundColor: Colors.transparent,
            //       child: SvgPicture.asset("$staticImgUrl/bookmark.svg",
            //         color: isFavorite ? yellowColor : null, width: 22, height: 22,),
            //     ))
          ],
        ),
      ),
    );
  }
}
