// Only compiled in web builds
import 'dart:js' as js;

DateTime getLocalDateFromJS() {
  final jsDate = js.JsObject(js.context['Date']);
  return DateTime.fromMillisecondsSinceEpoch(jsDate.callMethod('getTime'), isUtc: false);
}
