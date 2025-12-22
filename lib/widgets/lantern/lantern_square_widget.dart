

import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/lantern_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class LanternSquareWidget extends StatelessWidget {
  final List<StorePackageModel> lanterns;

  LanternSquareWidget({
    this.lanterns = const [],
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: lanterns.isNotEmpty
          ? ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: lanterns.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final lantern = lanterns[index];
          return Container(
            width: 120,
            decoration: BoxDecoration(
              color: whiteOpacity5,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedImageNetwork(
                      image: lantern.logo,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  lantern.name,
                  style: TextStyle(
                    fontSize: fontSize10,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ) : null,
    );
  }
}
