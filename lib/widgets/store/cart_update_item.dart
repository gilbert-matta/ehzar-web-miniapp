

import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'dart:ui' as ui;

class CartUpdateItem extends StatelessWidget {
  final StoreModel cartInfo;
  final void Function()? onAddTap;
  final void Function()? onRemoveTap;


  const CartUpdateItem({
    required this.cartInfo,
    required this.onAddTap,
    required this.onRemoveTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50, // Adjust width to fit within ListTile
            height: 50, // Optional for maintaining aspect ratio
            child: ClipOval(child: CachedImageNetwork(image: "${cartInfo.logo}", fit: BoxFit.cover)),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.37,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${cartInfo.name}", style: TextStyle(
                    fontSize: fontSize12
                ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                Text("${numberWithComma(cartInfo.price * cartInfo.quantity)} ${cartInfo.currency}",
                    style: TextStyle(fontSize: fontSize13, fontWeight: FontWeight.bold),
                    textDirection: ui.TextDirection.ltr)
              ],
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: onAddTap, icon: Icon(Icons.add, color: whiteColor), splashRadius: 18, iconSize: 20),
              const SizedBox(width: 5),
              Text("${cartInfo.quantity}", style: TextStyle(fontSize: fontSize12),),
              const SizedBox(width: 5),
              IconButton(onPressed: onRemoveTap, icon: Icon(cartInfo.quantity == 1 ? Icons.delete_outline : Icons.remove, color: whiteColor), splashRadius: 18, iconSize: 20),
            ],
          )
        ],
      ),
    );
  }
}
