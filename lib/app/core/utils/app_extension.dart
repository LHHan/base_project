/* Define app extension */
import 'dart:math';

import 'package:base_project_getx/app/core/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Extension for screen util
extension SizeExtension on num {}

/// Extension for DateTime
extension DateTimeExtension on DateTime {
  /// Format DateTime to a string with a custom pattern
  String toDateTimeString(
      {String? pattern = 'yyyy-MM-dd HH:mm:ss', String? locale = 'ja-JP'}) {
    try {
      return DateFormat(pattern, locale).format(this);
    } catch (e) {
      return DateFormat(pattern).format(this);
    }
  }

  /// Extract only the date (year, month, day)
  DateTime onlyDate() =>
      isUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

  /// Extract only the month
  DateTime onlyMonth() =>
      isUtc ? DateTime.utc(year, month) : DateTime(year, month);

  /// Extract only the year
  DateTime onlyYear() => isUtc ? DateTime.utc(year) : DateTime(year);

  /// Extract only the time (hour, minute)
  DateTime onlyTime([int? hourValue, int? minuteValue]) {
    return isUtc
        ? DateTime.utc(
            1970, 1, 1, hourValue ?? hour, minuteValue ?? minute, 0, 0, 0)
        : DateTime(
            1970, 1, 1, hourValue ?? hour, minuteValue ?? minute, 0, 0, 0);
  }

  /// Check if the DateTime is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if the DateTime is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if the DateTime is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Add custom number of days to the DateTime
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  /// Subtract custom number of days from the DateTime
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  /// Returns the number of days in the current month
  int daysInThisMonth() =>
      DateTime(year, month + 1, 1).difference(DateTime(year, month, 1)).inDays;

  /// Returns the week number of the year for the current date.
  /// Follows ISO 8601, where the first week of the year is the one containing the first Thursday.
  int weekNumber() {
    // Get the first day of the year (January 1st)
    DateTime firstDayOfYear = DateTime(year, 1, 1);

    // Get the weekday of the first day of the year (1 = Monday, 7 = Sunday)
    int weekdayOfFirstDay = firstDayOfYear.weekday;

    // Adjust the first day of the year to be the first Monday if it is not Monday
    DateTime firstMondayOfYear = weekdayOfFirstDay <= 4
        ? firstDayOfYear.subtract(
            Duration(days: weekdayOfFirstDay - 1)) // First Monday of the year
        : firstDayOfYear
            .add(Duration(days: 8 - weekdayOfFirstDay)); // Next Monday

    // Calculate the difference in days between the current date and the first Monday of the year
    int dayOfYear = difference(firstMondayOfYear).inDays;

    // Return the week number
    return ((dayOfYear / 7) + 1).floor();
  }
}

/// Extension for DateTime from String
extension DateTimeStringExtendsion on String? {
  /// Convert String to DateTime using the given pattern
  DateTime? toDateTime({String? pattern = 'yyyy-MM-dd'}) {
    try {
      return isNullOrEmpty ? null : DateFormat(pattern).parseStrict(this!);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  /// Check if the String is a valid DateTime string in the given pattern
  bool isValidDateTime({String pattern = 'yyyy-MM-dd'}) {
    return toDateTime(pattern: pattern) != null;
  }
}

/// Extension for duration
extension DurationExtension on Duration {}

/// Extension for int
extension IntExtensions on int {}

/// Extension for num
extension NumExtensions<T extends num> on T? {
  bool isBetween(num from, num to, {bool inclusive = false}) {
    final lower = from < to ? from : to;
    final upper = from < to ? to : from;
    return inclusive
        ? lower <= this! && this! <= upper
        : lower < this! && this! < upper;
  }

  bool get isInt => this != null && this!.truncateToDouble() == this!;
}

/// Extension for String
extension StringExtension on String? {
  /// Check Null or Empty
  bool get isNullOrEmpty => isNull || this!.isEmpty;

  /// Check if String is an SVG file
  bool get isSvg => this?.trim().toLowerCase().endsWith('.svg') ?? false;

  /// Parse an integer from the String, return null if not possible
  int? parseInt() => this != null ? int.tryParse(this!) : null;

  /// Parse an double from the String, return null if not possible
  double? parseDouble() => this != null ? double.tryParse(this!) : null;
}

/// Extension for nullable type T
extension AnyExtensions<T> on T? {
  /// Check if the value is null
  bool get isNull => this == null;

  /// Return this if not null, otherwise call supplier function
  T safe(T Function() supplier) => this ?? supplier();
}

/// Extension for Object
extension Lambdas<T> on T {
  T also(void Function(T it) fun) {
    fun(this);
    return this;
  }

  R let<R>(R Function(T it) fun) => fun(this);
}

/// Extension for Comparable on Iterable
extension ComparableIterableExtensions<E extends Comparable<E>>
    on Iterable<E> {}

/// Extension for Set
extension SetExtensions<E> on Set<E> {}

/// Extension for Map
extension MapExtensions<K, V> on Map<K, V>? {
  T? getValueOrNull<T>(K key) {
    final value = this?[key];
    return value is T ? value : null;
  }
}

/// Extension for Iterable of Iterable
extension IterableIterableExtensions<E> on Iterable<Iterable<E>> {}

/// Extension for Comparable
extension ComparableExtensions<T> on Comparable<T> {}

/// Extension for Iterable
extension IterableExtensions<E> on Iterable<E> {
  /// Get the first element or null if the iterable is empty
  E? get firstOrNull => iterator.let((it) => it.moveNext() ? it.current : null);

  /// Get the last element or null if the iterable is empty
  E? get lastOrNull {
    final Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    E result;
    do {
      result = it.current;
    } while (it.moveNext());
    return result;
  }

  /// Group elements by a key produced by the given key function
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) {
    return fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) {
        final key = keyFunction(element);
        map.putIfAbsent(key, () => <E>[]).add(element);
        return map;
      },
    );
  }
}

/// Extension for List
extension ListExtensions<E> on List<E> {
  E? getOrNull(int index) => index >= 0 && index < length ? this[index] : null;

  void set(int index, E element) {
    if (index >= 0 && index < length) {
      this[index] = element;
    }
  }

  void forEachIndexed(void Function(int index, E element) f) {
    for (int i = 0; i < length; i++) {
      f(i, this[i]);
    }
  }

  /// Map qua các phần tử của danh sách và trả về một danh sách mới với kiểu R
  List<R> mapIndexed<R>(R Function(int index, E value) transform) =>
      mapIndexedTo<R, List<R>>(<R>[], transform);

  /// Map qua các phần tử và thêm chúng vào danh sách đích đã được chỉ định
  C mapIndexedTo<R, C extends List<R>>(
      C destination, R Function(int index, E value) transform) {
    forEachIndexed(
        (int index, E element) => destination.add(transform(index, element)));
    return destination;
  }

  int get lastIndex => length - 1;

  List<E> reversedList() => reversed.toList(growable: false);

  List<E> shuffled([Random? random]) =>
      toList(growable: false)..shuffle(random);

  List<E> sorted(int Function(E a, E b) compare) =>
      toList(growable: false)..sort(compare);

  List<E> sortedBy<T extends Comparable<T>>(T Function(E value) selector) =>
      toList(growable: false)
        ..sort((E a, E b) => selector(a).compareTo(selector(b)));

  void moveAt(int oldIndex, int index) {
    final E item = this[oldIndex];
    removeAt(oldIndex);
    insert(index, item);
  }

  void move(int index, E item) {
    remove(item);
    insert(index, item);
  }

  static List<E> insertBetween<E>(E delimiter, List<E> tokens) {
    final List<E> sb = <E>[];
    bool firstTime = true;
    for (final E token in tokens) {
      if (firstTime) {
        firstTime = false;
      } else {
        sb.add(delimiter);
      }
      sb.add(token);
    }
    return sb;
  }
}

/// Extension for TextTheme
extension TextThemeExtensions on TextTheme {
  // TextStyle for page name
  TextStyle get tsPageName => AppStyles().blackTextStyle(40.sp);

  // TextStyle for label
  TextStyle get tsLabel => AppStyles().normalTextStyle(28.sp);

  // TextStyle for title
  TextStyle get tsTitle => AppStyles().normalTextStyle(20.sp);

  // TextStyle for subTitle
  TextStyle get tsSubTitle => AppStyles().lightTextStyle(18.sp);

  // TextStyle for body, message
  TextStyle get tsBody => AppStyles().normalTextStyle(16.sp);

  // TextStyle for hint
  TextStyle get tsHint => AppStyles().normalTextStyle(16.sp);

  // TextStyle for chip
  TextStyle get tsChip => AppStyles().normalTextStyle(14.sp);

  // TextStyle for button
  TextStyle get tsButton =>
      AppStyles().boldTextStyle(20.sp, color: Colors.white);
}
