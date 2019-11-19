import 'package:flutter/material.dart';
import 'dart:convert';
import 'hashtable.dart';

class ScoresScreen extends StatelessWidget {
  HashTable _scores = HashTable();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'Top Scores',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Nombre'),
              trailing: Text('Puntuacion'),
              contentPadding: EdgeInsets.only(right: 55, left: 55),
            );
          },
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
