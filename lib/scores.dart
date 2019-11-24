import 'dart:io';
import 'package:boggle_game/scoreFIle.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class ScoresScreen extends StatefulWidget {
  @override
  _ScoresScreenState createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  List<Scores> _scores = List<Scores>();

  readScores() async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/scores.json');
    List json = jsonDecode(await file.readAsString());
    List<Scores> auxScores = [];
    for(var score in json) {
      auxScores.add(Scores.fromJson(score));
    }
    setState(() => _scores = auxScores);
  }

  deleteScore() async {
    _scores.clear();
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/scores.json');
      String jsonText = jsonEncode(_scores);
      await file.writeAsString(jsonText);
    } catch (e) {
      /*Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar datos'),
      ));*/
    }
  }

  @override
  void initState() {
    readScores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).accentColor,
            onPressed: () {         
              setState(() {
                deleteScore();
              });
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor,
        ),
        title: Text(
          'Puntuaciones',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _scores.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_scores[index].name),
              trailing: Text('${_scores[index].score}'),
              contentPadding: EdgeInsets.only(right: 55, left: 55),
            );
          },
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
