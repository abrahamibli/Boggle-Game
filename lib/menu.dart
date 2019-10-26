import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key key}) : super(key: key);
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 250,
              child: Image.asset('assets/BoggleBoard.png'),
            ),
            SizedBox(
              height: 75,
            ),
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
            SizedBox(
              height: 10,
            ),
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
