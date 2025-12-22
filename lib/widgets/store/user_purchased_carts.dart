

import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/purchase_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:easy_localization/easy_localization.dart';

class UserPurchasedCarts extends StatelessWidget {
  final PurchaseModel cardInfo;
  final int? championshipId;
  final void Function()? onTap;

  const UserPurchasedCarts({
    required this.cardInfo,
    required this.onTap,
    this.championshipId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: whiteOpacity20),
            borderRadius: BorderRadius.circular(12),
            color: whiteOpacity5
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 75, // Adjust width to fit within ListTile
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
              ),
              child: CachedImageNetwork(image: cardInfo.storePackage.logo, imageBorderRadius: 15, height: 60),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.66,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(width: 5),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Text("${cardInfo.storePackage.name}", style: TextStyle(
                              fontSize: fontSize12
                          ), maxLines: 2, overflow: TextOverflow.ellipsis)
                      ),
                      const SizedBox(width: 10),
                      // Text("${'Error Reduction'.tr()}: ", style: TextStyle(fontSize: fontSize11)),
                      // const SizedBox(width: 3),
                      // Text("${cardInfo.storePackage.percentageMarginError}%", style: TextStyle(fontSize: fontSize13, fontWeight: FontWeight.bold, height: 2)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text("${'count'.tr()}: ${cardInfo.userChosenQuantity}", style: TextStyle(
                            fontSize: fontSize12
                        ),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
