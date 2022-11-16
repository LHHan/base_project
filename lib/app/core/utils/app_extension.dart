/* Define app extension */

/// Extension for screen util
extension SizeExtension on num {}

/// Extension for DateTime
extension DateTimeExtension on DateTime {}

/// Extension for DateTime from String
extension DateTimeStringExtendsion on String {}

/// Extension for duration
extension DurationExtension on Duration {}

/// Extension for int
extension IntExtensions on int {}

/// Extension for num
extension NumExtensions<T extends num> on T {}

/// Extension for T
extension AnyExtensions<T> on T {
  /// Check Null
  bool get isNull => this == null;

  T safe(T Function() supplier) => this ?? supplier();
}

/// Extension for Object
extension Lambdas<T> on T {}

/// Extension for Comparable on Iterable
extension ComparableIterableExtensions<E extends Comparable<E>> on Iterable<E> {
}

/// Extension for Set
extension SetExtensions<E> on Set<E> {}

/// Extension for Map
extension MapExtensions<K, V> on Map<K, V> {}

/// Extension for Iterable of Iterable
extension IterableIterableExtensions<E> on Iterable<Iterable<E>> {}

/// Extension for Comparable
extension ComparableExtensions<T> on Comparable<T> {}

/// Extension for Iterable
extension IterableExtensions<E> on Iterable<E> {}

/// Extension for List
extension ListExtensions<E> on List<E> {}
