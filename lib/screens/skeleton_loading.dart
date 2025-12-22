import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/globals/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

defaultSkeleton(
    {required BuildContext context,
    required DataLoadState loadState,
    required Widget dataWidget,
    required Widget errorWidget,
    required Widget loadingWidget}) {
  return Skeleton(
    isLoading: loadState == DataLoadState.loading ? true : false,
    skeleton: loadingWidget,
    child: loadState == DataLoadState.loaded ? dataWidget : errorWidget,
  );
}

matchSkeleton({required BuildContext context, required int listLength}) {
  return SingleChildScrollView(
    child: Column(
      children: List.generate(listLength, (int i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.2), color: whiteOpacity5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 15, width: 60),
                    ),
                    SizedBox(width: 10),
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: 35, height: 30, shape: BoxShape.circle),
                    ),
                  ],
                ),
                SkeletonLine(
                  style: SkeletonLineStyle(height: 30, width: 60),
                ),
                Row(
                  children: [
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: 35, height: 30, shape: BoxShape.circle),
                    ),
                    SizedBox(width: 10),
                    SkeletonLine(
                      style: SkeletonLineStyle(height: 15, width: 60),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    ),
  );
}

tournamentCardSkeleton({required BuildContext context}){
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(10, (int i){
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: 150,
              height: 120,
              borderRadius: BorderRadius.circular(15)
            ),
          ),
        );
      }),
    ),
  );
}


matchDetailsSkeleton({required BuildContext context}){
  return const SkeletonLine(
      style: SkeletonLineStyle(height: 50, width: 100),
    );
}

searchSkeleton({required BuildContext context}){
  return SingleChildScrollView(
    child: Column(
      children: List.generate(15, (int i){
        return ListTile(
          leading: const SkeletonAvatar(
            style: SkeletonAvatarStyle(
                width: 35, height: 30, shape: BoxShape.circle),
          ),
          title: SkeletonLine(
            style: SkeletonLineStyle(height: 20, width: MediaQuery.of(context).size.width * 0.5),
          ),
        );
      }),
    ),
  );
}

predictionSkeleton({required BuildContext context}){
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: whiteOpacity5,
    ),
    child: ListTile(
      title: Column(
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(height: 20, width: MediaQuery.of(context).size.width * 0.2),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width * 0.2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SkeletonLine(
                  style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width * 0.3),
                ),
              ),
              SkeletonLine(
                style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width * 0.2),
              )
            ],
          ),
        ],
      ),
    ),
  );
}

liveMatchSkeleton({required BuildContext context}){
  return Column(
    children: [
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SkeletonLine(
            style: SkeletonLineStyle(height: 130, width: double.infinity, borderRadius: BorderRadius.circular(12)),
          ),
      ),
    ],
  );
}

teamsSkeleton({required BuildContext context}){
  return Expanded(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        // padding: EdgeInsets.only(right: 100),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Wrap(
              direction: Axis.horizontal, // Fill horizontally first
              spacing: 10.0, // Space between items horizontally
              runSpacing: 20.0, // Space between items vertically
              alignment: WrapAlignment.start,
              children: List.generate(
                20, (int i) {
                return CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.transparent,
                  child: SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                      width: 80,
                      height: 80
                    ),
                  ),
                );
              },
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

favoriteTeamsSkeleton({required BuildContext context}){
  return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLine(
          style: SkeletonLineStyle(height: MediaQuery.of(context).size.height * 0.9, width: 100),
        ),
        // teamsSkeleton()
      ],
    );
}

skeletonNotification(context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: List.generate(10, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Skeleton(
                isLoading: true,
                skeleton: SkeletonLine(
                  style: SkeletonLineStyle(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                ),
                child: Container()
            ),
          );
        }),
      ),
    ),
  );
}


carouselIntroSkeleton(){
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.center,
    // mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SkeletonLine(
        style: SkeletonLineStyle(height: 30, width: 300, alignment: Alignment.center),
      ),
      const SizedBox(height: 20),
      SkeletonLine(
        style: SkeletonLineStyle(height: 30, width: 300, alignment: Alignment.center),
      ),
      // teamsSkeleton()
    ],
  );
}

imageIntroSkeleton({required BuildContext context}){
  return SkeletonLine(
      style: SkeletonLineStyle(height: 300, width: MediaQuery.of(context).size.width, alignment: Alignment.center),
    );
}

matchHighlightsSkeleton(){
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        SkeletonLine(
          style: SkeletonLineStyle(height: 200, width: double.infinity),
        ),
        const SizedBox(height:20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 20, width: 100),
        ),
        ...List.generate(10, (i){
          return Column(
            children: [
              Divider(
                height: 30,
                thickness: 0.2,
                indent: 0,
                endIndent: 0,
                color: whiteColor,
              ),
              SkeletonLine(
                style: SkeletonLineStyle(height: 60, width: double.infinity),
              ),
            ],
          );
        })
      ],
    ),
  );
}

groupSkeleton(){
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: SkeletonLine(
      style: SkeletonLineStyle(height: 80, width: double.infinity),
    ),
  );
}

storeSkeleton({required BuildContext context}){
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Wrap(
      runAlignment: WrapAlignment.center,
      direction: Axis.vertical,
      children: List.generate(10, (i){
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SkeletonLine(
            style: SkeletonLineStyle(height: 180, width: MediaQuery.of(context).size.width * 0.88, borderRadius: BorderRadius.circular(12)),
          ),
        );
      }),
    )
  );
}

inventorySkeleton({required BuildContext context}){
  return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Wrap(
        runAlignment: WrapAlignment.center,
        direction: Axis.vertical,
        children: List.generate(10, (i){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SkeletonLine(
              style: SkeletonLineStyle(height: 70, width: MediaQuery.of(context).size.width * 0.88, borderRadius: BorderRadius.circular(12)),
            ),
          );
        }),
      )
  );
}
settingsSkeleton({required BuildContext context, double? height}){
  return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SkeletonLine(
        style: SkeletonLineStyle(height: height ?? 200, width: double.infinity),
      )
  );
}