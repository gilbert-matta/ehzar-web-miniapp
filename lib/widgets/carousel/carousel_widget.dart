
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatefulWidget {
  final List<dynamic> imgList;
  final void Function(int index)? onTap; // Update onTap to include index
  final bool? autoPlay;

  const CarouselWidget({
    this.imgList = const [],
    this.onTap,
    this.autoPlay,
    super.key
  });

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: widget.imgList.map((item) => GestureDetector(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!(item.id); // Corrected: Safely call the function,  // Pass index here,
              }
            },
            child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    gradient: blueMauveLinearGrad
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: CachedImageNetwork(image: item.icon, width: double.infinity))),
          )
          ).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: widget.autoPlay ?? false,
            enlargeCenterPage: true,
            viewportFraction: isMobile(context) ? 0.8 : 0.6, //et7akam bl width eza bte5do kello or no.
            aspectRatio: isMobile(context) ? 2.0 : 3.5,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 6.0,
                height: 6.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == entry.key
                      ? Colors.blueAccent // Active indicator color
                      : blackColor, // Inactive indicator color
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
