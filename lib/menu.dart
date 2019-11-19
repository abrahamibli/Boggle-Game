import 'package:flutter/material.dart';

/// Define el Widget que muestra el Menu del juego
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            /// Coloca la imagen 'png' presente en /assets
            Container(
              width: 250,
              child: Image.asset('assets/BoggleBoard.png'),
            ),
            
            /// Muestra la palabra 'Boggle' al centro y despues de la imagen
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
              height: 40,
            ),

            /// Inserta boton responsable de iniciar partida
            RaisedButton.icon(
              icon: Icon(Icons.play_arrow),
              label: Text(
                '     Jugar         ',
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
              icon: Icon(Icons.score),
              label: Text(
                'Puntuaciones',
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 20),
              ),
              onPressed: () {
                print('puntuacion');
                Navigator.of(context).pushNamed('/scores');
              },
              shape: StadiumBorder(),
              elevation: 20,
              color: Theme.of(context).accentColor,
            ),
            
            /// Coloca una caja vacia con altura 10 p
            SizedBox(
              height: 10,
            ),

            /// Inserta boton responsable de entrar a pantalla ayuda
            RaisedButton.icon(
              icon: Icon(Icons.help_outline),
              label: Text(
                '     Ayuda        ',
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

            /// Inserta boton 'acerca de' de la App
            RaisedButton.icon(
              icon: Icon(Icons.info_outline),
              label: Text(
                '  Acerca de    ',
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
              height: 23,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
