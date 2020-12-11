import 'dart:convert';
import '../../utils/bool_extension.dart';
import '../../utils/int_extension.dart';

import 'dart:io';

void main() {

  final file = File("input.txt");
  final input = file.readAsStringSync().trim();
  final day = Day3();

  final lines = LineSplitter().convert(input).map((e) => PasswordLine.entry(e)).toList();
  final result1 = day.exercise1(lines);
  final result2 = day.exercise2(lines);
  print("$result1 ");
  print("$result2 ");
}

class Day3 {
  int countPasswordWithCondition(List<PasswordLine> lines, bool condition(PasswordLine password) ) {
    return lines.fold(0, (previousValue, element) => condition(element) ? previousValue + 1 : previousValue);
  }

  int exercise1(List<PasswordLine> lines) =>
      countPasswordWithCondition(lines, (password) =>
        password.pwd
          .split("")
          .where((char) => char == password.searchedChar)
          .length
          .isInRange(password.min, password.max)
      );


  int exercise2(List<PasswordLine> lines) => 
    countPasswordWithCondition(lines, (password) =>
      (password.pwd[password.min - 1] == password.searchedChar)
        .xor(password.pwd[password.max - 1] == password.searchedChar)
    ); 
}

class PasswordLine {
  final int min;
  final int max;
  final String searchedChar;
  final String pwd;

   PasswordLine._(this.min, this.max, this.searchedChar, this.pwd);

  factory PasswordLine.entry(String entry) {
    final entryParts = entry.split(" ");
    final counts = entryParts[0].split("-");
    return PasswordLine._(
      int.parse(counts[0]),
      int.parse(counts[1]),
      entryParts[1][0],
      entryParts[2]
    );
  }
}