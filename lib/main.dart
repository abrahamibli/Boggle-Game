import 'package:boggle_game/game.dart';
import 'package:boggle_game/menu.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boggle Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(255, 169, 210, 249), //800
        accentColor: Colors.lightBlue[800], //cyan[600]
      ),
      routes: {
        '/': (context) => MenuScreen(),
        '/game': (context) => GameScreen()
      },
      initialRoute: '/',
    );
  }
}
