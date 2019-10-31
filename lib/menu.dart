import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Controla la Pantalla incial del juego
class MenuScreen extends StatefulWidget {
  MenuScreen({Key key}) : super(key: key);
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

/// Define el Widget que muestra el Menu del juego
class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            // Inicia lista de Widgets que aparecen en pantalla de Menu
            /// Coloca la imagen 'png' presente en /assets
            Container(
              width: 250,
              child: Image.asset('assets/BoggleBoard.png'),
            ),
            Text(
              'Boggle!',
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.black,
                    //fontFamily: 'Schyler',
                    fontSize: 60,
                  ),
            ),

            /// Coloca una caja vacia con altura 75 p
            SizedBox(
              height: 50,
            ),

            /// Inserta boton responsable de iniciar partida
            RaisedButton.icon(
              icon: Icon(Icons.play_arrow),
              label: Text(
                '   Jugar      ',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 20),
              ),
              onPressed: () {
                print('nueva partida');
                Navigator.of(context).pushNamed('/game');
              },
              shape: StadiumBorder(),
              elevation: 20,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              height: 10,
            ),

            /// Inserta boton responsable de entrar a pantalla ayuda
            RaisedButton.icon(
              icon: Icon(Icons.help_outline),
              label: Text(
                '  Ayuda      ',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 20),
              ),
              onPressed: () {
                print('ayuda');
                Navigator.of(context).pushNamed('/help');
              },
              shape: StadiumBorder(),
              elevation: 20,
              color: Theme.of(context).accentColor,
            ),

            /// Coloca una caja vacia con altura 10 p
            SizedBox(
              height: 10,
            ),

            /// Inserta boton para salir de la App
            RaisedButton.icon(
              icon: Icon(Icons.info_outline),
              label: Text(
                'Acerca de ',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/about');
              },
              shape: StadiumBorder(),
              elevation: 20,
              color: Theme.of(context).accentColor,
            ),

            /// Coloca una caja vacia con altura 75 p
            SizedBox(
              height: 25,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
