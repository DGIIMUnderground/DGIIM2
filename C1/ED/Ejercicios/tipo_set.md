# STL: tipo `set`

A continuación se muestran algunas funciones para el tipo `set`, junto con la explicación de los métodos de `set` que se están usando.



## Unión de dos conjuntos `set`

~~~c++
#include<set>
using namespace std;

set<int> union_set(const set<int> & a, const set<int> & b) {
	set<int> result(a);
	for ( set<int>::iterator it=b.begin(); it!=b.end(); ++it )
		result.insert(*it);
	return result;
}
~~~

##### Explicación

Basta apreciar que la función `insert` evita repeticiones. Así, partimos de un conjunto `set` y vamos haciendo `insert` de los elementos del otro.



## Intersección de dos conjuntos `set`

~~~c++
#include<set>
using namespace std;

set<int> inter_set(const set<int> & a, const set<int> & b) {
	set<int> result;
	for ( set<int>::iterator it=b.begin(); it!=b.end(); ++it )
		if ( a.find(*it) != a.end() )
			result.insert(*it);
	return result;
}
~~~

##### Explicación

La función `find` devuelve un iterador apuntando al elemento en caso de encontrarlo, y otro apuntando a `end()` en caso de no haberlo encontrado. Por tanto, basta recorrer uno de los conjuntos y comprobar si se encuentra también en el otro, insertándolo en ese caso en un conjunto vacío inicialmente, en el que almacenaremos el resultado.



## Complemento de dos conjuntos `set`

~~~c++
#include<set>
using namespace std;

// compl_set(a,b) hace a-b
set<int> compl_set(const set<int> & a, const set<int> & b) {
	set<int> result;
	for ( set<int>::iterator it=a.begin(); it!=a.end(); ++it )
		if ( b.find(*it) == b.end() ) // no está en b
			result.insert(*it);
	return result;
}
~~~

##### Explicación

Haciendo de nuevo uso de la funcionalidad de `find` previamente explicada, basta recorrer el conjunto `a` e insertar los elementos en un vector vacío siempre que no estén en `b`.
