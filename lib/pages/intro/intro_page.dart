import 'dart:async';
import 'dart:convert';
// import 'package:ahzir/functions/firebase_setup.dart';
import 'package:ahzir/globals/base_urls.dart';
import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/models/model/user_model.dart';
import 'package:ahzir/pages/bottom_nav_pages.dart';
import 'package:ahzir/pages/intro/carousel.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gif/gif.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:js_util' as js_util;
import 'dart:html' as html;

class IntroPage extends StatefulWidget {
  final Map<String, dynamic>? notificationData;

  const IntroPage({super.key, this.notificationData});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // create an instance
  Timer? timer;
  bool? error = false;
  AuthViewModel? authProvider;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    try {
      authProvider = Provider.of<AuthViewModel>(context, listen: false);
    } catch (e) {
      print("❌ Error getting AuthViewModel: $e");
      authProvider = null;
    }

    Future.delayed(const Duration(seconds: 4)).then((value) {
      if (mounted) {
        addDuration();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: black100,
          child: Center(
            child: Gif(
                image: const AssetImage("$staticImgUrl/ihzar_intro1.gif"),
                autostart: Autostart.once),
          ),
        ),
      ),
    );
  }

  addDuration() async {
    // FirebaseSetup();
    checkUser(context: context);
    // authProvider?.updateFcmToken();
    // checkPageRedirection()
    // setupInteractMessage(context);
  }

  checkUser({required BuildContext context}) async {
    try {
      //check If user exists and if he's fully registered or no
      prefs = await SharedPreferences.getInstance();
      print("🔍 initialStepsChecked: ${prefs.getBool("initialStepsChecked")}");
      Response resp;
      if (kIsWeb) {
        print("🔍 Getting SuperQi token...");
        resp = await getSuperQiToken();
      } else {
        print("🔍 Getting refresh token...");
        if (authProvider == null) {
          throw Exception("AuthProvider is null");
        }
        if (authProvider != null) {
          final refreshResult =
              await authProvider?.refreshToken(context: context);
          if (refreshResult == null) {
            throw Exception("Refresh token returned null");
          }
          resp = refreshResult;
        } else {
          throw Exception("AuthProvider is null");
        }
      }

      if (prefs.getBool("initialStepsChecked") == true) {
        //if the user attempt the initial steps -> continue
        print("🔍 Platform check - kIsWeb: $kIsWeb");

        print("🔍 Response status: ${resp.statusCode}");
        print("🔍 Response data: ${resp.data}");
        final statusCode = resp.statusCode ?? 0;
        if (statusCode >= 200 && statusCode <= 399) {
          // For web (SuperQi), user info and token are already stored in getSuperQiToken()
          if (!kIsWeb) {
            print("userrrrrr: ${resp.data['user']}");
            // Only store for non-web platforms
            if (resp.data != null && resp.data['user'] != null) {
              await prefs.setString("userInfo", jsonEncode(resp.data['user']));
            }
            if (resp.data != null && resp.data['token'] != null) {
              await prefs.setString('token', resp.data['token']);
            }
            if (resp.data != null && resp.data['accessToken'] != null) {
              await prefs.setString('accessToken', resp.data['accessToken']);
            }
          }

          // Navigate to home page after successful authentication
          try {
            nextScreenCloseOthers(context, BottomNavPages());
          } catch (navError) {
            print("❌ Navigation error: $navError");
            // Fallback to carousel if navigation fails
            nextScreenCloseOthers(context, const Carousel());
          }
          return;
        } else {
          if (statusCode == 401) {
            await prefs.remove('token');
            await prefs.remove('accessToken');
            await prefs.remove('userInfo');
            nextScreenCloseOthers(context, BottomNavPages());
          } else {
            // Safe access to error message
            String errorMessage = 'Unknown error occurred';
            if (resp.data != null &&
                resp.data is Map &&
                resp.data.containsKey('message')) {
              errorMessage = resp.data['message']?.toString() ?? errorMessage;
            }

            nextScreenCloseOthers(context,
                ErrorPage(page: const IntroPage(), errorText: errorMessage));
            return;
          }
        }
        return;
      }
      // authProvider?.googleLogOut();
      nextScreenCloseOthers(context, const Carousel());
      return;
      // checkPageRedirection();
    } catch (error, stackTrace) {
      print("❌ Error in checkUser: $error");
      print("❌ Stack trace: $stackTrace");

      // Navigate to error page or carousel as fallback
      nextScreenCloseOthers(
          context,
          ErrorPage(
              page: const IntroPage(),
              errorText: "Authentication error: ${error.toString()}"));
    }
  }

  Future<dynamic> getSuperQiToken() async {
    // const res = {
    //   'user': {
    //     'id': 35,
    //     'fullName': 'micho',
    //     'avatar': 'user.avatar',
    //     'qiCustomerId': '216610000001224636961'
    //   },
    //   'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMTY2MTAwMDAwMDEyMjQ2MzY5NjEiLCJxaUFjY2Vzc1Rva2VuIjoiMjgxMzM0MDMwMjIwMjUxMTAzSkUzMnNoZXJKYzk2NUwwMDAxODcxNyIsImlhdCI6MTc2MzAyNDE0OSwiZXhwIjoxNzYzNjI4OTQ5fQ.bUCR8So6wHEZK2wmhovWUDTX_6JUK_Abr0DGC2qxBOs',
    //
    // };
    // int qi = int.parse('216610000001224636961');
    // var user = {
    //   'id': 40,
    //   'firstName': 'test',
    //   'lastName': 'test',
    //   'phone': '+9649182731238',
    //   'email': null,
    //   'password': null,
    //   'role': 'User',
    //   'otp': null,
    //   'otpRequestDate': null,
    //   'loginCount': 0,
    //   'activated': true,
    //   'usergroupstatus': null,
    //   'isBlocked': false,
    //   'isDeleted': false,
    //   'qiCustomerId': qi,
    //   'fullName': null,
    //   'avatar': null,
    //   'fcmToken': null,
    //   'totalpoints': 0,
    //   'groupId': null,
    // };
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMTY2MTAwMDAwMDEyMjQ2MzY5NjEiLCJxaUFjY2Vzc1Rva2VuIjoiMjgxMzM0MDMwMjIwMjUxMTAzSkUzMnNoZXJKYzk2NUwwMDAxODcxNyIsImlhdCI6MTc2MzM4NDEyMiwiZXhwIjoxNzYzOTg4OTIyfQ.qKr5TeoZnQ5ub1TXFyOC5fqAUa59Lp-EGeGFAYhjmi8');
    //
    // await prefs.setString('accessToken', '281334030220251103JE32sherJc965L00018717');
    // await prefs.setString('userInfo', jsonEncode(user));
    // return Response(
    //   data: res,
    //   statusCode: 200,
    //   requestOptions: RequestOptions(path: 'api/${BaseUrls.version}/auth/superqi'),
    // );
    final baseUrl = myIP;
    final prefs = await SharedPreferences.getInstance();
    // const storage = FlutterSecureStorage();

    try {
      final jsResult = await js_util.promiseToFuture(
        js_util.callMethod(
          js_util.getProperty(html.window, 'superQiAuth'),
          'getAuthCodeAndToken',
          [baseUrl],
        ),
      );

      // 🔥 Convert any JSObject → JSON string → Map
      dynamic data;
      if (jsResult is Map) {
        data = jsResult;
      } else {
        final jsonString = js_util.callMethod(
            js_util.getProperty(html.window, 'JSON'), 'stringify', [jsResult]);
        data = jsonDecode(jsonString);
      }

      // print("✅ Parsed backend response: $data");

      if (data == null) {
        throw Exception("Invalid response format: $data");
      }

      // Check if there's an error status
      if (data.containsKey('status') && data['status'] == 'error') {
        throw Exception(data['message'] ?? 'Authentication failed');
      }

      // Check if the response has the expected structure
      if (!data.containsKey('token') || data['token'] == null) {
        throw Exception("Token not found in response: $data");
      }

      if (!data.containsKey('user') || data['user'] == null) {
        throw Exception("User data not found in response: $data");
      }

      if (data.containsKey('accessToken')) {
        await prefs.setString('accessToken', data['accessToken']);
      }

      // Store the token
      await prefs.setString('token', data['token']);
      // await storage.write(key: 'token', value: data['token'].toString());

      // Store user info in the format expected by the rest of the app
      await prefs.setString('userInfo', jsonEncode(data['user']));
      // await storage.write(key: 'userInfo', value: jsonEncode(data['user']));
      //
      // // Also store in SharedPreferences if needed
      await prefs.setBool("initialStepsChecked", true);

      return Response(
        data: data,
        statusCode: 200,
        requestOptions:
            RequestOptions(path: '$baseUrl${BaseUrls.version}auth/apply-token'),
      );
    } catch (err, st) {
      // print("❌ Error in getSuperQiToken: $err\n$st");
      return Response(
        data: {'message': err.toString()},
        statusCode: 400,
        requestOptions:
            RequestOptions(path: '$baseUrl${BaseUrls.version}auth/apply-token'),
      );
    }
  }
}
