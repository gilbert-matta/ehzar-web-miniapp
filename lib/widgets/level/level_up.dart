
import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/level_model.dart';
import 'package:ahzir/widgets/cached_image_network.dart';
import 'package:easy_localization/easy_localization.dart';

void showLevelUpDialog({
  required BuildContext context,
  required LevelModel level,
}) {
  List<LevelTypeModel> levels = level.allLevels;
  int currentLevelIndex = level.allLevels.indexWhere((lvl) {
    return lvl.id == level.id;
  }); // Example: you just hit "Platinum"
  int previousLevelIndex = (currentLevelIndex - 1).clamp(0, levels.length - 1);
  int nextLevelIndex = (currentLevelIndex + 1).clamp(0, levels.length - 1);

  List<LevelTypeModel> visibleLevels = [];
  if (previousLevelIndex < currentLevelIndex) {
    visibleLevels.add(levels[previousLevelIndex]);
  }

  visibleLevels.add(levels[currentLevelIndex]);

  if (nextLevelIndex > currentLevelIndex) {
    visibleLevels.add(levels[nextLevelIndex]);
  }

  ScrollController _scrollController = ScrollController();
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0); // Start with previous level selected

  showDialog(
    context: context,
    builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(0); // Start at previous level

        Future.delayed(Duration(seconds: 2), () {
          double itemWidth = 140; // Adjust to match actual item width
          _scrollController.animateTo(
            itemWidth,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOut,
          );
          selectedIndex.value = 1; // Current level becomes selected
        });
      });

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.grey[900],
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 290,
          width: double.maxFinite,
          child: Column(
            children: [
              Text(
                "LEVEL UP!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
              ).tr(),
              const SizedBox(height: 30),
              SizedBox(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: ValueListenableBuilder<int>(
                  valueListenable: selectedIndex,
                  builder: (context, selected, _) {
                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: visibleLevels.length,
                      itemBuilder: (context, index) {
                        bool isSelected = index == selected;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: 120,
                          decoration: BoxDecoration(
                            color: isSelected ? tertiaryColor : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected ? Border.all(color: secondaryColor, width: 2) : null,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedImageNetwork(image: visibleLevels[index].logo, width: 60, height: 60, fit: BoxFit.cover),
                                SizedBox(height: 8),
                                Text(
                                  visibleLevels[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSelected ? 16 : 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                if (isSelected)
                                  Text("New!", style: TextStyle(color: secondaryColor, fontSize: 12)).tr()
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                onPressed: () => Navigator.pop(context),
                child: Text("ok").tr(),
              )
            ],
          ),
        ),
      );
    },
  );
}

