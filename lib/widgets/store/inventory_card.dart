import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class InventoryCard extends StatelessWidget {
  final StoreModel cardInfo;
  final void Function()? onTap;
  final void Function()? onAddTap;
  final void Function()? onRemoveTap;

  const InventoryCard(
      {required this.cardInfo,
      this.onTap,
      this.onAddTap,
      this.onRemoveTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: whiteOpacity20),
          borderRadius: BorderRadius.circular(12),
          color: whiteOpacity5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    CachedImageNetwork(image: cardInfo.logo, fit: BoxFit.cover),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            title: Text(
              cardInfo.name,
              style: TextStyle(
                fontSize: fontSize14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Price'.tr(),
                  style: TextStyle(
                    fontSize: fontSize11,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${numberWithComma(cardInfo.price)} ${cardInfo.currency}",
                  style: TextStyle(
                    fontSize: fontSize13,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: ui.TextDirection.ltr,
                ),
              ],
            ),
          ),

          // Description Section - Fixed height
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: SizedBox(
              height: 32,
              child: cardInfo.description != null &&
                      cardInfo.description!.isNotEmpty
                  ? Text(
                      cardInfo.description!,
                      style: TextStyle(
                        fontSize: fontSize11,
                        color: Colors.grey[300],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // Prizes Section - Fixed height
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: SizedBox(
              height: 110,
              child: cardInfo.prizes != null && cardInfo.prizes!.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Prizes".tr(),
                          style: TextStyle(
                            fontSize: fontSize14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: cardInfo.prizes!
                                  .map((prize) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: PrizeWidget(
                                          prizeName: prize.name,
                                          prizeIcon: prize.icon,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class PrizeWidget extends StatelessWidget {
  final String prizeName;
  final String prizeIcon;

  const PrizeWidget(
      {required this.prizeName, required this.prizeIcon, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedImageNetwork(
            image: prizeIcon,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 65,
          child: Text(
            prizeName,
            style: TextStyle(
              fontSize: fontSize11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
