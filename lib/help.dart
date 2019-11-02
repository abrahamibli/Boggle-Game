import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          '¿Como Jugar?',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: ListView(
          children: [
            Text(
              """Boggle es un juego de mesa cuyo objetivo es encontrar el mayor numero de palabras en el tablero dado, esta es una version un poco diferente al original.
            \nCada tablero cuenta con 25 letras (5x5) aleatorias y en el se pueden buscar las palabras de manera vertical, horizontal o en diagonales, esto en cualquier direccion.
            \nPor cada palabra encontrada se daran puntos, el numero de puntos esta determinado por la longitud de la palabra encontrada (5 puntos por letra).
            \nFinalmente, se puede refrescar el tablero hasta un maximo de 5 veces
            \n\n""",
              style: Theme.of(context).textTheme.body2.copyWith(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ],
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
