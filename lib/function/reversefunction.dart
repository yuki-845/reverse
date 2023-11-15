import 'dart:ffi';

// ignore: constant_identifier_names
const List<List<int>> WeightOsero = [
  [30, -12, 0, -1, -1, 0, -12, 30],
  [-12, -15, -3, -3, -3, -3, -15, -12],
  [0, -3, 0, -1, -1, 0, -3, 0],
  [-1, -3, -1, -1, -1, -1, -3, -1],
  [-1, -3, -1, -1, -1, -1, -3, -1],
  [0, -3, 0, -1, -1, 0, -3, 0],
  [-12, -15, -3, -3, -3, -3, -15, -12],
  [30, -12, 0, -1, -1, 0, -12, 30],
];
//オセロのコマをひっくり返す関数
// ignore: non_constant_identifier_names
void turnOver(Map<String, List<String>> TogglePlaceDisc, List<List<int>> list,
    int a, int b) {
  for (int i = 0; i < TogglePlaceDisc["$a,$b"]!.length; i++) {
    List<String> X = TogglePlaceDisc["$a,$b"]![i].split(',');
    list[int.parse(X[0])][int.parse(X[1])] =
        list[int.parse(X[0])][int.parse(X[1])] ^ 1;
  }
}

//ひっくり返せるオセロの場所を見つける関数
void findPlacesDisc(
    // ignore: non_constant_identifier_names
    List<List<int>> list,
    // ignore: non_constant_identifier_names
    Map<String, List<String>> TogglePlaceDisc,
    int disc) {
  TogglePlaceDisc.clear();
  List<List<int>> dir = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1],
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1]
  ];
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      List<String> globalToggleDisc = [];
      if (list[i][j] == -1 || list[i][j] == 10) {
        for (int k = 0; k < 8; k++) {
          int x = i;
          int y = j;
          // ignore: non_constant_identifier_names
          int EnemyPlayerDisc = disc;
          // ignore: non_constant_identifier_names
          int PlayerCount = 0;
          List<String> localToggleDisc = [];
          while (true) {
            x += dir[k][0];
            y += dir[k][1];

            if (x >= 0 && x < 8 && y >= 0 && y < 8) {
              if (EnemyPlayerDisc == list[x][y] && PlayerCount > 0) {
                list[i][j] = 10;
                break;
              }
              if (list[x][y] == -1 ||
                  list[x][y] == 10 ||
                  EnemyPlayerDisc == list[x][y]) {
                localToggleDisc = [];
                break;
              }
              PlayerCount++;
              localToggleDisc.add("$x,$y");
            } else {
              break;
            }
          }

          if (localToggleDisc.isNotEmpty) {
            globalToggleDisc.addAll(localToggleDisc);
          }
        }
      }
      if (globalToggleDisc.isNotEmpty) {
        TogglePlaceDisc["$i,$j"] = globalToggleDisc;
      }
    }
  }
}

// オセロのCPU評価関数
String search(Map<String, List<String>> map, List<List<int>> disclist) {
  // ignore: no_leading_underscores_for_local_identifiers
  int _maxitem = -1000000000;
  String answer = "";
  for (var key in map.keys) {
    // ignore: non_constant_identifier_names
    List<List<int>> Disclist = List.generate(
        disclist.length, (index) => List<int>.from(disclist[index]));
    List<String> Y = key.split(",");
    Disclist[int.parse(Y[0])][int.parse(Y[1])] = 1;
    for (int i = 0; i < map[key]!.length; i++) {
      List<String> X = map[key]![i].split(',');
      Disclist[int.parse(X[0])][int.parse(X[1])] =
          Disclist[int.parse(X[0])][int.parse(X[1])] ^ 1;
    }
    int whitedisc = 0;
    int blackdisc = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (Disclist[i][j] == 1) {
          whitedisc += WeightOsero[i][j];
        } else if (Disclist[i][j] == 0) {
          blackdisc += WeightOsero[i][j];
        }
      }
    }
    if ((whitedisc - blackdisc) > _maxitem) {
      answer = key;
      _maxitem = (whitedisc - blackdisc);
    }
  }
  return answer;
}
