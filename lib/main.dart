import 'package:ahzir/functions/firebase_setup.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/repository/level_repository.dart';
import 'package:ahzir/pages/intro/intro_page.dart';
import 'package:ahzir/view-model/article_view_model.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/view-model/championship_view_model.dart';
import 'package:ahzir/view-model/group_view_model.dart';
import 'package:ahzir/view-model/leaderboard_view_model.dart';
import 'package:ahzir/view-model/level_view_model.dart';
import 'package:ahzir/view-model/match_view_model.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/view-model/team_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'hexColor/hex_color.dart';
import 'models/repository/match_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await FlutterDownloader.initialize(
      debug: false, // optional
      ignoreSsl: true,
    );
  }
  await EasyLocalization.ensureInitialized();

  await initializeDateFormatting(); // Import the function from intl package
  // await firebaseSetup();

  // const preferences = FlutterSecureStorage();
  // String? lan = await preferences.read(key: "language");
  // if(lan == null || lan == ''){
  //   lan = 'en';
  //   preferences.write(key: "language", value: lan);
  // }

  await SentryFlutter.init((options) {
    options.dsn =
        'https://3e6cafb830324cbf6ca8eba03bb8af0a@o4506315531157504.ingest.us.sentry.io/4509310527406080';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    options.profilesSampleRate = 1.0;
  },
      appRunner: () => SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]).then((value) => runApp(MultiProvider(
                  providers: [
                    //i'm using DI (dependency injection) using provider
                    Provider<LevelRepository>(create: (_) => LevelRepository()),
                    Provider<MatchRepository>(create: (_) => MatchRepository()),
                    ChangeNotifierProvider(create: (_) => AuthViewModel()),
                    ChangeNotifierProvider(
                        create: (context) => MatchViewModel(
                            matchRepository: context.read<MatchRepository>())),
                    ChangeNotifierProvider(
                        create: (_) => ChampionshipViewModel()),
                    ChangeNotifierProvider(create: (_) => TeamViewModel()),
                    ChangeNotifierProvider(
                        create: (_) => LeaderboardViewModel()),
                    ChangeNotifierProvider(create: (_) => ArticleViewModel()),
                    ChangeNotifierProvider(create: (_) => GroupViewModel()),
                    ChangeNotifierProvider(create: (_) => StoreViewModel()),
                    ChangeNotifierProvider(
                        create: (context) => LevelViewModel(
                              levelRepository: context.read<LevelRepository>(),
                            )),
                  ],
                  child: EasyLocalization(
                    supportedLocales: const [
                      Locale('en'),
                      Locale('ar'),
                      Locale('fr')
                    ],
                    path: 'assets/translations',
                    fallbackLocale: const Locale('ar'),
                    startLocale: const Locale('ar'),
                    useOnlyLangCode: true,
                    child: const MyApp(),
                  )))));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static late List<LocalizationsDelegate> delegates;

  // late SharedPreferences prefs;
  // ThemeMode systemThemeMode = ThemeMode.system;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    delegates = context.localizationDelegates;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor:
              primaryColor), //changes the notification header in the app
    );
    return SkeletonTheme(
      shimmerGradient: LinearGradient(
        colors: [
          HexColor("#2F3A55"),
          HexColor('#4C5877'),
          HexColor("#2F3A55"),
        ],
        stops: const [0.1, 0.5, 0.9],
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // navigatorKey: navigatorKey,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: delegates,
        locale: context.locale,
        title: 'Ihzar',
        theme: ThemeData(
          scaffoldBackgroundColor: primaryColor,
          // add the scaffolds background color
          canvasColor: primaryColor,
          //make the background color of the entire application canvas white
          useMaterial3: false,
          // colorScheme: ColorScheme.fromSwatch()
          //     .copyWith(primary: appbarColor, background: whiteColor),
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColor,
            titleTextStyle:
                TextStyle(color: blackColor, fontFamily: sfArabicRegular),
            toolbarTextStyle: TextStyle(color: blackColor),
            actionsIconTheme: IconThemeData(color: blackColor),
            iconTheme: IconThemeData(color: blackColor),
          ),
          tabBarTheme: TabBarTheme(
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: blackColor, // Replace with your desired color
                  width: 2.0, // Replace with your desired line width
                ),
              ),
            ),
            labelColor: monochromatic02,
            unselectedLabelColor: monochromatic02,
          ),
          textTheme: TextTheme(
            bodyMedium: TextStyle(
                color: whiteColor,
                fontFamily: sfArabicRegular,
                fontWeight: FontWeight.w500),
            // bodyLarge: TextStyle(color: whiteColor, fontFamily: sfArabicRegular, fontWeight: FontWeight.w500),
            // bodySmall: TextStyle(color: whiteColor, fontFamily: sfArabicRegular, fontWeight: FontWeight.w500),
            titleSmall: TextStyle(
                color: whiteColor,
                fontFamily: sfArabicRegular,
                fontWeight: FontWeight.w500),
            titleLarge: TextStyle(
                color: whiteColor,
                fontFamily: sfArabicRegular,
                fontWeight: FontWeight.w500),
            titleMedium: TextStyle(
                color: whiteColor,
                fontFamily: sfArabicRegular,
                fontWeight: FontWeight.w500),
          ),
          // elevatedButtonTheme: ElevatedButtonThemeData(
          //   style: ElevatedButton.styleFrom(
          //     textStyle: TextStyle(
          //
          //     )
          //   )
          // )
        ),
        // DARK MODE
        // darkTheme: ThemeData.dark().copyWith(
        //   scaffoldBackgroundColor: defaultColor,
        //   canvasColor: defaultColor,
        //   useMaterial3: false,
        //   appBarTheme: AppBarTheme(
        //       backgroundColor: Colors.transparent,
        //       titleTextStyle: TextStyle(color: secondaryColor),
        //       toolbarTextStyle: TextStyle(color: secondaryColor),
        //       actionsIconTheme: IconThemeData(color: secondaryColor),
        //       iconTheme: IconThemeData(color: secondaryColor)),
        //   textTheme: TextTheme(
        //     bodyMedium: TextStyle(color: secondaryColor, fontFamily: inter500),
        //     bodyLarge: TextStyle(color: secondaryColor, fontFamily: inter500),
        //     bodySmall: TextStyle(color: secondaryColor, fontFamily: inter500),
        //     titleSmall: TextStyle(color: secondaryColor, fontFamily: inter500),
        //     titleLarge: TextStyle(color: secondaryColor, fontFamily: inter500),
        //     titleMedium: TextStyle(color: secondaryColor, fontFamily: inter500),
        //   ),
        // ),
        // Light Theme
        themeMode: ThemeMode.light,
        //Provider.of<UserProvider>(context).getDarkLightMode == true ? ThemeMode.dark : ThemeMode.light, // this will force the app to only use the light theme
        home: const IntroPage(),
      ),
    );
  }
}
