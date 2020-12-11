import "dart:collection";

class CharList extends ListBase<String> {
  final String _string;

  CharList(this._string);

  String operator[](int index) => _string[index];

  int get length => _string.length;

  void set length(int newLength) { throw new UnsupportedError("Unmodifiable"); }
  
  void operator[]=(int index, String v) { throw new UnsupportedError("Unmodifiable"); }

  List<String> firsts(int count) {
    if (this.length < count) {
      return [];
    }
    return this.sublist(0, count - 1);
  }

  List<String> lasts(int count) {
    if (this.length < count) {
      return [];
    }
    return this.sublist(this.length - count - 1, this.length - 1);
  }
}

extension CharListExtension on String {
  CharList toCharList() => CharList(this);
}