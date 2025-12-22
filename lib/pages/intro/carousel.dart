import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/globals/ips.dart';
import 'package:ahzir/models/model/content_management_model.dart';
import 'package:ahzir/pages/bottom_nav_pages.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/alert_dialogs/policy_dialog.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/widgets/carousel/introCarousel.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ahzir/index.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  DataLoadState loadData = DataLoadState.loading;
  AuthViewModel? authProvider;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Object? groupValue;
  List<ContentManagementModel> cms = [];
  ContentManagementModel? carousel1;
  ContentManagementModel? carousel2;
  ContentManagementModel? carousel3;
  ContentManagementModel policyContent = ContentManagementModel(
      code: 'policy', title: 'Privacy Policy', image: null, description: r'''
  سياسة الخصوصية

مرحبًا بك في أحزر! نحن نولي أهمية كبيرة لخصوصيتك، ونلتزم بحماية معلوماتك الشخصية. يرجى قراءة سياسة الخصوصية هذه بعناية لفهم كيفية جمعنا لمعلوماتك واستخدامها وحمايتها.

1. المعلومات التي نقوم بجمعها
قد نقوم بجمع الأنواع التالية من المعلومات:

المعلومات الشخصية: مثل اسمك، بريدك الإلكتروني، رقم هاتفك، وأي معلومات أخرى تقدمها عند التسجيل أو استخدام التطبيق.
2. كيفية استخدامنا لمعلوماتك
نستخدم المعلومات التي نجمعها من أجل:

توفير وتحسين خدمات التطبيق.
تخصيص تجربتك مع التطبيق.
إرسال التحديثات والإشعارات والمحتوى الترويجي.
ضمان عمل التطبيق بكفاءة وأمان.
3. مشاركة معلوماتك
نحن لا نقوم ببيع معلوماتك الشخصية، ولكن قد نشاركها مع:

مزودي الخدمة: لدعم وظائف التطبيق (مثل الاستضافة، التحليلات، دعم العملاء).
السلطات القانونية: إذا كان ذلك مطلوبًا بموجب القانون أو لحماية التطبيق ومستخدميه.
4. أمن البيانات
نحن نعتمد تدابير أمان معتمدة على مستوى الصناعة لحماية معلوماتك من الوصول غير المصرح به أو التعديل أو التدمير. ومع ذلك، لا توجد طريقة نقل أو تخزين بيانات آمنة تمامًا، ولا يمكننا ضمان الأمان المطلق.

5. ملفات تعريف الارتباط والتقنيات المشابهة
نحن نستخدم ملفات تعريف الارتباط والتقنيات المشابهة لتحسين تجربة المستخدم. يمكنك إدارة تفضيلات ملفات تعريف الارتباط من خلال إعدادات جهازك.

6. تحديثات سياسة الخصوصية
قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر لتعكس تغييرات في ممارساتنا. سيتم نشر التحديثات على هذه الصفحة، وسيتم تعديل تاريخ السريان.

يرجى قراءة هذه السياسة والموافقة عليها قبل استخدام التطبيق. نحن نقدر ثقتك بنا ونسعى دائمًا لحماية بياناتك.
  ''');

  @override
  void initState() {
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    getPolicyAndContent();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                // color: greyColor,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    // Pages of the introduction screen
                    introCarousel(
                        context: context,
                        loadState: loadData,
                        ImageWidget: carousel1?.image != null
                            ? CachedImageNetwork(
                                image: carousel1?.image,
                                loadingHeight: 300,
                              )
                            : Image.asset(
                                "$staticImgUrl/carousel/carousel1.png",
                                width: screenWidth < 600.0
                                    ? 300
                                    : MediaQuery.of(context).size.width * 0.7,
                                // height: MediaQuery.of(context).size.height * 0.685,
                                // fit: BoxFit.fill
                              ),
                        text: carousel1?.title ??
                            'مرحبًا بك في  التطبيق إحزر  مركز توقعاتك للبطولات!',
                        description: carousel1?.description ??
                            'قم بتخمين نتائج جميع المباريات، تسلق لوحة المتصدرين، واربح جوائز مميزة!'),
                    introCarousel(
                        context: context,
                        loadState: loadData,
                        ImageWidget: carousel2?.image != null
                            ? CachedImageNetwork(
                                image: carousel2?.image, loadingHeight: 300)
                            : Image.asset(
                                "$staticImgUrl/carousel/carousel2.png",
                                width: screenWidth < 600.0
                                    ? 300
                                    : MediaQuery.of(context).size.width * 0.7,
                                // height: MediaQuery.of(context).size.height * 0.685,
                                // fit: BoxFit.fill
                              ),
                        text: carousel2?.title ?? 'كيف يعمل التطبيق؟',
                        description: carousel2?.description ??
                            '•  قم بتوقع نتائج كل مباراة في البطولة.'
                                '\n•  احصل على نقاط مقابل كل توقع صحيح.'
                                '\n•  نافس الآخرين واحجز مكانك في القمة!'),
                    introCarousel(
                        context: context,
                        loadState: loadData,
                        ImageWidget: carousel3?.image != null
                            ? CachedImageNetwork(
                                image: carousel3?.image, loadingHeight: 300)
                            : Image.asset(
                                "$staticImgUrl/carousel/carousel3.png",
                                width: screenWidth < 600.0
                                    ? 300
                                    : MediaQuery.of(context).size.width * 0.7,
                                // height: MediaQuery.of(context).size.height * 0.685,
                                // fit: BoxFit.fill
                              ),
                        text: carousel3?.title ?? 'إربح الجوائز!',
                        description: carousel3?.description ??
                            'كلما كانت توقعاتك دقيقة، زادت الجوائز. هل أنت مستعد للعب، الفوز، والسيطرة على البطولة؟"'),
                  ],
                ),
              ),
              Positioned(
                  bottom: 30,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0;
                                    i < 3;
                                    i++) // Replace 3 with the number of pages
                                  _currentPage != i
                                      ? Container(
                                          width: 9,
                                          height: 9,
                                          margin: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: whiteOpacity20,
                                            // color: Theme.of(context).brightness == Brightness.dark ? whiteColor : greyLight,   //for dark mode also
                                          ),
                                        )
                                      : Container(
                                          width: 25,
                                          height: 9,
                                          margin: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          left: 20,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<OutlinedBorder>(
                                const CircleBorder(), // Use CircleBorder for a circular shape
                              ),
                              backgroundColor:
                                  WidgetStatePropertyAll(secondaryColor),
                              fixedSize: WidgetStateProperty.all<Size>(
                                  const Size(40, 40)),
                            ),
                            child: const Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                            onPressed: () async {
                              if (_currentPage < 2) {
                                // Move to the next page
                                _pageController.animateToPage(
                                  _currentPage + 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                showPrivacyPolicyDialog(
                                    policyTitle: policyContent.title,
                                    policyContent: policyContent.description,
                                    context: context,
                                    groupValue: groupValue,
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool("initialStepsChecked",
                                          true); // set it to true so when the user restart the app to directly go to the page so he  did not repeat these steps
                                      // If it's the last page, go to the next screen directly
                                      nextScreenCloseOthers(
                                          context, BottomNavPages());
                                    });
                              }
                            },
                          ))
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }

  getPolicyAndContent() async {
    Response response = await authProvider?.getContentManagement();
    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      List<dynamic> res = response.data;
      cms = res.map((e) => ContentManagementModel.fromJson(e)).toList();
      ContentManagementModel? policyContentItem =
          cms.any((item) => item.code == 'policy')
              ? cms.firstWhere((item) => item.code == 'policy')
              : null;
      carousel1 = cms.any((item) => item.code == 'carousel1')
          ? cms.firstWhere((item) => item.code == 'carousel1')
          : null;

      carousel2 = cms.any((item) => item.code == 'carousel2')
          ? cms.firstWhere((item) => item.code == 'carousel2')
          : null;

      carousel3 = cms.any((item) => item.code == 'carousel3')
          ? cms.firstWhere((item) => item.code == 'carousel3')
          : null;

      if (policyContentItem != null) {
        policyContent = policyContentItem;
      }
    }

    setState(() {
      cms;
      policyContent;
      loadData = DataLoadState.loaded;
    });
  }
}
