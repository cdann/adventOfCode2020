extension isInRangeExtension on int {
  bool isInRange(int min, int max) =>
    this <= max && this >= min;
}