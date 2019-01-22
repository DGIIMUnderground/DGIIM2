# Exámenes de ED

## Examen de Febrero de 2018

> By Mapachana

### Ejercicio 1

__Razonar la verdad o falsedad de las siguientes afirmaciones:__

- __El TDA cola con prioridad se puede implementar de forma óptima usando un heap.__

Verdad, ya que es un árbol en el que los hijos son mayores que el padre.

- __La declaración map< list < int >, string > m; es una declaración válida.__

Verdad.

- __Un AVL puede reconstruirse de forma unívoca dado su recorrido inorden.__

Falso.

- __Es imposible que un árbol binario (con más de dos nodos) sea AVL y APO a la vez.__

Verdad, ya que en APO el nodo izquierda debe ser mayor y el AVL debe ser menor y estar equilibrado.

- __En un esquema de hashing doble nunca puede ocurrir que para dos clavesk1 y k2 distintas coincidan simultáneamente sus valores h y h0.__

Falso, sí puede pasar.

### Ejercicio 2

__Dada una clase libro que almacena las palabras que contiene y la posición (1......n) en que está cada palabra en el libro:__

```c++
struct palabra{
  string pal; //palabra
  unsigned int posicion; //Posicion en la que esta la palabra
};

class libro{
private:
  list<palabra> datos;
  //...
};
```

__Implementar un método que dada una palabra obtenga todas las posiciones en las que aparece. Implementar una clase iterator dentro de la clase libro que permita recorrer las palabras que comiencen por la z y estén en una posicion par. Implementar los métodos begin y end.__

```c++
list<int> libro::posiciones (const string & palabra) const {
  list<int> resultado;
  list<palabra>::iterator it;
  for(it = datos.begin(); it != datos.end(); ++it)
    if((*it).pal == palabra)
      resultado.push_back((*it).posicion);
  return resultado;
}
```

```c++
class iterator{
private:
  list<palabra>::iterator it, fin;
public:
  iterator(){}
  bool operator== (const iterator & i) const {
    return it == i.it;
  }
  bool operator!= (const iterator & i) const {
    return it != i.it;
  }
  palabra operator*(){
    palabra aux = {(*it).pal, (*it).posicion};
    return palabra;
  }
  iterator& operator++(){
  /*
    ++it;
    bool encontrado = false;
    while(it != fin && !encontrado)
      if((*it).pal[0] == 'z' && (*it).posicion % 2 == 0)
          encontrado = true;
       else
         ++it;
   */
    ++it;
   	while (it != fin && ((*it).pal[0] != 'z' || (*it).posicion % 2 != 0))
   		++it;
    return *this;
  }
};

iterator begin(){
  iterator i;
  i.it = datos.begin();
  i.fin = datos.end();
  if(!(*it.pal[0] == 'z' && *it.posicion %2 == 0))
    ++it;
  return i;
}

iterator end(){
  iterator i;
  i.it = datos.end();
  i.fin = datos.end();
  return i;
}
```

### Ejercicio 3

__Supongamos que disponemos de un map< string, list< pair < int, int > > > que contiene un conjunto de palabras de un libro y asociada a cada palabra una lista list < pair< int, int > > donde cada par contiene un número de capítulo y una posición dentro del mismo donde aparece dicha palabra. Se pide construir un vector vector< list < string > > donde v [ i-1\] contenga todas las apariciones de lcapítulo i ordenadas alfabéticamente y sin repeticiones.__

```c++
// Es un peñazo, paso
```

### Ejercicio 4

__Implementa una función para determinar si un árbol binario tiene más de un camino desde una hoja a la raíz cuya suma de etiquetas sea k__

```c++
bool suma_k(bintree<int> arbol, int k){
  if(caminossuma_k(arbol.getraiz(),0,k) > 1)
    return true;
  else
    return false;
}

int caminossuma_k(bintree<int>::node nodo, int s, int k){
  if (!nodo.null() && s<=k){
    if(nodo.left().null() && nodo.right.null()){ //Es una hoja
      if(s+*nodo == k)
        return 1;
      else
        return 0;
    }
    else{
      if(s<k)
        return caminossuma_k(nodo.left(),s+*nodo,k)+caminossuma_k(nodo.right(),s+*nodo,k);
      else
        return 0;
    }
  }
  else
    return 0;
}
```

---
### Ejercicio 5

__Tenemos un contenedor de pares de elementos definido como:__

```c++
class contenedor{
  private:
  	map<string,bintree<int>> datos;
  // ...
};
```

__Implementar un iterador que itere sobre los string de longitud 4 y para los que el bintree< int > tenga una estructura de árbol binario de búsqueda.__

```c++
bool esbinario(bintree<int>::node nodo){
  if(nodo.null() || (nodo.left().null() && nodo.right().null()))
    return true;
  else{
    if (*(nodo.left()) < *nodo && !nodo.left().null()){
      bool izquierda = esbinario(nodo.left())
    }
    if (*(nodo.right()) > *nodo && !nodo.right().null()){
      bool derecha = esbinario(nodo.right())
    }
    return izquierda && derecha;
  }
}

class iterator{
private:
  map<string,bintree<int>>::iterator it, fin;7
public:
  iterator(){}
  bool operator==(const iterator & i){
    return i.it == it;
  }
  bool operator!=(const iterator & i){
    return i.it != it;
  }
  pair<const string, bintree<int>>& operator*{
    return *it;
  }
  iterator & operator++(){
    ++it;
    bool encontrado = false;
    while(it != fin && !encontrado){
      if(*it.first.size()==4 && esbinario(*it.second.getraiz()))
        encontrado = true;
      else
        ++it;
    }
    return *this;
  }
};s

iterator begin(){
  iterator i;
  i.it = datos.begin();
  i.fin = datos.end();
  if(!(*it.first.size()==4 && esbinario(*it.second.getraiz())))
    ++it;
  return i;
}

iterator end(){
  iterator i;
  i.it = datos.end();
  i.fin = datos.end();
  return i;
}
```

### Ejercicio 6

__Un APO sesgado es un árbol binario que tiene como propiedad fundamental el que para cualquier nodo Z la clave almacenada en Z es menor que la del hijo izquierda de Z y esta a su vez es menor que la del hijo derecha (cuando existen), y estandi las hojas empujadas a la izquierda. Implementar una función para insertar un nuevo nodo en la estructura y aplicarlo a la construcciónd de un APO sesgado con las claves {29,24,11,15,9,14,4,17,22,31,3,16}__

```c++
class APO_sesgado{
private:
  vector<int> datos;
public:
  void aniadir(bintree<int>::node n){
    int pos = datos.size();
    datos.push_back(n);
    //pos padre k-1 / 2 pos hijo izqd 2k+1 y derecho 2k+2
    int padre = (pos-1)/2;
    bool colocado = false;
    int hermanoderecha;
    
    while(pos > 0 && !colocado){
      bool hijocorrectoizquierda = (padre*2+1 == pos);
      if (hijocorrectoizquierda){
        hermanoderecha = padre*2+2;
        if(hermanoderecha < datos.size())
          if (datos[pos] > datos[hermanoderecha]){
            swap(datos[pos], datos[hermanoderecha])
          	pos = hermanoderecha;
          }
      }
      else{ //hijo derecha
        int hermanoizquierda = padre*2+1;
        if(datos[pos]<datos[hermanoizquierda]){
          swap(datos[hermanoizquierda], datos[pos])
          pos = hermanoizquierda;
        }
      }
      if(datos[pos] < datos[padre]){
        swap(datos[padre],datos[pos]);
        pos = padre;
        padre = (pos-1)/2;
      }
      else
        colocado = true;
    }
    
  }
};
```


