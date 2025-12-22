
import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:flutter/material.dart';

class SliderItems extends StatefulWidget {
  int? id;
  String? text;
  double? width;
  double? height;
  String? image;
  void Function()? onTap;


  SliderItems({
    super.key,
    required this.id,
    required this.text,
    this.width,
    this.height,
    required this.image,
    required this.onTap,
  });

  @override
  State<SliderItems> createState() => _SliderItemsState();
}

class _SliderItemsState extends State<SliderItems> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          CachedImageNetwork(image: widget.image, width: widget.width, height: widget.height,),
          Positioned(
              bottom: 25,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 5.0),
                      child: Text("${widget.text}",
                        style: TextStyle(
                            color: whiteColor,
                            shadows: [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                color: blackColor,
                                blurRadius: 12,
                              )
                            ],
                        ),
                      ),
                    )
                ),
              )
          )
        ],
      ),
    );
  }
}
