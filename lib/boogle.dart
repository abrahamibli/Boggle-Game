import 'dart:math';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart' show rootBundle;


class Nodo {
  static int tam;
  String letra;
  bool fin;
  List<Nodo> rutas;

  Nodo() {
    tam = 0;
    letra = null;
    fin = false;
    rutas = List<Nodo>(32);
  }

  void inicializar() async {
    String file = await rootBundle.loadString('assets/dic/diccionario.txt');
    List<String> lines = file.split('\n');

    try {
      for (String line in lines) {
        line = removeDiacritics(line);
        for(int pos=0;pos<line.length;pos++)
          if(line[pos] == 'ñ') line.replaceFirst(RegExp('ñ'), 'n', pos);
        this.insertar(line);
        Nodo.tam = 0;
      }
    }catch(e) {
      print(e);
    }
  }

  bool estaVacio() {
    bool vacio = true;
    int i = 0;
    while(vacio && i < 32) {
      vacio = (rutas[i] == null) ? true : false;
      i++;
    }
    return vacio;
  }

  int cantidadDeHijos() {
    int hijos = 0;
    int i = 0;
    while(i < 32) {
      if(rutas[i] != null) hijos++;
      i++;
    }
    return hijos;
  }

  void insertar(String palabra) { 
    Nodo trieX = this, aux;
    trieX = buscar(palabra);
    int pos = 0, cual;

    if(trieX.letra != null)
      pos = nuevaPosDePalabra(palabra);
    do {  
      if(pos < palabra.length) {
        cual = indice(palabra[pos]);
        aux = Nodo();
        aux.letra = palabra[pos];
        aux.fin = false;
        trieX.rutas[cual] = aux;
        trieX = trieX.rutas[cual];
      }
      pos++;
    }while(pos < palabra.length);

    trieX.fin = true;
  }

  int nuevaPosDePalabra(String palabra) {
    int i = 0;
    while(i < tam)
      i++;
    return i;  
  }

  Nodo buscar(String palabra) {
    int cual, i = 0;
    Nodo aux = this;

    cual = indice(palabra[i]);
    while(aux.rutas[cual] != null) { 
      aux = aux.rutas[cual];
      tam++;
      i++;
      if(i >= palabra.length)
        break;
      cual = indice(palabra[i]);
    }
    
    return aux;
  }

  int indice(String letra){
    int i = 0;
    if(letra.codeUnitAt(0) >= 'A'.codeUnitAt(0) && letra.codeUnitAt(0) <= 'Z'.codeUnitAt(0))
        i = letra.codeUnitAt(0)-'A'.codeUnitAt(0);
    else if(letra.codeUnitAt(0) >= 'a'.codeUnitAt(0) && letra.codeUnitAt(0) <= 'z'.codeUnitAt(0))
        i = letra.codeUnitAt(0)-'a'.codeUnitAt(0);
    else
        i=-1;
    return i;
  }

  String toString() => "Letra: $letra | $fin";

}

class Tablero {
  Random rand = Random();
  static int tamx=5, tamy=5, numTab=0;
  List<List<String>> letras = List<List<String>>(tamx);
  final String abc = 'aabcdeefghiijklmnoopqrstuuvwxyz';

  String getTablero() {
    StringBuffer buffer = StringBuffer();

    for(List<String> l in letras) {
      for(String s in l) {
        buffer.write(s);
      }
    }
    return buffer.toString();
  }

  //Tablero random nuevo
  crearTableroNuevo() {
    for (var i = 0; i < tamx; i++) {
      List<String> list = new List<String>(tamy);

      for (var j = 0; j < tamy; j++) {
        list[j] = null;
      }
      letras[i] = list;
    }
    for(int i=0;i<tamx;i++) {
      for(int j=0;j<tamy;j++) {
        letras[i][j] = abc[rand.nextInt(abc.length)];
      }
    }
    numTab++;
  }

  bool palabraExiste(String palabra, int pos, int x, int y) {
    if(pos==palabra.length) return true;
    if(letras[x][y] != palabra[pos]) return false;
    for(int i=x-1; i<=x+1; i++) {
      for(int j=y-1; j<=y+1; j++) {
        if((i==x && j==y))
          continue;
        if(i>=0 && j>=0 && i<tamx && j<tamy) {
          if(palabraExiste(palabra, pos + 1, i, j))
            return true;
        }
      }
    }
    return false;
  }
}