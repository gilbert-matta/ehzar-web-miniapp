import 'package:ahzir/models/model/content_management_model.dart';
import 'package:ahzir/models/model/store_model.dart';
import 'package:ahzir/pages/store/Inventory.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../index.dart';

void lanternInfoDialog(BuildContext context, List<StoreModel> lanternList, ContentManagementModel? lanternContent) {
  showDialog(
    context: context,
    builder: (context) => LanternDialog(lanternList: lanternList, lanternContent: lanternContent),
  );
}


class LanternDialog extends StatefulWidget {
  final List<StoreModel> lanternList;
  final ContentManagementModel? lanternContent;

  LanternDialog({
    required this.lanternList,
    required this.lanternContent,
  });

  @override
  _LanternDialogState createState() => _LanternDialogState();
}

class _LanternDialogState extends State<LanternDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 470,
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Lanterns'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Show only 2 lanterns
                    ...widget.lanternList.take(2).map((StoreModel lantern) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          CachedImageNetwork(
                            image: lantern.logo,
                            width: 45,
                            height: 45,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              lantern.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                    // Show More button if more than 2 lanterns
                    if (widget.lanternList.length > 2)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog first
                            nextScreen(context, Inventory());
                          },
                          child: Text(
                            'Show More'.tr(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (widget.lanternContent != null)
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          initiallyExpanded: true,
                          title: Text(
                            "${widget.lanternContent!.title}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "${widget.lanternContent!.description}",
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close'.tr(),
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
