import 'dart:convert';
import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/store/card_price_store.dart';
import 'package:dio/dio.dart';
import 'dart:ui' as ui;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {

  late SharedPreferences prefs;

  List<StoreModel> store = [];
  DataLoadState storeState = DataLoadState.loading;
  String? storeError;

  // GroupViewModel? groupProvider;
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  int limit = 10;
  bool _isLoadingData = false;
  bool dataFinishedOnScroll = false;
  // TextEditingController _redeemController = TextEditingController();
  StoreViewModel? storeProvider;

  @override
  void initState() {
    storeProvider = Provider.of<StoreViewModel>(context, listen: false);
    // getStore();
    // _scrollController.addListener(() {
    //   if (!_isLoadingData &&
    //       _scrollController.position.pixels ==
    //           _scrollController.position.maxScrollExtent) {
    //     // if (isMobile(context)) {
    //     //   getArticles();
    //     // }
    //     getStore();
    //   }
    // });
    // _redeemController.addListener(() {
    //   setState((){});
    // });
    getStore();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Store',
        centerTitle: true,
      ),
      body: store.isNotEmpty
          ?
      //for tablet
      // GridView.count(
      //         controller: _scrollController,
      //         crossAxisCount: 1,
      //         mainAxisSpacing: 10,
      //         crossAxisSpacing: 10,
      //         padding: EdgeInsets.symmetric(vertical: 10),
      //         childAspectRatio: 1.8,
      //         // Generate 100 widgets that display their index in the list.
      //         children: List.generate(
      //             store.length + (_isLoadingData ? 1 : 0), (i) {
      //           if (i < store.length) {
      //             return Center(
      //               child: Padding(
      //                 padding: const EdgeInsets.only(top: 10.0),
      //                 child: CardPriceStore(cardInfo: store[i], onTap: (){}),
      //               ),
      //             );
      //           } else {
      //             // if (isMobile(context)) {
      //               return const CircularProgressWidget();
      //             // }
      //             // return Container();
      //           }
      //         }),
      //       )
      SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
        child: Column(
          children: List.generate(
              store.length + (_isLoadingData ? 1 : 0), (i) {
            if (i < store.length) {
              return Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: CardPriceStore(
                      cardInfo: store[i],
                      onTap: () {
                        if(store[i].quantity > 0){
                          //TODO save the item in a storage locally.
                          saveOrUpdateStoreList(store[i]);
                          appSnackBar(context: context, msg: 'Item added to cart');
                          Navigator.pop(context);
                          // StoreDialogPayment(
                          //     context: context,
                          //     onPressedRedeem: (){},
                          //     onPressedCard: (){},
                          //     redeemController: _redeemController
                          // );
                        }
                      },
                      onAddTap: (){
                        setState(() {
                          store[i].quantity ++;
                        });
                      },
                      onRemoveTap: (){
                        setState(() {
                          if(store[i].quantity > 0){
                            store[i].quantity --;
                          }
                        });
                      },
                    )
                ),
              );
            } else {
              // if (isMobile(context)) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: const CircularProgressWidget(),
              );
              // }
              // return Container();
            }
          }),
        ),
      )
          : ErrorTextPage(
        errorText: "The store is empty",
      ),
    );
  }

  getStore() async {
    print("storeeeeeeeeee: $store");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storeData = await prefs.getString('store');
    if(storeData != null){
      store = json.decode(storeData);
    }
    setState(() {
      store;
    });
    print("storeeeeeeeeee: $store");
  }
  // getStore() async{
  //   if (!_isLoadingData && !dataFinishedOnScroll) {
  //     setState(() {
  //       _isLoadingData = true;
  //     });
  //     Response response = await storeProvider?.getStore(
  //         page: _page, limit: limit, campaignName: 'lantern');
  //     if (response.statusCode != null &&
  //         response.statusCode! >= 200 &&
  //         response.statusCode! <= 399) {
  //       List<dynamic> res = response.data['data'];
  //       List<StoreModel> tempFilterList = res
  //           .map((e) =>
  //           StoreModel.fromJson(e as Map<String, dynamic>))
  //           .toList();
  //       store.addAll(tempFilterList);
  //
  //       if (tempFilterList.length < limit) {
  //         dataFinishedOnScroll = true;
  //       }
  //       setState(() {
  //         storeState = DataLoadState.loaded;
  //         _isLoadingData = false;
  //         _page++;
  //         store;
  //       });
  //     } else {
  //       if(_page > 1) {
  //         appSnackBar(
  //             context: context, msg: response.data['message'], isError: true);
  //       }else{
  //         storeState = DataLoadState.error;
  //         storeError = response.data['message'];
  //       }
  //     }
  //     setState(() {
  //       storeState;
  //       dataFinishedOnScroll;
  //       store;
  //       _isLoadingData = false;
  //       storeError;
  //     });
  //   }
  // }

  Future<void> saveOrUpdateStoreList(StoreModel newStoreList) async {
    prefs = await SharedPreferences.getInstance();
    // Step 1: Check if data exists
    String? encodedList = await prefs.getString('store');
    // debugPrint("store list: $encodedList");

    // Step 2: Decode existing data (if available)
    List<StoreModel> existingList = [];
    if (encodedList != null) {
      List<dynamic> decodedList = jsonDecode(encodedList);
      existingList = decodedList.map((e) => StoreModel.fromJson(e)).toList();
    }

    existingList.add(newStoreList);

    // Step 4: Save the updated list back to storage
    String updatedList = jsonEncode(existingList.map((e) => e.toJson()).toList());
    await prefs.setString('store', updatedList);

    // debugPrint('✅ Data successfully saved!');
  }
}
