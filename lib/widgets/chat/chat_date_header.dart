import 'package:ahzir/index.dart';
import 'dart:ui' as ui;

class ChatDateHeader extends SliverPersistentHeaderDelegate {
  final String date;
  final Color backgroundColor;

  ChatDateHeader({required this.date, required this.backgroundColor});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Text(
              date,
              style: TextStyle(color: whiteColor, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant ChatDateHeader oldDelegate) {
    return date != oldDelegate.date;
  }
}
