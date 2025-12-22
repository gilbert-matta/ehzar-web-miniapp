
// Render different widgets based on data load state
import 'package:ahzir/functions/data_load_state.dart';
import 'package:ahzir/index.dart';

Widget buildContent({
  required DataLoadState dataLoadState,
  required Widget loadingWidget,
  required Widget loadedWidget,
  required Widget errorWidget,
}) {
  switch (dataLoadState) {
    case DataLoadState.loading:
      return loadingWidget; //if data is loading, return this widget
    case DataLoadState.loaded:
      return loadedWidget; //if data is loaded
    default:
      return errorWidget; //if there was an error
  }
}