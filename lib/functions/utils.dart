

import 'package:ahzir/index.dart';
import 'package:ahzir/models/model/match_model.dart';
import 'package:ahzir/widgets/match/live_score.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:timeago/timeago.dart' as timeago;

String convertDate(String dateString) {     // returns localTime after converting to utc
  DateTime utcDateTime = DateTime.parse(dateString);
  DateTime localDateTime = utcDateTime.toLocal();

  if (isToday(localDateTime)) {
    DateFormat timeFormat = DateFormat.Hm('en');
    String formattedTime = timeFormat.format(localDateTime);
    return formattedTime;
  } else {
    DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm', 'en');
    return dateFormat.format(localDateTime);
  }
}

String getLocalDate(String dateString) {     // returns localTime after converting to utc
  DateTime utcDateTime = DateTime.parse(dateString);
  DateTime localDateTime = utcDateTime.toLocal();
  // Force English locale for the date format
  final dateFormat = DateFormat('yyyy-MM-dd', 'en');
  String formattedDate = dateFormat.format(localDateTime);
  return formattedDate;
}

String convertToDateTime(String matchDate, String startingAt) { // returns localtime after converting from date..T..time
  try {
    // Combine matchDate and startingAt correctly
    String dateTimeString = "${matchDate}T${startingAt}";

    // Parse the string into a DateTime object (UTC)
    DateTime utcDateTime = DateTime.parse(dateTimeString);

    // Convert UTC to local time
    DateTime localDateTime = utcDateTime.toLocal();

    // Check if the date is today and format accordingly
    if (isToday(localDateTime)) {
      DateFormat timeFormat = DateFormat.Hm('en'); // HH:mm
      return timeFormat.format(localDateTime);
    } else {
      DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm', 'en');
      return dateFormat.format(localDateTime);
    }
  } catch (e) {
    // Handle invalid date format
    // debugPrint("Error parsing date: $e");
    return "Invalid date";
  }
}

bool isToday(DateTime dateTime) {
  DateTime now = DateTime.now();
  return dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day;
}

String formatDate(String date) {  //returns Today, Yesterday, 21 Feb 2025
  DateTime utcDateTime = DateTime.parse(date);
  DateTime localDateTime = utcDateTime.toLocal();

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final messageDate = DateTime(localDateTime.year, localDateTime.month, localDateTime.day);

  if (messageDate.year == today.year &&
      messageDate.month == today.month &&
      messageDate.day == today.day) {
    return 'Today';
  } else if (messageDate.year == yesterday.year &&
      messageDate.month == yesterday.month &&
      messageDate.day == yesterday.day) {
    return 'Yesterday';
  } else {
    DateFormat dateFormat = DateFormat('d MMM yyyy', 'en');
    return dateFormat.format(localDateTime);
  }
}

String localTime(String dateString) {  // Returns localTime 12:02 with AM/PM
  DateTime utcDateTime = DateTime.parse(dateString);
  DateTime localDateTime = utcDateTime.toLocal();

  DateFormat dateFormat = DateFormat('hh:mm a', 'en'); // Adds AM/PM format
  String formattedDate = dateFormat.format(localDateTime);

  return formattedDate;
}



enum PredictionStatus{
  win,
  lose,
  draw
}

enum MatchStatus {
  scheduled,
  live,
  timed,
  in_play,
  paused,
  finished,
  postponed,
  suspended,
  canceled,
}


enum Statuses {
  accepted,
  rejected,
  pending,
}

enum messageType{
  message,
  notification,
}

enum inputType{
  text,
  number,
}

enum fields{
  result,
  home,
  away,
}
enum types{
  daily,
  weekly,
  monthly,
  yearly
}

String capitalizeFirstWord(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

bool isMobile (BuildContext context){
  return MediaQuery.of(context).size.width < 600;
}


Widget widgetPerMatchStatus({required String? matchStatus, required String homeTeamScore, required String awayTeamScore, required String date, double? dateFontSize}){
  final normalizedStatus = matchStatus?.toLowerCase();
  switch(normalizedStatus){
    case "in_play":
    case "live":
    case "paused": return LiveScore(
        teamOneScore: homeTeamScore,
        teamTwoScore: awayTeamScore,
        matchType: capitalizeFirstWord(matchStatus!.toLowerCase()),
        typeFontSize: fontSize9,
        scoreFontSize: fontSize16);
    case "finished": return SizedBox(
      width: 71,
      child: Column(
        children: [
          Text(
            date,
            style: TextStyle(
                fontSize: fontSize10,
                fontFamily: sfArabicRegular),
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.ltr,
          ),
          Text("$homeTeamScore - $awayTeamScore",
              style: TextStyle(
                  fontSize: fontSize16,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
    case "postponed":
    case "suspended": return SizedBox(
    width: 71,
      child: Column(
        children: [
          Text(
            date,
            style: TextStyle(
                fontSize: fontSize10,
                fontFamily: sfArabicRegular),
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.ltr,
          ),
          const SizedBox(height: 1),
          Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(2)),
                child: Text(
                  capitalizeFirstWord(matchStatus!.toLowerCase()),
                  style: TextStyle(
                      fontSize: fontSize10, fontWeight: FontWeight.w400),
                ).tr(),
              ),
          const SizedBox(height: 1),
        ],
      ),
    );
    case "scheduled":
    case "timed": return SizedBox(
      width: 71,
      child: Text(
        date,
        style: TextStyle(
            fontSize: dateFontSize ?? fontSize10,
            fontFamily: sfArabicRegular),
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      ),
    );

    default: return Container();
  }
}

bool isArabic(String? text) {
  // Arabic Unicode range: \u0600-\u06FF
  if(text != null) {
    final arabicRegExp = RegExp(r'[\u0600-\u06FF]');
    return arabicRegExp.hasMatch(text);
  }
  return false;
}


String getFirstLetter(String text){
  if (text.isEmpty) return text; // Handle empty string
  return text[0].toUpperCase();
}

DateTime getMatchDateTime(String matchDate, String startingAt) {
  // Parse the match date and starting time
  DateTime matchDateTime = DateTime.parse('$matchDate $startingAt');

  // Subtract 2 hours from the match time
  return matchDateTime.subtract(const Duration(hours: 2));
}

DateTime convertUtcToLocal(String utcDateTime) { 
  DateTime utcTime = DateTime.parse(utcDateTime);
  return utcTime.toLocal();
}

String numberWithComma(var number) {   //convert a number to number with comma, ex: 1000 -> 1,000
  // Format for numbers less than 1000 with commas
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}


bool isMatchNotCounted(MatchModel? match) {
  return match?.status.toLowerCase() ==
      MatchStatus.suspended.name.toLowerCase() ||
      match?.status.toLowerCase() ==
          MatchStatus.postponed.name.toLowerCase() ||
      match?.status.toLowerCase() ==
          MatchStatus.canceled.name.toLowerCase();
}



getDateByType({required String type}){
  String dateNow;
  final now = DateTime.now();

  if (type == types.daily.name) {
    dateNow = getLocalDate(now.subtract(Duration(days: 1)).toString()); // yesterday
  } else if (type == types.weekly.name) {
    dateNow = getLocalDate(now.toString()); // current date
  } else if (type == types.monthly.name) {
    final previousMonth = DateTime(now.year, now.month - 1, 1);
    dateNow = getLocalDate(previousMonth.toString());
  } else if (type == types.yearly.name) {
    final lastYear = DateTime(now.year - 1, now.month, now.day);
    dateNow = getLocalDate(lastYear.toString());
  } else {
    dateNow = getLocalDate(now.toString()); // fallback
  }
  return dateNow;
}

String shorten(String? text, [int maxLength = 9]) {
  if(text == null)
    return '';
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}


String getPaymentErrorMessage(String resultCode) {
  final messages = {
    '9000': 'Payment successful',
    '8000': 'Payment is processing',
    '4000': 'Payment failed',
    '6001': 'User cancelled the payment',
    '6002': 'Network error occurred',
    '6004': 'Unknown payment result',
  };
  return messages[resultCode] ?? 'Payment failed with code: $resultCode';
}