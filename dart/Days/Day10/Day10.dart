import 'dart:convert';

import 'dart:io';

void main() {
  final day = Day10();

  final file = File("input.txt");
  final input = file.readAsStringSync().trim();
  final lines = LineSplitter().convert(input).map(int.parse).toList();

  final result1 = day.exercise1(lines);
  print("$result1 ");
  final result2 = day.exercise2(lines);
  print("$result2 ");
}

class Day10 {
  
  int exercise1(List<int> datas) {
    datas.sort();
    var prev = 0;
    var oneDiff = 0;
    var threeDiff = 0;
    datas.forEach((item) {
      final diff = item - prev;
      if (diff == 3) { threeDiff += 1; }
      if (diff == 1) { oneDiff += 1; }
      prev = item;
    });
    return oneDiff * (threeDiff + 1);
  }

  

  int exercise2(List<int> datas) { 
    datas.sort();
    final values = [0] + datas + [datas.last + 3];
    var combinationForVal = { 0 : 1 };
  
    [for(var i=1; i<(values.length - 1); i+=1) i].forEach((index) {
      final adapter = values[index];
      combinationForVal[adapter] = 
        [1, 2, 3].map((lookBack){ 
          final val = index - lookBack < 0 ? null : values[index - lookBack];
          return index - lookBack < 0 ? null : combinationForVal[values[index - lookBack]];
        }).fold(0, (prev, item) {
          print(" ${adapter} ${prev}  ${item ?? 0}");
          return prev + (item ?? 0);
        });
    });
    print(combinationForVal);
    return combinationForVal[values.last];
  }
}