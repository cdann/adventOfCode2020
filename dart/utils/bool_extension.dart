extension XorExtension on bool {
  bool xor(bool other) =>
    (this && !other) || (!this && other);
}