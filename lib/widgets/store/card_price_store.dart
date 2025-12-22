


import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';

class CardPriceStore extends StatelessWidget {
  final StoreModel cardInfo;
  final void Function()? onTap;
  final void Function()? onAddTap;
  final void Function()? onRemoveTap;

  const CardPriceStore({
    required this.cardInfo,
    required this.onTap,
    required this.onAddTap,
    required this.onRemoveTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: whiteOpacity20),
        borderRadius: BorderRadius.circular(12),
        color: whiteOpacity5
      ),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              width: 50, // Adjust width to fit within ListTile
              height: 50, // Optional for maintaining aspect ratio
              child: ClipOval(child: CachedImageNetwork(image: cardInfo.logo, fit: BoxFit.cover)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text("${cardInfo.name}", style: TextStyle(
                fontSize: fontSize14
              ), maxLines: 2, overflow: TextOverflow.ellipsis)
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${'Price'.tr()}:", style: TextStyle(fontSize: fontSize12),).tr(),
                Text("${numberWithComma(cardInfo.price)} ${cardInfo.currency}",
                    style: TextStyle(fontSize: fontSize13, fontWeight: FontWeight.bold),
                    textDirection: ui.TextDirection.ltr)
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text("${'Error Reduction'.tr()}: ", style: TextStyle(fontSize: fontSize12)),
                  const SizedBox(width: 3),
                  // Text("${cardInfo.percentageMarginError}%", style: TextStyle(fontSize: fontSize14, fontWeight: FontWeight.bold, height: 2))
                ],
              ),
              Row(
                children: [
                  Text("Quantity").tr(),
                  Row(
                    children: [
                      IconButton(onPressed: onAddTap, icon: Icon(Icons.add, color: whiteColor), splashRadius: 20),
                      Text("${cardInfo.quantity}"),
                      IconButton(onPressed: onRemoveTap, icon: Icon(Icons.remove, color: whiteColor), splashRadius: 20),
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppButton(onPressed: cardInfo.quantity > 0 ? onTap : null, text: 'Add to cart', borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          color: cardInfo.quantity > 0 ? null : greyColor,
          )
        ],
      ),
    );
  }
}
