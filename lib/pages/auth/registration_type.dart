import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/pages/bottom_nav_pages.dart';
import 'package:ahzir/pages/favorites/favorite_teams.dart';
import 'package:ahzir/pages/group/group_creation.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/cards/icon_card_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

class RegistrationType extends StatefulWidget {
  const RegistrationType({super.key});

  @override
  State<RegistrationType> createState() => _RegistrationTypeState();
}

class _RegistrationTypeState extends State<RegistrationType> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          titleWidget: SvgPicture.asset("$staticImgUrl/logo/ihzar.svg"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  // color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage('$staticImgUrl/stadium.png'),
                    // Replace with your image path
                    fit: BoxFit
                        .cover, // This ensures the image covers the entire container
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevents over-expanding in the Column
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      color: Colors.white.withValues(alpha: 0.05),
                      child: Center(
                        child: Text(
                          "Registration Type",
                          style: TextStyle(fontSize: fontSize28),
                        ).tr(),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    IconCardButton(
                        text: 'Individual',
                        gradient: blueMauveLinearGrad,
                        onPressed: () => nextScreenCloseOthers(
                            context,
                            FavoriteTeams(
                                navigateTo: BottomNavPages(index: 4),
                                isRegistering: true)),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        icon: Icon(Icons.person, size: 160, color: whiteOpacity30)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    IconCardButton(
                        text: 'Group',
                        gradient: blueMauveLinearGrad,
                        onPressed: () =>
                            nextScreenAnimatedOpacity(context, GroupCreation(isRegistering: true)),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        icon: Icon(Icons.group, size: 160, color: whiteOpacity30)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
