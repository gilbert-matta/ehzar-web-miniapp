
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/pages/predictions_history.dart';
import 'package:ahzir/pages/home.dart';
import 'package:ahzir/pages/notifications.dart';
import 'package:ahzir/pages/search.dart';
import 'package:ahzir/pages/settings.dart';
import 'package:ahzir/widgets/bottom_nav_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavPages extends StatefulWidget {
  int? index;
  BottomNavPages({
    super.key,
    this.index,
  });

  @override
  State<BottomNavPages> createState() => _BottomNavPagesState();
}

class _BottomNavPagesState extends State<BottomNavPages> {
  int pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ((widget.index != null && widget.index != 0) || pageIndex != 0) ? AppBar(
        title: SvgPicture.asset("$staticImgUrl/logo/ihzar.svg"),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ) : null,
      body: widget.index != null ?
      _getPage(widget.index!) : _getPage(pageIndex),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return const SafeArea(child: Search());
      case 2:
        return const PredictionsHistory();
      case 3:
        return const Notifications();
      case 4:
        return const Settings();
      default:
        return Container();
    }
  }

  bottomNavBar(BuildContext context) {
    pageIndex = widget.index ?? pageIndex;
    widget.index = null;
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: grey1D,
        border: Border(
          top: BorderSide(
            color: monochromatic02, // Set the color of the top border
            width: 1.0, // Set the width of the top border
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavIcon(
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              pageIndex: pageIndex,
              index: 0,
              color: secondaryColor,
              textColor: secondaryColor,
              icon: Icons.home_outlined,
              iconSize: 30,
              title: 'Home',
            ),
            BottomNavIcon(
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              pageIndex: pageIndex,
              index: 1,
              color: secondaryColor,
              textColor: secondaryColor,
              image: "$staticImgUrl/search.svg",
              imageHeight: 24,
              imageWidth: 24,
              title: "Explore",
            ),
            BottomNavIcon(
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              pageIndex: pageIndex,
              index: 2,
              color: secondaryColor,
              textColor: secondaryColor,
              image: "$staticImgUrl/ball.svg",
              imageHeight: 24,
              imageWidth: 24,
              title: "Predictions",
            ),
            BottomNavIcon(
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              pageIndex: pageIndex,
              index: 3,
              color: secondaryColor,
              textColor: secondaryColor,
              image: "$staticImgUrl/notification.svg",
              imageHeight: 24,
              imageWidth: 24,
              title: "Notification",
            ),
            BottomNavIcon(
              onPressed: () {
                setState(() {
                  pageIndex = 4;
                });
              },
              pageIndex: pageIndex,
              index: 4,
              color: secondaryColor,
              textColor: secondaryColor,
              icon: Icons.apps,
              iconSize: 30,
              title: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
