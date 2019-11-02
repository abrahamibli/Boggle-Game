import 'package:flutter/material.dart';

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
            Text(
              """App creada por:\n\nAbraham Ibarra Linares\nUriel Omar González Jimenez
              \nEstudiantes de...""",
              style: Theme.of(context).textTheme.body2.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: 30,
            ),

            Container(
              height: 170,
              child: Image.asset("assets/logoUach.png"),
            ),

            SizedBox(
              height: 30,
            ),

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