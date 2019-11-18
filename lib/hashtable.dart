import 'dart:core';

class HashTable<K, T> {
  List<_Hash> _list;
  int _capacity, _index, _size=0;
  Function hashing;

  HashTable({capacity = 11, this.hashing = _getHash}) : _capacity = capacity {
    _list = List<_Hash>(_capacity);
  }

  void put(K key, T value) {
    bool inserted = false;
    int _iterations = 0;
    _index = hashing(key, _capacity);
    
    do{
      if(_list[_index] == null) {
        _list[_index] = _Hash.data(key, value);
        inserted = true;
        _size++;
        print('${_list[_index]._k}  $_index');
        if((_size / _capacity) > 0.75) 
          _rehash();
      }else {
        _index++;
        if(_index>=_capacity)
          _index=0;
      }
      _iterations++;
    }while(!inserted || _iterations >= _capacity);
    if(!inserted)
      print('HashTable is full');
  }

  getValue(K key) {
    int _iterations = 0;
    _index = hashing(key, _capacity); 
    
    do{
      if(_list[_index] != null) {
        if(_list[_index].k == key) {
          return _list[_index].t;
        }else {
          _index++;
          if(_index>=_capacity)
            _index=0;
        }
      }else {
        return null;
      }
      _iterations++;
    }while(_iterations <= _capacity);
    return null;
  }

  void remove(K key) {
    getValue(key);
    _list[_index] = null;
    _size--;
  }

  get size => _size;

  static int _getHash(String s, int capacity) {
    int ascii = 0;
    for(int i = 0;i < s.length;i++) {
      ascii += s.codeUnitAt(i);
    }
    return ascii%capacity;
  }

  void _rehash() {
    _capacity = _primoCercano(_size*2);
    int index;
    bool inserted;

    List<_Hash> newList = List<_Hash>(_capacity);
    _list.forEach((hash) {
      if(hash != null) {
        index = _getHash(hash._k, _capacity);
        inserted = false;
        do{
          if(newList[index] == null) {
            print('$index    ${hash._k}');
            newList[index] = hash;
            inserted = true;
          }else {
            print('$index    ${hash._k}');
            index++;
          }
        }while(!inserted);
      }
    });
    print(newList[13]);
    _list = newList;
  }

  int _primoCercano(int value) {
    int primo = 0;
    bool divide = false;

    while(primo == 0) {
      divide = false;
      for(int n = 2;n < value;n++) {
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

main(List<String> args) {
  HashTable x = HashTable<String, double>();

  x.put('U', 9.0);
  x.put('A', 100.0);
  x.put('Sebas', 4.20);
  x.put('Carlos', 7.77);
  x.put('ddd', 8.0);
  x.put('ede', 444.0);
  x.put('deded', 2823.22);
  x.put('ddde', 8.0);
  x.put('eded', 444.0);
  x.put('dededd', 2823.22);
  print(x);
  print(x.getValue('Sebas'));
  print(x.getValue('ddd'));
  x.remove('ddd');
  print(x.getValue('ede'));
  print(x);
}