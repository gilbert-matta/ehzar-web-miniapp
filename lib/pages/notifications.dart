


import 'dart:convert';
import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/notification_model.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/notification_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // UserProvider? userProvider;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<NotificationModel>? notificationList;
  DataLoadState notificationState = DataLoadState.loading;
  String? error;

  @override
  void initState() {
    // userProvider = Provider.of<UserProvider>(context, listen: false);
    getNotifications();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: defaultSkeleton(
          context: context,
          loadState: notificationState,
          loadingWidget: skeletonNotification(context),
          errorWidget: ErrorTextPage(errorText: error),
          dataWidget: notificationList != null && notificationList!.isNotEmpty? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  Column(
                    children: List.generate(notificationList!.length, (i) {
                      int reversedIndex = notificationList!.length - 1 - i;
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: NotificationWidget(
                          // onTap: () => nextScreen(context, ItemContent(
                          //   articleSlug: notificationList?[reversedIndex].slug,
                          // )),
                          title: notificationList?[reversedIndex].title,
                          body: notificationList?[reversedIndex].body ?? '',
                          // date: //notificationList?[reversedIndex].date
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ) : const ErrorTextPage(errorText: "Notification list is empty"),
      )
    );
  }

  getNotifications() async{
    String? storedData = await storage.read(key: 'notificationsList');
    // If the stored data is not null, decode it into a List, otherwise return an empty list.
    List<dynamic> notifList = storedData != null ? jsonDecode(storedData) : [];
    List<NotificationModel> notifications = [];
    for (String item in notifList) {
      Map<String, dynamic> jsonMap = jsonDecode(item);
      NotificationModel notification = NotificationModel.fromJson(jsonMap);
      notifications.add(notification);
    }

    setState(() {
      notificationList = notifications;
      notificationState = DataLoadState.loaded;
    });
  }
}
