/*
Autor:
	Sergio Quijano Rey
	sergiquijano@gmail.com
*/
#include <iostream>
#include <set>
#include <string>
using namespace std;

// Declaraciones de funciones auxiliares
//==============================================================================
template <class T>
void showset(const set<T> &s);
template <class T>
void infoset(const set<T> &s);
template <class T>
set<T> makeintersection(const set<T> &A, const set<T> &B);
template <class T>
set<T> makeunion(const set<T> &A, const set<T> &B);

// Programa principal
//==============================================================================
int main(int argc, char * argv[]){
	set<char> name1;
	set<char> name2;
	string str1 = "Sergio Quijano Rey";
	string str2 = "Mateo Rivera Uriarte";

	// Creo dos set de nombres
	name1.insert(str1.begin(), str1.end());
	name2.insert(str2.begin(), str2.end());
	
	// Creo la union e interseccion
	set<char> setunion = makeunion(name1, name2);
	set<char> setintersection = makeintersection(name1, name2);

	// Muestro la informacion
	cout << "Nombre 1" << endl;
	infoset(name1);
	cout << "Nombre 2" << endl;
	infoset(name2);
	cout << "Interseccion" << endl;
	infoset(setintersection);
	cout << "Union" << endl;
	infoset(setunion);

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

	for(typename set<T>::iterator i = B.begin(); i != B.end(); i++){
		if(A.find(*i) != A.end()){
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
