import 'dart:convert';
import 'dart:async';
import 'package:ahzir/functions/utils.dart';
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:ahzir/models/model/user_model.dart';
// import 'package:ahzir/pages/payment_page.dart';
import 'package:ahzir/view-model/store_view_model.dart';
import 'package:ahzir/widgets/alert_dialogs/alert_dialog.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/error/error_text_page.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/store/cart_update_item.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:js/js_util.dart' as js_util;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Map<String, dynamic> userInfo = {};
  List<StoreModel> cartInfo = [];
  // final storage = FlutterSecureStorage();
  late SharedPreferences prefs;
  StoreViewModel? _storeProvider;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _storeProvider = Provider.of<StoreViewModel>(context, listen: false);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initializePrefs();
    _initializeRecaptcha();
    await getUserStoreList();
  }

  void _initializeRecaptcha() {
    try {
      js_util.callMethod(js_util.globalThis, 'initializeRecaptcha', []);
      print("✅ reCAPTCHA initialized");
    } catch (e) {
      print("⚠️ Failed to initialize reCAPTCHA: $e");
    }
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "My Cart",
      ),
      body: cartInfo.isNotEmpty
          ? Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 60, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppButton(
                          width: 120,
                          height: 30,
                          color: redColor,
                          onPressed: () {
                            AlertDialogWidget(
                                context: context,
                                title: 'Warning',
                                content:
                                    'Are you sure you want to delete all items?',
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await prefs.remove('store');
                                  setState(() {
                                    cartInfo = [];
                                  });
                                });
                          },
                          text: 'Delete All'),
                      Column(
                        children: List.generate(cartInfo.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: [
                                CartUpdateItem(
                                  cartInfo: cartInfo[i],
                                  onAddTap: () async {
                                    setState(() {
                                      cartInfo[i].quantity++;
                                    });
                                    await updateOrRemoveItemInStorage(
                                        cartInfo[i], i);
                                  },
                                  onRemoveTap: () async {
                                    if (cartInfo[i].quantity > 0) {
                                      cartInfo[i].quantity--;
                                    }
                                    await updateOrRemoveItemInStorage(
                                        cartInfo[i], i);
                                    if (cartInfo[i].quantity == 0) {
                                      cartInfo.removeAt(i);
                                    }
                                    setState(() {
                                      cartInfo;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        onPressed: () => createOrder(),
                        height: 50,
                        text: 'Place Order'.tr() +
                            '        ${cartInfo[0].currency} ${getTotalAmount().toStringAsFixed(2)}',
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            )
          : ErrorTextPage(
              errorText: 'Your cart is empty',
              localImgUrl: 'cart/empty_cart.png',
              staticImgWidth: 250,
            ),
    );
  }

  Future<void> getUserStoreList() async {
    debugPrint('Getting user store list...');
    // Step 1: Check if data exists
    String? storeResult = prefs.getString('store');
    String? userResult = prefs.getString('userInfo');

    debugPrint("Raw store data: $storeResult");
    debugPrint("Raw user info: $userResult");

    // Step 2: Decode existing data (if available)
    if (storeResult != null && storeResult.isNotEmpty) {
      List<dynamic> decodedList = jsonDecode(storeResult);
      debugPrint("Decoded store list: $decodedList");

      if (userResult != null && userResult.isNotEmpty) {
        try {
          final decodedUser = jsonDecode(userResult);
          userInfo = Map<String, dynamic>.from(decodedUser);
          debugPrint("Decoded user info: $decodedUser");
        } catch (e) {
          debugPrint("Error decoding user info: $e");
        }
      }

      // Convert to StoreModel and update state
      final newCartInfo =
          decodedList.map<StoreModel>((e) => StoreModel.fromJson(e)).toList();
      debugPrint("Converted to ${newCartInfo.length} StoreModel items");

      if (mounted) {
        setState(() {
          cartInfo = newCartInfo;
          debugPrint("Updated cartInfo with ${cartInfo.length} items");
        });
      }
    } else {
      debugPrint("No store data found in SharedPreferences");
      if (mounted) {
        setState(() {
          cartInfo = [];
        });
      }
    }
  }

  Future<void> updateOrRemoveItemInStorage(
      StoreModel updatedItem, int index) async {

    // debugPrint("quantityyyyyy: ${updatedItem.quantity} -- index: ${updatedItem.id}");
    // Step 1: Read the stored data
    String? encodedList = await prefs.getString('store');

    if (encodedList != null) {
      // Step 2: Decode the existing list
      List<dynamic> decodedList = jsonDecode(encodedList);

      // Step 3: Convert it back to StoreModel objects
      List<StoreModel> updatedList =
          decodedList.map((e) => StoreModel.fromJson(e)).toList();

      // Step 4: Check if the item already exists in the list
      for (int i = 0; i < updatedList.length; i++) {
        if (i == index && updatedItem.quantity > 0) {
          // Update the existing item
          updatedList[i] = updatedItem;
        } else if (i == index && updatedItem.quantity == 0) {
          // Remove the item if quantity is zero
          updatedList.removeAt(i);
        }
      }
      // Step 5: Encode the updated list back to JSON
      String updatedEncodedList =
          jsonEncode(updatedList.map((e) => e.toJson()).toList());
      // Step 6: Save the updated list to secure storage
      await prefs.setString('store', updatedEncodedList);
    } else if (updatedItem.quantity > 0) {
      // If no data exists but this is a new item
      await prefs.setString('store', jsonEncode([updatedItem.toJson()]));
    }
  }

  createOrder() async {
    // Get user info
    String? userPrefs = await prefs.getString('userInfo');
    if (userPrefs != null) {
      Map<String, dynamic> decode = jsonDecode(userPrefs);
      user = UserModel.fromJson(decode);
    }
    String? accessToken = await prefs.getString('accessToken');
    
    // Get reCAPTCHA token in the background
    String recaptchaToken = '';
    try {
      recaptchaToken = await _getRecaptchaToken();
      print("✅ reCAPTCHA token obtained: ${recaptchaToken.substring(0, 20)}...");
    } catch (e) {
      print("⚠️ reCAPTCHA failed, continuing without token: $e");
    }

    // Build purchase payload
    var purchaseLantern = cartInfo
        .map((item) => {
              'id': item.id,
              'quantity': item.quantity,
            })
        .toList();
    
    var purchase = {
      "clientName": "${userInfo['firstName']} ${userInfo['lastName']}",
      "clientPhone": userInfo['phone'],
      "email": userInfo['email'] ?? "",
      "note": "",
      "packages": purchaseLantern,
      "referencerBuyerId": user?.qiCustomerId,
      "paymentAuthCode": accessToken,
      "recaptchaToken": recaptchaToken,
    };

    debugPrint("list of purchases: ${purchase}");
    
    // Create order on backend
    Response response =
        await _storeProvider?.createOrder(context: context, data: purchase);
    print("response: ${response.data}");
    print("status code: ${response.statusCode}");
    
    if (response.statusCode != null &&
        (response.statusCode! >= 200 && response.statusCode! <= 399)) {
      _storeProvider?.setOrderId = response.data['orderId'];
      final paymentUrl = response.data['redirectUrl'];
      print('Redirecting to payment URL: $paymentUrl');

      // Call initQiNeoPayment from JavaScript
      try {
        // Check if function exists
        final hasFunction = js_util.hasProperty(js_util.globalThis, 'initQiNeoPayment');
        print('initQiNeoPayment exists: $hasFunction');
        
        if (hasFunction) {
          print('✅ initQiNeoPayment function found, calling it...');
          js_util.callMethod(
            js_util.globalThis,
            'initQiNeoPayment',
            [
              paymentUrl,
              js_util.allowInterop((dynamic result) async {
                final paymentResult = js_util.dartify(result);

                // Get the result code - this is what QI NEO returns
                String resultCode = 'UNKNOWN';
                if (paymentResult is Map) {
                  resultCode = paymentResult['resultCode']?.toString() ?? 'UNKNOWN';
                } else {
                  // If dartify fails, try direct property access
                  resultCode = js_util.getProperty(result, 'resultCode')?.toString() ?? 'UNKNOWN';
                }

                print("Result Code: $resultCode");
                if (resultCode == '9000') {

                  Response response = await _storeProvider?.orderStatus();
                  if (response.statusCode != null && response.statusCode! >= 200 &&
                      response.statusCode! <= 399) {
                    // Payment successful - clear the cart
                    await clearCart();

                    appSnackBar(
                      context: context,
                      msg: getPaymentErrorMessage(resultCode),
                      isError: false,
                    );
                  }

                } else {

                  Response response = await _storeProvider?.orderStatus();
                  if (response.statusCode != null && response.statusCode! >= 200 &&
                      response.statusCode! <= 399) {
                    // Payment is processing
                    print("⏳ Payment is processing...");
                    appSnackBar(
                      context: context,
                      msg: getPaymentErrorMessage(resultCode),
                      isError: true,
                    );
                  }
                }
              }),
            ],
          );
        } else {
          print('❌ initQiNeoPayment function NOT found');
          appSnackBar(
            context: context,
            msg: "Payment handler not initialized",
            isError: true,
          );
        }
      } catch (e) {
        print('❌ Error calling initQiNeoPayment: $e');
        appSnackBar(
          context: context,
          msg: "Payment error: $e",
          isError: true,
        );
      }
    } else {
      appSnackBar(
          context: context, msg: response.data['message'], isError: true);
    }
  }

  Future<String> _getRecaptchaToken() {
    final completer = Completer<String>();
    try {
      js_util.callMethod(
        js_util.globalThis,
        'getRecaptchaToken',
        [
          'login',  // Match backend's expected action
          js_util.allowInterop((bool success, String token) {
            if (success) {
              completer.complete(token);
            } else {
              completer.completeError(Exception('reCAPTCHA failed: $token'));
            }
          }),
        ],
      );
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }


  double getTotalAmount() {
    double total = 0;
    for (var item in cartInfo) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> clearCart() async {
    cartInfo = [];          // clear in memory
    await prefs.setString('store', jsonEncode([]));
    setState(() {
      cartInfo;
    });
  }
}
