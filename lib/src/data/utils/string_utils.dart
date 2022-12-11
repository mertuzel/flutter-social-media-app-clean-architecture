import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class StringUtils {
  static String getPublishDateShort(DateTime date) {
    final DateTime currentTime = DateTime.now();
    final difference = currentTime.difference(date);
    initializeDateFormatting('tr_TR');
    if (difference.inDays > 365) {
      return DateFormat('d MMMM yyyy', 'tr_TR').format(date);
    } else if (difference.inDays > 8) {
      return DateFormat('d MMMM', 'tr_TR').format(date);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return "1h";
    } else if (difference.inDays >= 2) {
      return "${difference.inDays}g";
    } else if (difference.inDays >= 1) {
      return "1g";
    } else if (difference.inHours >= 2) {
      return "${difference.inHours}s";
    } else if (difference.inHours >= 1) {
      return "1s";
    } else if (difference.inMinutes >= 2) {
      return "${difference.inMinutes}d";
    } else if (difference.inMinutes >= 1) {
      return "1d";
    } else if (difference.inSeconds >= 3) {
      return "${difference.inSeconds}sn";
    } else {
      return "1sn";
    }
  }

  static String getPublishDateLong(DateTime date) {
    final DateTime currentTime = DateTime.now();
    final difference = currentTime.difference(date);
    initializeDateFormatting('tr_TR');
    if (difference.inDays > 365) {
      return DateFormat('d MMMM yyyy', 'tr_TR').format(date);
    } else if (difference.inDays > 8) {
      return DateFormat('d MMMM', 'tr_TR').format(date);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return "1 Week Before";
    } else if (difference.inDays >= 2) {
      return "${difference.inDays} Days Before";
    } else if (difference.inDays >= 1) {
      return "1 Day Before";
    } else if (difference.inHours >= 2) {
      return "${difference.inHours} Hours Before";
    } else if (difference.inHours >= 1) {
      return "1 Hour Before";
    } else if (difference.inMinutes >= 2) {
      return "${difference.inMinutes} Minutes Before";
    } else if (difference.inMinutes >= 1) {
      return "1 Minute Before";
    } else if (difference.inSeconds >= 3) {
      return "${difference.inSeconds} Seconds Before";
    } else {
      return "Recently";
    }
  }

  static String getDateInDayMonthYearFormat(DateTime date, String divider) {
    initializeDateFormatting('tr_TR');
    return DateFormat('dd${divider}MM${divider}yyyy', 'tr_TR').format(date);
  }

  static String getDateInMinSecFormat(DateTime date) {
    String hour = date.hour.toString().length != 1
        ? date.hour.toString()
        : '0' + date.hour.toString();
    String minute = date.minute.toString().length != 1
        ? date.minute.toString()
        : '0' + date.minute.toString();

    return '$hour:$minute';
  }

  static String getCountdownTime(int countdown) {
    int minutes = countdown ~/ 60;
    int seconds = countdown - (minutes * 60);

    return seconds < 10 ? '0$minutes:0$seconds' : '0$minutes:$seconds';
  }
}
