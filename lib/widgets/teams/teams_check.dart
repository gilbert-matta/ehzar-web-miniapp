




import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class TeamsCheck extends StatelessWidget {
  final String? image;
  final bool isChecked;
  final void Function()? onTap;

  TeamsCheck({
    required this.image,
    this.onTap,
    this.isChecked = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isChecked ? secondaryColor : whiteColor)
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                child: CachedImageNetwork(
                  image: image,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: isChecked ? CircleAvatar(
                radius: 10,
                child: Icon(Icons.check, size: 20, color: whiteColor),
              ) : Container()
          )
        ],
      ),
    );
  }
}
