#include <iostream>
#include <set>
#include <ctime>
#include <cstdlib>
using namespace std;

/*
Dados tres conjuntos de enteros realizar el siguiente ejercicio:
 1.- Implementa una función para calcular el conjunto intersección de tres conjuntos.
 2.- Implementa una función para calcular el conjunto resultante de la unión diferencial de tres conjuntos
     A, B y C formada por los elementos de A que no están ni en B ni en C, unión con los de B que no están
     ni en A ni en C.  unión con los de C que no están ni en A ni en B.
*/

//FUNCIONES AUXILIARES
/**
 * @brief Imprime un conjunto de tipo T sobre el flujo de salida
 * @param s: flujo de salida. Es MODIFICADO
 * @param l: el conjunto con los elementos a imprimir
 * @warning Implementado por el profesor
 * */
template <class T> ostream & operator<<(ostream & s, const set<T> & c);

/**
 * @brief Inicializar el generador de numero aleatorios
 *        Esta funcion debe ser llamada antes de usar rand
 * @warning Implementado por el profesor
**/
void InicializarSemilla() { srand(time(0)); }

/**
 * @brief Genera numero enteros positivos aleatorios en el rango [min,max]
 * @warning Implementado por el profesor
**/
int generaEntero(int min, int max);

/**
 * @brief Sobrecarga del operador "+" que actua como union de conjuntos
 * @param a Primer conjunto
 * @param b Segundo conjunto
 * @return Devuelve un conjunto que es la union de a y b
 */
set<int> operator+(const set<int>& a, const set<int>& b);

/**
 * @brief Sobrecarga del operador "*" que actua como interseccion de conjuntos
 * @param a Primer conjunto
 * @param b Segundo conjunto
 * @return Devuelve un conjunto que es la interseccion de a y b
 */
set<int> operator*(const set<int>& a, const set<int>& b);

/**
 * @brief Sobrecarga del operador "/" que actua como diferencia de conjuntos
 * @param a Primer conjunto
 * @param b Segundo conjunto
 * @return Devuelve un conjunto que es la diferencia de a y b
 */
set<int> operator/(const set<int>& a, const set<int>& b);

//PROGRAMA PRINCIPAL
int main(){
	//Primer conjunto
	set<int> a;
	InicializarSemilla();
  	for (int i=0;i<10;i++)
		a.insert(generaEntero(0,10));
	cout<<"A = "<<a<<endl;

	//Segundo conjunto
	set<int> b;
  	for (int i=0;i<10;i++)
		b.insert(generaEntero(0,10));
	cout<<"B = "<<b<<endl;

	//Tercer conjunto
	set<int> c;
  	for (int i=0;i<10;i++)
		c.insert(generaEntero(0,10));
	cout<<"C = "<<c<<endl;

	//Interseccion
	set<int> inter = a*b*c;
	cout<<"Interseccion de (A,B,C) es: "<<inter<<endl;

	//Union diferencial
	set<int> udif = (a/(b+c)) + (b/(c+a)) + (c/(a+b));
	cout<<"Union diferencial de (A,B,C) es: "<<udif<<endl;

	return 0;
}

//IMPLEMENTACION FUNCIONES AUXILIARES
template <class T>
ostream & operator<<(ostream & s, const set<T> & c) {
	typename set<T>::const_iterator i;
	s<<"{";
	for (i=c.begin(); i != c.end(); i++) {
		if (i!=c.begin())
			s<<", ";
		s<<(*i);
	}
	s<<"}";
	return s;
}

int generaEntero(int min, int max){
	int tam= max -min+1;
	return ((rand()%tam)+min);
}

set<int> operator+(const set<int>& a, const set<int>& b) {
	set<int> _union(a);
	_union.insert(b.begin(),b.end());
	return _union;
}

set<int> operator*(const set<int>& a, const set<int>& b) {
	set<int> _interseccion;
	for (set<int>::iterator i=a.begin();i!=a.end();i++)
		if(b.find(*i)!=b.end())
			_interseccion.insert(*i);
	return _interseccion;
}

set<int> operator/(const set<int>& a, const set<int>& b) {
	set<int> _diferencia;
		for (set<int>::iterator i=a.begin();i!=a.end();i++)
			if(b.find(*i)==b.end())
				_diferencia.insert(*i);
	return _diferencia;
}
