# Exámenes de ED

## Exámen de Enero de 2018

> By Mapachana

### Ejercicio 1

__Razonar la verdad o falsedad de las siguientes afirmaciones:__

- __El orden en que las hojas se listan en los recorridos preorden,inorden y postorden de un árbol binario es el mismo en los tres casos.__

Verdad, ya que las hojas siempre se listan de izquierda a derecha.

- __Dado un árbol binario cuyas etiquetas están organizadas como un árbol binario de búsqueda, puedo recuperarlo a partir de su preorden.__

Verdad, ya que puedes saber cuáles son sus hijos derecha.

- __Dado un árbol binario cuyas etiquetas están organizadas como un árbol parcialmente ordenado, puedo recuperarlo a partir de su postorden.__

Verdad, ya que siempre se van rellenando todas las hojas de izquierda a derecha y no hay hijo derecha si todos los hijos anteriores a izquerda están no vacíos.

- __Es correcto en un esquema de hashing cerrado el uso como función hash de la función h(k)=k+random(M)%M, M primo y con random(M) una función que devuelve un número entero aleatorio entre 0 y M-1.__

Falso, porque a un mismo elemento le puede corresponder dos claves distintas al mismo elemento en acceso distintos.

- __Es correcto en un esquema de hashing doble el uso como función hash secundaria de la función h(x)=((B-1)-(x%B))%B con B primo.__

Falso, porque h no puede anularse.

### Ejercicio 3

__Supongamos que tenemos una clase Liga que almacena los resultados de enfrentamientos en una liga de baloncesto:__

```c_cpp
struct enfrentamiento{
  unsigned char eq1,eq2; //Códigos de los equipos enfrentados.
  unsigned int puntos_eq1,puntos_eq2; //Puntos por cada equipo.
};
class liga{
  private:
      list<enfrentamiento> res;
  // ...
};
```

__Implementa un método que dado un código de equipo obtenga el número de enfrentamientos que ha ganado. Implementa la clase iterator dentro de la clase Liga que permita recorrer los enfrentamientos en los que el resultado ha sido el empate. Implementar los métodos begin() y end().__

```c++
int enfrentamientosganados(unsigned char eq){
  list<enfrentamiento>::iterator it;
  int contador = 0;
  for(it = res.begin(),it != res.end(); ++it){
    if(*it.eq1 == eq && *it.puntos_eq1 > *it.puntos_eq2)
      contador++;
    if(*it.eq2 == eq && *it.puntos_eq2 > *it.puntos_eq1)
      contador++;
  }
  return contador;
}
```

```c++
class empate_iterator{
  private:
  	list<enfrentamientos>::iterator it, final;
  public:
  empate_iterator(){}
  bool operator==(const empate_iterator & i) const{
    return i.it == it;
  }
  bool operator!=(const empate_iterator & i) const{
    return i.it != it;
  }
  enfrentamiento& operator*(){
    return *it;
  }
  iterator & operator++(){
    ++it;
    bool encontrado = false;
    while (it != final && !encontrado){
      if (*it.puntos_eq1 == *it.puntos_eq2)
        encontrado = true;
      else
        ++it;
    }
    return *this;
  }
  friend class liga;
};
empate_iterator begin(){
  empate_iterator i;
  i.it = res.begin();
  i.final = res.end();
  if(!(*(i.it).puntos_eq1 == *(i.it).puntos_eq2))
    ++i;
 	return i;
}

empate_iterator end(){
  empate_iterator i;
  i.it = res.end();
  i.final = res.end();
  return i;
}
```

### Ejercicio 3

__Implementa una función int orden (const list<int > & L) que devuelva 1 si L está ordenada de forma ascendente de principio a fin, 2 si lo está de forma descendente y 0 si no está ordenada__

```c++
int orden (const list<int> & L){
  bool ascendente = true;
  bool descendente = true;
  list<int>::iterator it, it2;
  it = L.begin();
  it2 = ++L.begin();
  while(it != L.end() && it2 != L.end() && (ascendente || descendente)){
    if (*it > *it2)
      ascendente = false;
    if (*it < *it2)
      descendente = false;
    ++it;
    ++it2;
  }
  if (ascendente)
    return 1;
  else if (descendente)
    return 2;
  else
    return 0;
}
```

### Ejercicio 4

__Dado un árbol binario de búsqueda, implementa una función para imprimir las etiquetas de los nodos en orden de mayor a menor profundidad. Si tienen la misma profundidad pueden aparecer en cualquier orden.__

```c++
void imprimeprofundidad(const bintree<int> & arbol){
  queue<bintree<int>::node> cola;
  bintree<int>::node aux = arbol.getraiz();
  cola.push(aux);
  stack<bintree<int>::node> pila;
  while(!cola.empty()){
    aux = cola.front();
    cola.pop();
    pila.push(aux);
    if (aux.right != NULL)
    	cola.push(*(aux.right));
    if (auxx.left != NULL)
    	cola.push(*(aux.left));
  }
  while (!p.empty()){
    aux = pila.top();
    cout << aux.node << " ";
    pila.pop();
  }
}
```

### Ejercicio 5

__Tenemos un contenedor de pares de elementos (clave, bintree < int >) definida como:__

```c++
template <template T>
class contenedor{
  private:
  	unordered_map<T, bintree<int> > datos;
  // ...
};
```

__Implementa un iterador que itere sobre los elementos que cumplan la propiedad de que la suma de los elementos del bintree< int > sea un número par. Debes implementar begin y end.__

```c++
class iterator{
  private:
  	typename unordered_map<T, bintree<T, bintree<int> >::iterator it, final;
  public:
  iterator(){}
  bool operator==(const iterator &i) const{
    return i.it == it;
  }
  bool operator!=(const iterator &i) const{
    return i.it != it;
  }
  pair<const T, bintree<int> > & operator*(){
    return *it;
  }
  iterator & operator++(){
    ++it;
    bool encontrado = false;
    while (it != final && !encontrado){
      if (sumaarbol(*it.second) %2 == 0)
        encontrado = true;
      else
        ++it;
    }
    return *this;
  }
};

iterator begin(){
  iterator i;
  i.it = datos.begin();
  i.final = datos.end();
  if (sumaarbol(*it.second) %2 == 1)
    ++i;
  return i;
}
iterator end(){
  iterator i;
  i.it = datos.end();
  i.final = datos.end();
  return i;
}

int sumaarbol(bintree<int> arbol){
  bintree<int>::node nodo = arbol.getraiz();
  if (node.nulo())
    return 0;
  else
    return *node+sumaarbol(node.left)+sumaarbol(node.right);
}
```

### Ejercicio 6

__Un "heap-doble" es una estructura jerárquica que tiene como propiedad fundamental que para cualquier nodo Z a profundidad a profundidad par la clave almacenada en Z es menor que la del padre pero mayor que la del abuelo (cuando existen), y para cualquier nodo Z a profundidad impar la clave almacenada en Z es mayor que la del padre pero menor que la del abuelo (cuando existen), siendo el árbol binario y estando las hojas empujadas a la izquierda. Diseña una función para insertar un nuevo nodo en la estructura y aplicarla a la construcción de un heap-doble con  las claves {30,25,12,16,10,15,5,18,23,32,4,17}.__

```c++
class heap_doble{
private:
  vector<int> datos;
public:
  void insertar(int clave){
    datos.push(clave);
    int pos = datos.size()-1; //posicion de la clave en el vector
    int padre = (pos-1)/2;
    int abuelo = (padre-1)/2;
    int profundidad = (log(pos+1)/log(2)); //esto lo sabes por gracia divina
    bool colocado = false;
    while(pos > 0 && !colocado){
      if(padre > 0){ //Solo no tiene abuelo si padre > 0
        if (profundidad % 2 == 0){
          if(datos[padre] > datos[pos] && datos[abuelo] < datos[pos])
            colocado = true;
          else{
            if(datos[padre] < datos[pos]){
              swap(datos[padre], datos[pos]);
              pos = padre;
              padre = abuelo;
              abuelo = (padre-1)/2;
            }
            else if(datos[abuelo] > datos[pos]){
              swap(datos[abuelo], datos[pos]);
              pos = abuelo;
              padre = (pos-1)/2;
              abuelo = (padre-1)/2;
            }
          }
        }
        else{ //Profundidad impar
          if(datos[padre] < datos[pos] && datos[abuelo] > datos[pos])
            colocado = true;
          else{
            if(datos[padre] > datos[pos]){
              swap(datos[padre], datos[pos]);
              pos = padre;
              padre = abuelo;
              abuelo = (padre-1)/2;
            }
            else if(datos[abuelo] < datos[pos]){
              swap(datos[abuelo], datos[pos]);
              pos = abuelo;
              padre = (pos-1)/2;
              abuelo = (padre-1)/2;
            }
          }
        }
      } 
      else{ //Solo tiene padre, luego tiene profundidad 1 si o si
        if (datos[padre] < datos[pos])
          colocado = true;
        else{
          swad(datos[padre], datos[pos]);
          pos ) padre;
          colocado = true;
        }
      }
      profundidad--;
    }
  }
};
```




