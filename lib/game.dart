import 'package:flutter/material.dart';
import 'boogle.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int nTablero = 1;
  Nodo trie;
  Tablero tablero;

  @override
  void initState() {
    tablero = Tablero();
    tablero.crearTableroNuevo();
    //initTrie();
    super.initState();
  }

  /*initTrie() async{
    await trie.inicializar('../dic/diccionario.txt');
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Tablero $nTablero'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 250,
              height: 275,
              child: Board(
                boardData: tablero.getTablero(),
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}

class Board extends StatelessWidget {
  final String boardData;

  const Board({
    Key key,
    this.boardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(25, (index) {
        return Center(
          child: Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            child: Text(
              '${boardData[index]}',
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: Colors.black, fontSize: 20),
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(
                  Radius.circular(5),
              ),
            ),
          ),
        );
      }),
      mainAxisSpacing: 6,
    );
  }
}
