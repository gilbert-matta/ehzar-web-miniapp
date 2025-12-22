


import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class HorizontalInfoCard extends StatelessWidget {
  final void Function()? onTap;
  final Color? containerColor;
  final EdgeInsetsGeometry? padding;
  final String? text;
  final String image;

  const HorizontalInfoCard({
    required this.text,
    required this.onTap,
    required this.image,
    this.containerColor,
    this.padding,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 75,
        color: containerColor ?? null,
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 5),
            CachedImageNetwork(image: image, width: 80, height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                  width: screenWidth < 600.0 ? MediaQuery.of(context).size.width * 0.56 : MediaQuery.of(context).size.width * 0.8,
                  child: Text("$text", style: TextStyle(
                    color: greyColor,
                    fontSize: fontSize14,
                  ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
