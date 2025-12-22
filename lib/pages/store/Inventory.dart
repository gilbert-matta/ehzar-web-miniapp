import 'dart:convert';

import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/content_management_model.dart';
import 'package:ahzir/models/model/purchase_model.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:ahzir/screens/skeleton_loading.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/widgets/alert_dialogs/policy_dialog.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/build_content.dart';
import 'package:ahzir/widgets/circular_progress_widget.dart';
import 'package:ahzir/widgets/error/error_page.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/inventory/add_lantern_code_dialog.dart';
import 'package:ahzir/widgets/scroll_view/scrolls.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/store/inventory_card.dart';
import 'package:ahzir/widgets/store/user_purchased_carts.dart';
import 'package:ahzir/widgets/text_inputs/text_input_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ahzir/widgets/inventory/add_to_cart_dialog.dart';

Future<void> addToCart(Map<String, dynamic> item, int quantity) async {
  final prefs = await SharedPreferences.getInstance();
  String? encodedList = prefs.getString('store');
  List<dynamic> cartList = [];
  if (encodedList != null) {
    cartList = jsonDecode(encodedList);
  }
  cartList.add({
    ...item,
    'quantity': quantity,
  });
  await prefs.setString('store', jsonEncode(cartList));
}

class Inventory extends StatefulWidget {
  //user purchases
  final int? championshipId;
  final int? dayNumber;

  const Inventory({this.championshipId, this.dayNumber, super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<PurchaseModel> userPurchasedList = [];
  List<StoreModel> inventoriesList = [];
  DataLoadState inventoryState = DataLoadState.loading;
  String? inventoryError;
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  int limit = 10;
  bool _isLoadingData = false;
  bool dataFinishedOnScroll = false;
  StoreViewModel? _storeProvider;
  TextEditingController lanternCodeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? messageValidationModeCode =
      AutovalidateMode.onUserInteraction;
  DataLoadState inventoryListState = DataLoadState.loading;
  String? inventoryListError;
  int _pageInventory = 1;
  int limitInventory = 100;
  bool _isLoadingDataStore = false;
  bool dataFinishedOnScrollStore = false;
  AuthViewModel? authProvider;
  List<ContentManagementModel> cms = [];

  @override
  void initState() {
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    _storeProvider = Provider.of<StoreViewModel>(context, listen: false);
    getInventories();
    getListOfInventories();
    checkPopUpIfDisplayedWhenAppOpened();
    _scrollController.addListener(() {
      if (!_isLoadingData &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        getInventories();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Coupons',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // First section - Lanterns title and horizontal scroll
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                Text("Coupons", style: TextStyle(fontSize: fontSize20)).tr(),
          ),
          const SizedBox(height: 20),
          buildContent(
            dataLoadState: inventoryListState,
            loadingWidget: SizedBox(
                height: 100, // Fixed height for loading state
                child: inventorySkeleton(context: context)),
            errorWidget: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Add this
                children: [
                  Text("$inventoryListError",
                      style: TextStyle(fontSize: fontSize20)),
                  const SizedBox(height: 20),
                  AppButton(
                    width: 180,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: () {
                      setState(() {
                        inventoryListError = null;
                        inventoryListState = DataLoadState.loading;
                        _isLoadingDataStore = false;
                        dataFinishedOnScrollStore = false;
                        getListOfInventories();
                      });
                    },
                    text: 'Refresh',
                    textColor: blackColor,
                  )
                ],
              ),
            ),
            loadedWidget: inventoriesList.isNotEmpty
                ? horizontalScroll(
                    context: context,
                    widget: List.generate(inventoriesList.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: 250,
                          child: GestureDetector(
                            onTap: () async {
                              final result =
                                  await showDialog<Map<String, dynamic>>(
                                context: context,
                                builder: (context) => AddToCartDialog(
                                  item: inventoriesList[i].toJson(),
                                  initialQuantity: 1,
                                ),
                              );
                              if (result != null) {
                                print("addeddd: ${result['item']} -- ${result['quantity']}");
                                addToCart(result['item'], result['quantity']);
                                appSnackBar(
                                    context: context,
                                    msg: 'Coupon added to the cart!'.tr(),
                                );
                              }
                            },
                            child: InventoryCard(cardInfo: inventoriesList[i]),
                          ),
                        ),
                      );
                    }),
                  )
                : SizedBox(
                    height: 100, // Fixed height for error state
                    child: ErrorTextPage(errorText: "No data found"),
                  ),
          ),

          const SizedBox(height: 30),
          // Second section - My Lanterns title and vertical scroll
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("Purchased Coupons",
                    style: TextStyle(fontSize: fontSize20))
                .tr(),
          ),
          const SizedBox(height: 10),
          // Make this section fill remaining space
          Expanded(
            child: buildContent(
              dataLoadState: inventoryState,
              loadingWidget: inventorySkeleton(context: context),
              errorWidget: ErrorPage(
                errorText: inventoryError,
                onPressed: () {
                  setState(() {
                    inventoryError = null;
                    inventoryState = DataLoadState.loading;
                    _isLoadingData = false;
                    dataFinishedOnScroll = false;
                    getInventories();
                  });
                },
              ),
              loadedWidget: userPurchasedList.isNotEmpty
                  ? ListView.builder(
                      // Change to ListView.builder
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      itemCount:
                          userPurchasedList.length + (_isLoadingData ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i < userPurchasedList.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: UserPurchasedCarts(
                              cardInfo: userPurchasedList[i],
                              championshipId: widget.championshipId,
                              onTap: widget.championshipId != null
                                  ? () => useCartForCampaign(
                                      storePackageId:
                                          userPurchasedList[i].storePackage.id)
                                  : null,
                            ),
                          );
                        } else {
                          return const CircularProgressWidget();
                        }
                      },
                    )
                  : Center(
                      child:
                          ErrorTextPage(errorText: "You don't have any item."),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  getInventories() async {
    if (!_isLoadingData && !dataFinishedOnScroll) {
      setState(() {
        _isLoadingData = true;
      });
      Response response =
          await _storeProvider?.getUserPurchases(page: _page, limit: limit);
      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> data = response.data['data'];
        List<PurchaseModel> purchases =
            data.map((purchase) => PurchaseModel.fromJson(purchase)).toList();
        userPurchasedList.addAll(purchases);
        if (purchases.length < limit) {
          dataFinishedOnScroll = true;
        }
        inventoryState = DataLoadState.loaded;
        _isLoadingData = false;
        _page++;
      } else {
        if (_page > 1) {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        } else {
          inventoryState = DataLoadState.error;
          inventoryError = response.data['message'];
        }
      }
    }
    setState(() {
      userPurchasedList;
      inventoryState;
      inventoryError;
      _page;
      _isLoadingData;
      dataFinishedOnScroll;
    });
  }

  getListOfInventories() async {
    //btred l inventories lmawjoudin bl store
    if (!_isLoadingDataStore && !dataFinishedOnScrollStore) {
      setState(() {
        _isLoadingDataStore = true;
      });
      Response response = await _storeProvider?.getStore(
          page: _pageInventory, limit: limitInventory, campaignName: null);
      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> data = response.data['data'];
        List<StoreModel> purchases =
            data.map((purchase) => StoreModel.fromJson(purchase)).toList();
        inventoriesList.addAll(purchases);
        if (purchases.length < limitInventory) {
          dataFinishedOnScrollStore = true;
        }
        inventoryListState = DataLoadState.loaded;
        _isLoadingDataStore = false;
        _pageInventory++;
      } else {
        if (_page > 1) {
          appSnackBar(
              context: context, msg: response.data['message'], isError: true);
        } else {
          inventoryListState = DataLoadState.error;
          inventoryListError = response.data['message'];
        }
      }
    }
    setState(() {
      inventoryListState;
      inventoryListError;
      _page;
      _isLoadingDataStore;
      dataFinishedOnScrollStore;
    });
  }

  // l user hone 3m yfut w yna2e llantern lli bdo yesta3mela bl campaign
  useCartForCampaign({required int storePackageId}) async {
    if (widget.championshipId != null) {
      var data = {
        'championshipId': widget.championshipId,
        'storepackageId': storePackageId,
        'dateNow': getLocalDate(DateTime.now().toString()),
        "matchdaynumber": widget.dayNumber,
      }; // Convert list of objects to list of maps
      Response response =
          await _storeProvider?.useLantern(context: context, data: data);
      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        appSnackBar(context: context, msg: 'Submitted Successfully');
        Navigator.pop(context, true);
      }
    }
  }

  setRedeemCode() async {
    Response response = await _storeProvider?.addRedeemCode(
        context: context, code: int.parse(lanternCodeController.text));
    // debugPrint("status code: ${response.statusCode}");
    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      setState(() {
        dataFinishedOnScroll = false;
        _page = 1;
        userPurchasedList.clear();
        inventoryState = DataLoadState.loading;
        inventoryError = null;
      });
      getInventories();
    } else {
      appSnackBar(
          context: context, msg: response.data['message'], isError: true);
    }
  }

  checkPopUpIfDisplayedWhenAppOpened() async{
    if (_storeProvider?.getPopupEnteredInventory == false) {
      Response response = await authProvider?.getContentManagement();
      if (response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        List<dynamic> res = response.data;
        cms = res.map((e) => ContentManagementModel.fromJson(e)).toList();
        ContentManagementModel? inventoryRules =
        cms.any((item) => item.code == 'inventoryRules')
            ? cms.firstWhere((item) => item.code == 'inventoryRules')
            : null;
        if(inventoryRules != null) {
          CMSDialog(title: inventoryRules.title,
              content: inventoryRules.description,
              context: context,
              onPressed: () {
                _storeProvider?.setPopupEnteredInventory = true;
              });
        }
      }
    }
  }
}
