import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/profile_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 185,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(13), color: blue1D),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedImageNetwork(
                      image:
                          'https://cdn-cjhkj.nitrocdn.com/krXSsXVqwzhduXLVuGLToUwHLNnSxUxO/assets/images/optimized/rev-b135bb1/spotme.com/wp-content/uploads/2020/07/Hero-1.jpg',
                      width: double.infinity,
                      height: 90,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    width: 35,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: whiteColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 15,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "10",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: fontSize14,
                              color: blackColor,
                              height: 0.5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            "JUNE",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize10,
                              color: blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SvgPicture.asset("$staticImgUrl/bookmark.svg",
                            color: blue11),
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "اليوم العالمي للرياضة العربية الوطنية",
              style:
                  TextStyle(fontSize: fontSize12, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 66,
                  child: Stack(
                    children: List.generate(3, (int i) {
                      return Positioned(
                        left: i * 18.0, // Adjust the overlap distance here
                        child: ProfileWidget(
                            profileImage:
                                "https://engineering.unl.edu/images/staff/Kayla-Person.jpg",
                            radius: 12),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "+20 اضافة",
                  style: TextStyle(
                      fontSize: fontSize7,
                      fontWeight: FontWeight.w500,
                      color: grey78),
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.location_on, size: 15, color: grey78),
                Text(
                  "36 شارع جيلد لندن، المملكة المتحدة",
                  style: TextStyle(
                      fontSize: fontSize7,
                      fontWeight: FontWeight.w500,
                      color: grey78),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
