
import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/content_management_model.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {

  DataLoadState state = DataLoadState.loading;
  ContentManagementModel? content;
  String? error;
  AuthViewModel? _authProvider;

  @override
  void initState() {
    _authProvider = Provider.of<AuthViewModel>(context, listen: false);
    getContent();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: buildContent(
          dataLoadState: state,
          loadingWidget: settingsSkeleton(context: context, height: MediaQuery.of(context).size.height),
          errorWidget: ErrorPage(
            errorText: error,
            onPressed: () {
              setState(() {
                error = null;
                state = DataLoadState.loading;
                getContent();
              });
            },
          ),
          loadedWidget: content != null ? SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          color: greyColor!,
                          blurRadius: 3,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "${content?.title}",
                              style:
                              const TextStyle(fontSize: 20, fontWeight: null, decoration: TextDecoration.underline),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${parse(content?.description).body?.text}",
                            style:
                            const TextStyle(fontSize: 14, fontWeight: null),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ) : ErrorTextPage(errorText: 'No data found'),
        ));
  }

  getContent() async{
    Response response = await _authProvider?.getContentManagement();
    if(response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)){
      List<dynamic> res = response.data;
      List<ContentManagementModel> cms = res.map((e) => ContentManagementModel.fromJson(e)).toList();
      content = cms.any((item) => item.code == 'rules')
          ? cms.firstWhere((item) => item.code == 'rules')
          : null;
      // for(ContentManagementModel ct in cms){
      //   print("cmss: ${ct.code}");
      // }

      state = DataLoadState.loaded;

    }else{
      state = DataLoadState.error;
      error = response.data['message'];
    }

    setState(() {
      content;
      state;
      error;
    });
  }
}
