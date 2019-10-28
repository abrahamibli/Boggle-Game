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
          children: <Widget>[ // Inicia lista de Widgets que aparecen en pantalla de Menu
            /// Coloca la imagen 'png' presente en /assets
            Container(
              width: 250,
              child: Image.asset('assets/BoggleBoard.png'),
            ),
            /// Coloca una caja vacia con altura 75 p
            SizedBox(
              height: 75,
            ),
            /// Inserta boton responsable de iniciar partida
            RaisedButton(
              child: Text(
                'Nueva Partida',
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
            /// Coloca una caja vacia con altura 10 p
            SizedBox(
              height: 10,
            ),
             /// Inserta boton para salir de la App
            RaisedButton(
              child: Text(
                '        Salir         ',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 20),
              ),
              onPressed: () {
                print('salir');
                SystemNavigator.pop();
              },
              shape: StadiumBorder(),
              elevation: 20,
              color: Theme.of(context).accentColor,
            ),
            /// Coloca una caja vacia con altura 75 p
            SizedBox(
              height: 75,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
