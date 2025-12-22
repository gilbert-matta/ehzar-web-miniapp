import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/pages/store/Inventory.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/pages/store/store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChampionshipPackagesDialog extends StatelessWidget {
  final List<dynamic> packages;
  final Function(int packageId)? onPackageSelected;
  final VoidCallback? onNavigateToStore;
  final void Function()? onPressed;

  const ChampionshipPackagesDialog({
    Key? key,
    required this.packages,
    this.onPackageSelected,
    this.onNavigateToStore,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        "Championship Vouchers".tr(),
        style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
      ).tr(),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            return Card(
              color: Colors.grey[800],
              margin: EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                onTap: () {
                  if (package['availableCount'] == 0) {
                    // Navigate to store page when no packages available
                    if (onNavigateToStore != null) {
                      onNavigateToStore!();
                    }
                    nextScreen(context, Inventory());
                  } else {
                    // Call the callback with package ID when available
                    if (onPackageSelected != null) {
                      onPackageSelected!(package['id']);
                    }
                  }
                },
                leading: CachedImageNetwork(
                  image: package['logo'],
                  width: 40,
                  height: 40,
                ),
                title: Text(
                  package['name'] ?? 'Unknown Package',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${package['price']} ${package['currency']}",
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: package['availableCount'] > 0
                        ? primaryColor
                        : Colors.red[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    package['availableCount'] > 0
                        ? "Available".tr() + " ${package['availableCount']}"
                        : "Go to Store".tr(),
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            "Close",
            style: TextStyle(color: whiteColor),
          ).tr(),
        ),
      ],
    );
  }
}
