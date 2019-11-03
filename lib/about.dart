import 'package:flutter/material.dart';

/// Muestra informacion de personal
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'Acerca de',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            /// Muestra los creditos
            Text(
              """App creada por:\n\nAbraham Ibarra Linares\nUriel Omar González Jimenez
              \nEstudiantes de...""",
              style: Theme.of(context).textTheme.body2.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            /// Caja vacia con altura de 30 p
            SizedBox(
              height: 30,
            ),

            /// Muestra imagen con logo de la Universidad
            Container(
              height: 170,
              child: Image.asset("assets/logoUach.png"),
            ),

            /// Caja vacia con altura de 30 p
            SizedBox(
              height: 30,
            ),

            /// Muestra imagen con logo de la Facultad
            Container(
              height: 155,
              child: Image.asset("assets/logoIngenieria.png"),
            ),
          ],

          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}