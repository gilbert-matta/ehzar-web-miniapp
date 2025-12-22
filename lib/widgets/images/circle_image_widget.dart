


import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

CircleImageWidget({
  double? widthContainer,
  double? heightContainer,
  String? image,
  Widget? icon,
  double? edgeInsetsAll,
  double? imgWidth,
  double? imgHeight,
}){
  return Container(
    width: widthContainer ?? 48,
    height: heightContainer ?? 48,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: monochromatic02, // Border color
        width: 1.0, // Border width
      ),
    ),
    child: icon != null ? icon : ClipOval(child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: CachedImageNetwork(
        image: "$image",
        width: imgWidth,
        height: imgHeight,
      ),
    )),
  );
}