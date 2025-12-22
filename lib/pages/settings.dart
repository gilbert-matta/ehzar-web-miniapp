import 'package:ahzir/functions/user.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/user_model.dart';
import 'package:ahzir/pages/auth/login.dart';
import 'package:ahzir/pages/bottom_nav_pages.dart';
import 'package:ahzir/pages/cart.dart';
import 'package:ahzir/pages/delete_account_page.dart';
import 'package:ahzir/pages/favorites/favorite_teams.dart';
import 'package:ahzir/pages/leaderboard/leaderboard.dart';
import 'package:ahzir/pages/match/daily_challenges.dart';
import 'package:ahzir/pages/settings/contact_us.dart';
import 'package:ahzir/pages/settings/rules.dart';
import 'package:ahzir/pages/settings/who_we_are.dart';
import 'package:ahzir/pages/store/Inventory.dart';
import 'package:ahzir/pages/store/store.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/alert_dialogs/alert_dialog.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/loader/loader.dart';
import 'package:ahzir/widgets/settings/settings_item.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group/group.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late SharedPreferences prefs;
  bool? isLoggedIn;
  UserModel? user;

  @override
  void initState() {
    checkIfLoggedIn();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            // isLoggedIn != null && isLoggedIn == true
            //     ? Column(
            //         children: [
            //           AppButton(
            //             onPressed: () => AlertDialogWidget(
            //                 context: context,
            //                 title: 'Logout',
            //                 content: "Are you sure you want to logout?",
            //                 onPressed: () {
            //                   logout();
            //                 },
            //                 yesBackgroundColor: redColor),
            //             text: "logout",
            //             textFontSize: fontSize18,
            //           ),
            //         ],
            //       )
            //     : AppButton(
            //         onPressed: () => Navigator.push(
            //           context,
            //           PageRouteBuilder(
            //             transitionDuration: const Duration(milliseconds: 800),
            //             pageBuilder: (_, __, ___) =>
            //                 const Login(isLoginSettings: true),
            //             transitionsBuilder:
            //                 (context, animation, secondaryAnimation, child) {
            //               // Fade transition for both current and new page
            //               var fadeInOutTween = Tween<double>(
            //                 begin: 0.0,
            //                 end: 1.0,
            //               ).chain(CurveTween(curve: Curves.easeInOut));
            //
            //               return FadeTransition(
            //                 opacity: animation.drive(fadeInOutTween),
            //                 child: child,
            //               );
            //             },
            //           ),
            //         ),
            //         // ).then((value) => checkIfLoggedIn()),
            //         // Navigator.push(context,
            //         // MaterialPageRoute(builder: (context) => const Login()))
            //         // .then((value) => checkIfLoggedIn()),
            //         //nextScreen(context, const Login()),
            //         text: "sign in",
            //       ),
            const SizedBox(height: 30),
            // SettingsItem(
            //   onTap: (){},
            //   text: "Settings",
            //   icon: Icons.settings_outlined,
            //   iconColor: greyColor,
            // ),
            SettingsItem(
              onTap: () => nextScreen(context, WhoWeAre()),
              text: "Who We Are",
              icon: Icons.person_outline,
              iconColor: greyColor,
            ),
            SettingsItem(
              onTap: () => nextScreen(context, const ContactUs()),
              text: "Contact Us",
              icon: Icons.email_outlined,
              iconColor: greyColor,
            ),
            SettingsItem(
              onTap: () => nextScreen(context, const RulesPage()),
              text: "Rules",
              icon: Icons.rule,
              iconColor: greyColor,
            ),
            isLoggedIn == true
                ? Column(
                    children: [
                      SettingsItem(
                        onTap: () => nextScreen(
                            context,
                            FavoriteTeams(
                                navigateTo: BottomNavPages(index: 4),
                                isRegistering: false)),
                        text: "Favorite Teams",
                        icon: Icons.sports,
                        iconColor: greyColor,
                      ),
                      // SettingsItem(
                      //   onTap: () => nextScreen(context, Store()),
                      //   text: "Store",
                      //   icon: Icons.store_outlined,
                      //   iconColor: greyColor,
                      // ),
                      SettingsItem(
                        onTap: () => nextScreen(context, Inventory()),
                        text: "Vouchers",
                        icon: Icons.collections_bookmark_outlined,
                        iconColor: greyColor,
                      ),
                      SettingsItem(
                        onTap: () => nextScreen(context, Cart()),
                        text: "Cart",
                        icon: Icons.shopping_cart_outlined,
                        iconColor: greyColor,
                      ),
                      SettingsItem(
                        onTap: () => nextScreen(context, DailyChallenges()),
                        text: "Daily challenges",
                        icon: Icons.games_outlined,
                        iconColor: greyColor,
                      ),
                      SettingsItem(
                        onTap: () => nextScreen(context, Leaderboard()),
                        text: "Leaderboard",
                        icon: Icons.leaderboard_outlined,
                        iconColor: greyColor,
                      ),
                      // SettingsItem(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       PageRouteBuilder(
                      //         transitionDuration:
                      //             const Duration(milliseconds: 800),
                      //         pageBuilder: (_, __, ___) => DeleteAccountPage(),
                      //         transitionsBuilder: (context, animation,
                      //             secondaryAnimation, child) {
                      //           // Fade transition for both current and new page
                      //           var fadeInOutTween = Tween<double>(
                      //             begin: 0.0,
                      //             end: 1.0,
                      //           ).chain(CurveTween(curve: Curves.easeInOut));
                      //
                      //           return FadeTransition(
                      //             opacity: animation.drive(fadeInOutTween),
                      //             child: child,
                      //           );
                      //         },
                      //       ),
                      //     ).then((val) {
                      //       if (val == true) {
                      //         checkIfLoggedIn();
                      //       }
                      //     });
                      //   },
                      //   text: "Delete account",
                      //   textColor: redColor,
                      //   icon: Icons.delete_outline,
                      //   iconColor: redColor,
                      // ),
                      // SettingsItem(
                      //   onTap: () => nextScreen(context, Group()),
                      //   text: "Group",
                      //   icon: Icons.group,
                      //   iconColor: greyColor,
                      // ),
                      // SettingsItem(
                      //   onTap: () => nextScreen(context, Container()),
                      //   text: "Invitations",
                      //   icon: Icons.inbox_outlined,
                      //   iconColor: greyColor,
                      // )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  checkIfLoggedIn() async {
    // String? userStorage = await storage.read(key: 'userInfo');
    // if (userStorage != null) {
    //   print("userinfooo: $userStorage");
    //   final decodedData = jsonDecode(userStorage) as Map<String, dynamic>;
    //   user = UserModel.fromJson(decodedData);
    // }
    isLoggedIn = await checkUserIfLoggedIn();
    setState(() {});
  }

  logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    // storage.delete(key: 'fcmtoken');  //if user logged out, will not receive notification to his account.
    prefs.remove('userInfo');
    prefs.remove('userLevel'); //remove user level from storage.
    checkIfLoggedIn();
    Navigator.pop(context);
  }
}
