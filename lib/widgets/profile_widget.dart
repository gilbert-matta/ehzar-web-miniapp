

import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class ProfileWidget extends StatelessWidget {
  final String? profileImage;
  final double? radius;

  const ProfileWidget({
    required this.profileImage,
    this.radius,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 9,
      backgroundColor: Colors.white.withOpacity(0.23),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(180),
          child: CachedImageNetwork(
            image: "$profileImage",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
