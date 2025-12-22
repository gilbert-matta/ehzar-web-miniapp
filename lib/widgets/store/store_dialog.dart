
import 'package:ahzir/index.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/text_inputs/text_input_widget.dart';
import 'package:easy_localization/easy_localization.dart';

Future StoreDialogPayment({
  required BuildContext context,
  required VoidCallback? onPressedRedeem,
  required VoidCallback? onPressedCard,
  required TextEditingController redeemController,
}) async {
  PageController _pageController = PageController();
  int _currentPage = 0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void _goToNextPage() {
            if (_currentPage < 1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() => _currentPage++);
            }
          }

          void _goToPreviousPage() {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() => _currentPage--);
            }
          }

          return AlertDialog(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text("Payment").tr(),
            content: Container(
              height: 160,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
                      children: [
                        // Redeem Page
                        Column(
                          children: [
                            SizedBox(
                              height: 140,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppButton(onPressed: (){
                                    _goToNextPage();
                                    onPressedRedeem;
                                  }, text: 'Redeem code'),
                                  const SizedBox(height: 20),
                                  AppButton(onPressed: onPressedCard, text: 'Card'),
                                ],
                              ),
                            )
                          ],
                        ),

                        // Card Payment Page
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                icon: Icon(Icons.arrow_back),
                                color: whiteColor,
                                onPressed: () {
                                  _goToPreviousPage();
                                  redeemController.clear();
                                }
                            ),
                            TextInputWidget(
                                controller: redeemController,
                              maxLines: 1,
                              hintText: "Redeem code",
                            ),
                            const SizedBox(height: 20),
                            AppButton(onPressed: onPressedCard, text: 'Confirm'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((_) {
    // Clear the text field when dialog is dismissed
    redeemController.clear();
  });;
}
