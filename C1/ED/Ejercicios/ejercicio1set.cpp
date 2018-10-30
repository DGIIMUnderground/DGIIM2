// Ejemplo de funciones de unión e intersección usando el tipo set.
// By Mapachana
#include <iostream>
#include <set>

using namespace std;

// ¡Ojo: la palabra union está reservada!

set <int> uniones (set <int> aa, set <int> bb){
	set <int> ::iterator ita;
	set <int> ::iterator itb;
	set <int> c;
	c = aa;
	for (ita = aa.begin(); ita != aa.end(); ++ita)
		for (itb = bb.begin(); itb != bb.end(); ++itb)
			if (*itb != *ita)
				c.insert(*itb);
	return c;

}

set <int> intersecciones (set <int> aa, set <int> bb){
	set <int> ::iterator ita;
	set <int> ::iterator itb;
	set <int> c;
	for (ita = aa.begin(); ita != aa.end(); ++ita)
		for (itb = bb.begin(); itb != bb.end(); ++itb)
			if (*ita == *itb)
				c.insert(*itb);
	return c;
}


int main(){
	set <int> a;
	a.insert(2);
	a.insert(4);
	a.insert(5);
	a.insert(1);
	a.insert(3);
	a.insert(9);

	cout << "Mi conjunto a es:" << endl;
	set <int> ::iterator it;
	for (it = a.begin(); it != a.end(); ++it){
		cout << " " << *it;
	}
	cout << endl;

	set <int> b;
	b.insert(2);
	b.insert(4);
	b.insert(5);
	b.insert(1);
	b.insert(3);
	b.insert(10);

	cout << "Mi conjunto b es:" << endl;
	set <int> ::iterator itt;
	for (itt = b.begin(); itt != b.end(); ++itt){
		cout << " " << *itt;
	}
	cout << endl;

	cout << "Union de a y b:" << endl;
	set <int > c = uniones(a,b);
	set <int> ::iterator ittt;
	for (ittt = c.begin(); ittt != c.end(); ++ittt){
		cout << " " << *ittt;
	}
	cout << endl;

	cout << "Interseccion de a y b:" << endl;
	set <int> d = intersecciones(a,b);
	set <int> ::iterator itttt;
	for (itttt = d.begin(); itttt != d.end(); ++itttt)
		cout << " " << *itttt;
	cout << endl;

}
