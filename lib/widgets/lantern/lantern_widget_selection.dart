

import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/lantern_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';

class LanternWidgetSelection extends StatelessWidget {
  final StorePackageModel lantern;
  final int selectedId;
  final void Function()? onTap;

  LanternWidgetSelection({
    required this.lantern,
    required this.selectedId,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color:
          selectedId == lantern.id ? Colors.yellow.withOpacity(0.3) : whiteOpacity5,
          borderRadius: BorderRadius.circular(12),
          border: selectedId == lantern.id
              ? Border.all(color: Colors.yellow, width: 2)
              : null,
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
      ),
    );
  }
}