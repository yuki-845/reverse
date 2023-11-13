import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 1:白 0:黒 -1:空白
  List<List<int>> list = [
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, 1, 0, -1, -1, -1],
    [-1, -1, -1, 0, 1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1]
  ];
  // ignore: non_constant_identifier_names
  Map<String, List<String>> TogglePlaceDisc = {};
  bool flag = true;
  int count = 0;

  void _incrementCounter(int a, int b) {
    setState(() {
      //                      上      下     右    左    右上    左上   右下    左下
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
          if (list[i][j] == 10) {
            list[i][j] = -1;
          }
        }
      }
      if (a != -1 && b != -1) {
        list[a][b] = (count + 1) % 2;
        // ignore: unrelated_type_equality_checks
        if (TogglePlaceDisc["$a,$b"] != Null) {
          for (int i = 0; i < TogglePlaceDisc["$a,$b"]!.length; i++) {
            List<String> X = TogglePlaceDisc["$a,$b"]![i].split(',');
            list[int.parse(X[0])][int.parse(X[1])] =
                list[int.parse(X[0])][int.parse(X[1])] ^ 1;
          }
        }
      }
      TogglePlaceDisc.clear();
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          List<String> globalToggleDisc = [];
          if (list[i][j] == -1 || list[i][j] == 10) {
            for (int k = 0; k < 8; k++) {
              int x = i;
              int y = j;
              // ignore: non_constant_identifier_names
              int EnemyPlayerDisc = count % 2;
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
      print(TogglePlaceDisc);
      count++;
    });
  }

  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _incrementCounter(-1, -1);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: List.generate(8, (row) {
              return Row(
                children: List.generate(8, (col) {
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (list[row][col] == -1 ||
                            list[row][col] == 1 ||
                            list[row][col] == 0) {
                          return;
                        } else {
                          _incrementCounter(row, col);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              0), // ここの値を調整して四角形の角の丸みを変更できます
                        ),
                        side: const BorderSide(
                          color: Colors.black, //色
                          width: 0.4, //太さ
                        ),
                      ),
                      child: ifText(list[row][col]),
                    ),
                  );
                }),
              );
            }),
          ),
        ));
  }
}

Widget ifText(int value) {
  if (value == -1) {
    return const Text("");
  } else if (value == 0) {
    return const Text("●");
  } else if (value == 10) {
    return const Text("俺");
  } else {
    return const Text("◯");
  }
}
