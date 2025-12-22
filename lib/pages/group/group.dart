import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/group_model.dart';
import 'package:ahzir/pages/chat/chat_page.dart';
import 'package:ahzir/pages/group/group_creation.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/group_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/chat/chat_group_widget.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class Group extends StatefulWidget {
  const Group({super.key});

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  GroupModel? group;
  DataLoadState groupState = DataLoadState.loading;
  String? groupError;
  GroupViewModel? groupProvider;

  @override
  void initState() {
    groupProvider = Provider.of<GroupViewModel>(context, listen: false);
    getGroup();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Group',
        centerTitle: true,
      ),
      body: buildContent(
          dataLoadState: groupState,
          loadingWidget: groupSkeleton(),
          errorWidget: ErrorPage(
            errorText: groupError,
            onPressed: () {
              setState(() {
                groupError = null;
                groupState = DataLoadState.loading;
                getGroup();
              });
            },
          ),
          loadedWidget: group != null ? SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ChatGroupWidget(
                onTap: group!.status != Statuses.accepted.name ? null : () => nextScreen(context, ChatPage(groupName: group?.name, groupLogo: group?.logo,)),
                groupName: group?.name,
                groupLogo: group?.logo,
                groupStatus: group!.status
            ),
          ) : Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("$staticImgUrl/error_load.png"),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text("You don't have a group", style: TextStyle(
                      fontSize: fontSize20,
                      color: whiteColor,
                    ),).tr(),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                    onPressed: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 800),
                        pageBuilder: (_, __, ___) => GroupCreation(isRegistering: false),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          // Fade transition for both current and new page
                          var fadeInOutTween = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).chain(CurveTween(curve: Curves.easeInOut));

                          return FadeTransition(
                            opacity: animation.drive(fadeInOutTween),
                            child: child,
                          );
                        },
                      ),
                    ).then((val){
                      if(val != null){
                        setState(() {
                          groupState = DataLoadState.loading;
                          groupError = null;
                        });
                        getGroup();
                      }
                    }),
                    text: "Create Group", width: MediaQuery.of(context).size.width * 0.6)
              ],
            ),
          )
      ),
    );
  }

  getGroup() async {
    Response response = await groupProvider?.getGroup();
    if(response.statusCode != null && (response.statusCode! >= 200 && response.statusCode! <= 399)){
      var res = response.data;
      if(res != null && res != '') {
        // debugPrint("ressssssssss: $res");
        group = GroupModel.fromJson(res);
      }
      groupState = DataLoadState.loaded;
    }else{
      groupState = DataLoadState.error;
      groupError = response.data['message'];
    }
    setState(() {
      group;
      groupState;
      groupError;
    });
  }
}
