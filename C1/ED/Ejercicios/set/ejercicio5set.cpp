/*
Autor:
	Sergio Quijano Rey
	sergiquijano@gmail.com
*/
#include <iostream>
#include <set>
#include <string>
#include<stdlib.h>
#include<time.h>
using namespace std;

// Declaraciones de funciones auxiliares
//==============================================================================
void startRandom(){
     srand(time(NULL));     //Inicializo los numeros aleatorios
}
int randomInt(int min, int max){
     int value =  min + rand() % (max +1 - min) ;
     return value;
}

template <class T>
void showset(const set<T> &s);
template <class T>
void infoset(const set<T> &s);
template <class T>
set<T> makeintersection(const set<T> &A, const set<T> &B);
template <class T>
set<T> makeunion(const set<T> &A, const set<T> &B);
template <class T>
set<T> makediff(const set<T> &A, const set<T> &B);
template <class T>
set<T> multyunion(const set<set<T> > &superconjunto);
template <class T>
set<T> multyintersection(const set<set<T> > &superconjunto);

// Programa principal
//==============================================================================
int main(int argc, char * argv[]){
	int num_conjuntos = 10;
	int num_elementos = 200;

	// Inicio la generación de enteros aleatorios
	startRandom();
	
	set<set<int> > superconjunto;

	// Genero los subconjuntos
	for(int i = 0; i < num_conjuntos; i++){
		set<int> subconjunto;
		for(int j = 0; j < num_elementos; j++){
			int val = randomInt(0, 200);
			subconjunto.insert(val);
		}
		superconjunto.insert(subconjunto);
	}

	// Hago los calculos
	set<int> setunion = multyunion(superconjunto);
	set<int> setinter = multyintersection(superconjunto);

	// Muestro los datos
	cout << "Union" << endl;
	infoset(setunion);
	cout << "Interseccion" << endl;
	infoset(setinter);
	

	return 0;	
}


// Implementacion de funcionalidades adicionales
//==============================================================================
template <class T>
void showset(const set<T> &s){
	for(typename set<T>::iterator i = s.begin(); i != s.end(); i++){
		cout << *i << " ";
	}
	cout << endl;
}
template <class T>
void infoset(const set<T> &s){
	cout << "Displaying info:" << endl;
	cout << "\tNumber of elements: " << s.size() << endl;
	cout << "Displaying elements:" << endl;
	cout << "\t";
	showset(s);
}

template <class T>
set<T> makeintersection(const set<T> &A, const set<T> &B){
	set<T> inter;

	for(typename set<T>::iterator i = A.begin(); i != A.end(); i++){
		if(B.find(*i) != B.end()){
			inter.insert(*i);
		}
	}

	return inter;
}

template <class T>
set<T> makeunion(const set<T> &A, const set<T> &B){
	set<T> unionset;

	unionset.insert(A.begin(), A.end());
	unionset.insert(B.begin(), B.end());

	return unionset;
}
template <class T>
set<T> makediff(const set<T> &A, const set<T> &B){
	set<T> diff;

	for(auto a:A){
		if(B.find(a) == B.end()){
			diff.insert(a);
		}
	}

	return diff;
}
template <class T>
set<T> multyunion(const set<set<T> > &superconjunto){
	set<T> unionset;
	for(auto s:superconjunto){
		unionset.insert(s.begin(), s.end());
	}
	return unionset;
}
template <class T>
set<T> multyintersection(const set<set<T> > &superconjunto){
	set<T> inter;

	inter = *superconjunto.begin();

	for(typename set<set<T> >::iterator i=superconjunto.begin(); i != superconjunto.end(); i++){
		inter = makeintersection(inter, *i);
	}


	return inter;

}
