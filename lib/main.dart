/**
* Juego "Boggle" con implementacion de Tries y diccionarios.
* By Uriel Omar Gonzalez 320736
* By Abraham Ibarra Linares 320861
* UACH Facultad de Ingenieria
*/

import 'package:boggle_game/game.dart';
import 'package:boggle_game/menu.dart';
import 'package:boggle_game/help.dart';
import 'package:boggle_game/about.dart';
import 'package:boggle_game/scores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ejecuta la Boggle App
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

/// Controla las 3 diferentes pantallas de la App y 
/// define el diseño base
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boggle Game .AU.',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( // Tema base
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(255, 169, 210, 249), //800
        accentColor: Colors.lightBlue[800], //cyan[600]
      ),
      routes: {
        '/': (context) => MenuScreen(), // Pantalla Inicial del juego
        '/game' : (context) => GameScreen(), // Pantalla que muestra el tablero y la interaccion don el usuario
        '/help' : (context) => HelpScreen(), // Pantalla que muestra las reglas del juego
        '/end' : (context) => EndScreen(), // Pantalla que muestra los resultados
        '/about' : (context) => AboutScreen(), // Pantalla que 
        '/scores' : (context) => ScoresScreen(),
      },
      initialRoute: '/', // Define el Menu como la pantalla principal
    );
  }
}
