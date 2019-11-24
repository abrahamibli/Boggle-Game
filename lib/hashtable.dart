import 'dart:core';

class HashTable<K, T> {
  List<_Hash> _list;
  int _capacity, _positionConsulted, _size = 0;
  Function hashing;

  HashTable({capacity = 11, this.hashing = _getHash}) : _capacity = capacity {
    _list = List<_Hash>(_capacity);
  }

  //TODO***********************
  HashTable.fromJson(Map<String, dynamic> json) {
    _list = List<_Hash>(json.length);
    json.forEach((key, value) {
      _Hash haux = _Hash.data(key, value);
      _list.add(haux);
    });
  }

  get size => _size;

  bool contains(K key) {
    int _iterations = 0;
    _positionConsulted = hashing(key, _capacity); 
    
    do{
      if(_list[_positionConsulted] != null) {
        if(_list[_positionConsulted].k == key) {
          return true;
        }else {
          _positionConsulted++;
          if(_positionConsulted == _capacity)
            _positionConsulted = 0;
        }
      }else {
        return false;
      }
      _iterations++;
    }while(_iterations <= _capacity);
    return false;
  }

  void put(K key, T value) {
    if(contains(key)) {
      print('The Key already exist');
    }else {
      _list[_positionConsulted] = _Hash.data(key, value);
      _size++;
      if((_size / _capacity) > 0.75) 
          _rehash();
    }
  }

  getValue(K key) {
    if(contains(key)) {
      return _list[_positionConsulted].t;
    }else {
      return null;
    }
  }

  void remove(K key) {
    if(contains(key)) {
      _list[_positionConsulted] = null;
      _size--;
    }
  }

  static int _getHash(String s, int capacity) {
    int ascii = 0;
    for(int i = 0; i < s.length; i++) {
      ascii += s.codeUnitAt(i);
    }
    return ascii%capacity;
  }

  void _rehash() {
    _capacity = _primoCercano(_size*2);
    int auxIndex;
    bool inserted;

    List<_Hash> newList = List<_Hash>(_capacity);
    _list.forEach((hash) {
      if(hash != null) {
        auxIndex = hashing(hash.k, _capacity);
        inserted = false;
        do{
          if(newList[auxIndex] == null) {
            newList[auxIndex] = hash;
            inserted = true;
          }else
            auxIndex++;
        }while(!inserted);
      }
    });
    _list = newList;
  }

  int _primoCercano(int value) {
    int primo = 0;
    bool divide = false;

    while(primo == 0) {
      divide = false;
      for(int n = 2; n < value; n++) {
        if(value % n == 0) {
          divide = true;
          value++;
          break;
        }
      }
      if(divide == false)
        primo = value; 
    }
    return primo;
  }

  //TODO***************************
  Map<String, dynamic> toJson() => {
    
  };

  @override
  String toString() {
    String l = '';

    _list.forEach((hash) {
      if(hash != null && l == '')
        l += '{${hash.toString()}';
      else if(hash != null)
        l += ', ${hash.toString()}';
    });
    l += '}';
    return l;
  }
}

class _Hash {
  var _t;
  var _k;

  _Hash();

  _Hash.data(this._k, this._t);

  get k => _k;

  set k(k) {
    _k = k;
  }

  get t => _t;

  set t(t) {
    _t = t;
  }

  @override
  String toString() => '$_k: $_t';
}